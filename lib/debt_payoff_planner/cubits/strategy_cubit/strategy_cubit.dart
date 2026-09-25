import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repository/debts_repository.dart';
import '../../../database/database.dart';

part 'strategy_state.dart';

const _maxSimulationMonths = 600;

class StrategyCubit extends Cubit<StrategyState> {
  StrategyCubit({required DebtsRepository debtsRepository})
      : _debtsRepository = debtsRepository,
        super(StrategyState());

  final DebtsRepository _debtsRepository;

  Future<void> fetchStrategy() async {
    emit(state.copyWith(status: StrategyStateStatus.loading));
    try {
      final strategy = await _countDebtsPayOffStrategy();
      emit(state.copyWith(
        debtPayoffStrategy: strategy,
        status: StrategyStateStatus.success,
        clearError: true,
      ));
    } on StrategyException catch (e) {
      emit(state.copyWith(
        status: StrategyStateStatus.failure,
        errorMessage: e.message,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: StrategyStateStatus.failure,
        errorMessage: 'Failed to calculate payoff strategy',
      ));
    }
  }

  Future<void> changeExtraPayment(String extraPayment) async {
    emit(state.copyWith(extraPayment: extraPayment));
  }

  Future<void> changeStrategy(String strategy) async {
    emit(state.copyWith(strategy: strategy));
  }

  double _parseExtraPayment(String value) {
    if (value.trim().isEmpty) return 0;
    return double.tryParse(value) ?? 0;
  }

  Future<DebtPayoffStrategy> _countDebtsPayOffStrategy() async {
    int duration = 0;
    double totalInterest = 0.0;
    final debtStrategyReports = <DebtStrategyReport>[];
    var report = DebtStrategyReport();
    final debts = List<Debt>.from(await _debtsRepository.fetchAllDebts());

    if (debts.isEmpty || debts.every((d) => d.currentBalance <= 0)) {
      return _createReport([], 0);
    }

    for (final debt in debts) {
      if (debt.currentBalance > 0 &&
          debt.minimumPayment <= 0) {
        throw StrategyException(
          'Minimum payment for "${debt.name}" must be greater than zero',
        );
      }
      if (debt.currentBalance > 0) {
        final monthlyInterest = (debt.currentBalance * debt.apr / 12) / 100;
        if (monthlyInterest >= debt.minimumPayment) {
          throw StrategyException(
            'Interest on "${debt.name}" exceeds its minimum payment. '
            'Increase the minimum payment or lower the APR.',
          );
        }
      }
    }

    sortDebts(debts, state.strategy);

    var monthsSimulated = 0;

    while (debts.any((d) => d.currentBalance > 0)) {
      monthsSimulated++;
      if (monthsSimulated > _maxSimulationMonths) {
        throw StrategyException(
          'Payoff would take more than $_maxSimulationMonths months. '
          'Increase extra payment or check debt details.',
        );
      }

      double extraPayment = _parseExtraPayment(state.extraPayment);
      final isFullPayedDebt = _isCompletedDebt(debts, extraPayment);
      double tempCurrentBalance;

      if (isFullPayedDebt) {
        if (duration > 0) {
          report.duration = duration;
          for (var i = 1; i < debts.length; i++) {
            final d = debts[i];
            if (d.currentBalance > 0) {
              report.addMinPayment(DebtReportItem(
                name: d.name,
                amount: d.minimumPayment,
                paid: false,
              ));
            }
          }
          debtStrategyReports.add(report);
        }

        report = DebtStrategyReport();
        report.duration = 1;
      }

      for (var i = 0; i < debts.length; i++) {
        var debt = debts[i];
        if (debt.currentBalance <= 0) {
          extraPayment += debt.minimumPayment;
          continue;
        }

        final interest = (debt.currentBalance * debt.apr / 12) / 100;
        final principal = debt.minimumPayment - interest;
        totalInterest += interest;

        tempCurrentBalance = debt.currentBalance;
        debt = debt.copyWith(currentBalance: debt.currentBalance - principal);
        debts[i] = debt;

        if (debt.currentBalance <= 0) {
          report.addExtraPayment(DebtReportItem(
            name: debt.name,
            amount: tempCurrentBalance,
            paid: true,
          ));
          extraPayment = -debt.currentBalance + extraPayment;
          debt = debt.copyWith(currentBalance: 0);
          debts[i] = debt;
        }
      }

      do {
        final unpaidIndex = debts.indexWhere((d) => d.currentBalance > 0);
        if (unpaidIndex < 0) break;

        var debt = debts[unpaidIndex];
        if (debt.minimumPayment == 0 && extraPayment <= 0) break;

        tempCurrentBalance = debt.currentBalance;
        debt = debt.copyWith(currentBalance: debt.currentBalance - extraPayment);
        debts[unpaidIndex] = debt;

        if (debt.currentBalance <= 0) {
          report.addExtraPayment(DebtReportItem(
            name: debt.name,
            amount: tempCurrentBalance + debt.minimumPayment,
            paid: true,
          ));
          extraPayment = -debt.currentBalance;
          debt = debt.copyWith(currentBalance: 0);
          debts[unpaidIndex] = debt;
          continue;
        }
        report.addExtraPayment(DebtReportItem(
          name: debt.name,
          amount: debt.minimumPayment + extraPayment,
          paid: false,
        ));
        extraPayment = 0;
      } while (extraPayment > 0);

      if (isFullPayedDebt) {
        for (final d in debts) {
          if (d.currentBalance > 0) {
            report.addMinPayment(DebtReportItem(
              name: d.name,
              amount: d.minimumPayment,
              paid: false,
            ));
          }
        }
        debtStrategyReports.add(report);
        report = DebtStrategyReport();
        duration = 0;
      } else {
        duration++;
      }
    }

    return _createReport(debtStrategyReports, totalInterest);
  }

  DebtPayoffStrategy _createReport(
      List<DebtStrategyReport> debtStrategyReports, double totalInterest) {
    final totalDuration =
        debtStrategyReports.map((r) => r.duration).fold(0, (a, b) => a + b);
    return DebtPayoffStrategy(
      totalDuration: totalDuration,
      totalInterest: totalInterest,
      debtFreeDate: DateTime.now().add(Duration(days: 30 * totalDuration)),
      reports: debtStrategyReports,
    );
  }

  /// Sorts debts for snowball (lowest balance) or avalanche (highest APR).
  static void sortDebts(List<Debt> debtsList, String strategy) {
    if (strategy == StrategyState.avalanche) {
      debtsList.sort((debt1, debt2) {
        final aprCmp = debt2.apr.compareTo(debt1.apr);
        if (aprCmp != 0) return aprCmp;
        return debt1.currentBalance.compareTo(debt2.currentBalance);
      });
    } else {
      debtsList.sort((debt1, debt2) {
        final balCmp = debt1.currentBalance.compareTo(debt2.currentBalance);
        if (balCmp != 0) return balCmp;
        return debt2.apr.compareTo(debt1.apr);
      });
    }
  }

  bool _isCompletedDebt(List<Debt> debtsList, double extraPayment) {
    final allExtra = extraPayment +
        debtsList
            .where((debt) => debt.currentBalance == 0)
            .map((debt) => debt.minimumPayment)
            .fold(0.0, (a, b) => a + b);

    Debt? debtForExtra;
    for (final d in debtsList) {
      if (d.currentBalance > 0) {
        debtForExtra = d;
        break;
      }
    }

    if (debtForExtra == null) return false;

    final interest = (debtForExtra.currentBalance * debtForExtra.apr / 12) / 100;
    final availableToPrincipal =
        allExtra + debtForExtra.minimumPayment - interest;

    if (debtForExtra.currentBalance <= availableToPrincipal) {
      return true;
    }

    for (final debt in debtsList) {
      if (debt.currentBalance <= 0) continue;
      final debtInterest = (debt.currentBalance * debt.apr / 12) / 100;
      if (debt.currentBalance <= debt.minimumPayment - debtInterest) {
        return true;
      }
    }
    return false;
  }
}

class StrategyException implements Exception {
  final String message;
  StrategyException(this.message);

  @override
  String toString() => message;
}

class DebtPayoffStrategy {
  int totalDuration;
  double totalInterest;
  DateTime debtFreeDate;
  List<DebtStrategyReport> reports;

  DebtPayoffStrategy({
    required this.totalDuration,
    required this.totalInterest,
    required this.debtFreeDate,
    required this.reports,
  });
}

class DebtStrategyReport {
  int duration;
  List<DebtReportItem> extraPayments;
  List<DebtReportItem> minPayments;

  DebtStrategyReport({
    this.duration = 0,
    List<DebtReportItem>? extraPayments,
    List<DebtReportItem>? minPayments,
  })  : extraPayments = extraPayments ?? [],
        minPayments = minPayments ?? [];

  void addExtraPayment(DebtReportItem extra) {
    if (!extraPayments.any((item) => item.name == extra.name)) {
      extraPayments.add(extra);
    }
  }

  void addMinPayment(DebtReportItem min) {
    if (!minPayments.any((item) => item.name == min.name) &&
        !extraPayments.any((item) => item.name == min.name)) {
      minPayments.add(min);
    }
  }
}

class DebtReportItem {
  String name;
  double amount;
  bool paid;

  DebtReportItem({
    required this.name,
    required this.amount,
    required this.paid,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DebtReportItem &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}
