import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../database/database.dart';

part 'strategy_state.dart';

class StrategyCubit extends Cubit<StrategyState> {
  StrategyCubit({required AppDatabase database})
      : _database = database,
        super(StrategyState());

  final AppDatabase _database;

  Future<void> fetchStrategy() async {
    emit(state.copyWith(status: StrategyStateStatus.loading));
    try {
      final strategy = await _countDebtsPayOffStrategy();
      emit(state.copyWith(
          debtPayoffStrategy: strategy,
          status: StrategyStateStatus.success));
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> changeExtraPayment(String extraPayment) async {
    emit(state.copyWith(extraPayment: extraPayment));
  }

  Future<void> changeStrategy(String strategy) async {
    emit(state.copyWith(strategy: strategy));
  }

  Future<DebtPayoffStrategy> _countDebtsPayOffStrategy() async {
    int duration = 0;
    double totalInterest = 0.0;
    final debtStrategyReports = <DebtStrategyReport>[];
    var report = DebtStrategyReport();
    final debts = await _database.getAllDebts();
    _sortDebts(debts, state.strategy);

    // 1. Check if there is any balance to pay
    while (debts.any((d) => d.currentBalance > 0)) {
      double extraPayment = double.parse(state.extraPayment);
      final isFullPayedDebt = _isCompletedDebt(debts, extraPayment);
      double tempCurrentBalance;

      // Check whether there is a fully paid balance or not
      if (isFullPayedDebt) {
        if (duration > 0) {
          report.duration = duration;
          // Add all minPayments to the report except the first one (which is extra payment)
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

        // Reset the report
        report = DebtStrategyReport();
        report.duration = 1;
      }

      // 2. Make minimum payment to all debts
      for (var debt in debts) {
        // If there is any paid debt in the list, add its minimum payment to extraPayment
        if (debt.currentBalance <= 0) {
          extraPayment += debt.minimumPayment;
          continue;
        }

        // Count total interest that is going to be paid
        final interest = (debt.currentBalance * debt.apr / 12) / 100;
        final principal = debt.minimumPayment - interest;
        totalInterest += interest;

        // Temporary variable in case the balance is paid
        tempCurrentBalance = debt.currentBalance;

        final index = debts.indexWhere(
          (element) => element.id == debt.id,
        );
        debt = debt.copyWith(currentBalance: debt.currentBalance - principal);
        debts[index] = debt;

        // Check if the balance is paid
        if (debt.currentBalance <= 0) {
          // If yes, add leftover to extraPayment
          report.addExtraPayment(DebtReportItem(
            name: debt.name,
            amount: tempCurrentBalance,
            paid: true,
          ));
          extraPayment = -debt.currentBalance + extraPayment;
          debt = debt.copyWith(currentBalance: 0);
          debts[index] = debt;
        }
      }

      // 3. Make extra payment
      do {
        // Find the first debt with currentBalance > 0
        var debt = debts.firstWhere(
          (d) => d.currentBalance > 0,
          orElse: () => Debt(
            name: '',
            startBalance: 0,
            currentBalance: 0,
            apr: 0,
            minimumPayment: 0,
            nextPaymentDue: DateTime.now(),
            id: -1,
          ),
        );

        // For the last debt in the list of Debts
        if (debt.minimumPayment == 0) break;

        tempCurrentBalance = debt.currentBalance;

        final index = debts.indexWhere(
          (element) => element.id == debt.id,
        );
        debt =
            debt.copyWith(currentBalance: debt.currentBalance - extraPayment);
        debts[index] = debt;

        // Check if the balance is paid
        if (debt.currentBalance <= 0) {
          report.addExtraPayment(DebtReportItem(
            name: debt.name,
            amount: tempCurrentBalance + debt.minimumPayment,
            paid: true,
          ));
          extraPayment = 0;
          // If yes, add leftover to extraPayment
          extraPayment = -debt.currentBalance + extraPayment;
          debt = debt.copyWith(currentBalance: 0);
          debts[index] = debt;
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

  void _sortDebts(List<Debt> debtsList, String strategy) {
    strategy == "Avalanche"
        ? debtsList.sort((debt1, debt2) {
            if (debt1.apr > debt2.apr) return -1;
            if (debt1.apr < debt2.apr) return 1;
            if (debt1.apr == debt2.apr) {
              if (debt1.currentBalance > debt2.currentBalance) {
                return 1;
              } else {
                return -1;
              }
            }
            return 0;
          })
        : debtsList.sort((debt1, debt2) {
            if (debt1.currentBalance > debt2.currentBalance) return 1;
            if (debt1.currentBalance < debt2.currentBalance) return -1;
            if (debt1.currentBalance == debt2.currentBalance) {
              if (debt1.apr > debt2.apr) {
                return -1;
              } else {
                return 1;
              }
            }
            return 0;
          });
  }

  bool _isCompletedDebt(List<Debt> debtsList, double extraPayment) {
    final allExtra = extraPayment +
        debtsList
            .where((debt) => debt.currentBalance == 0)
            .map((debt) => debt.minimumPayment)
            .fold(0.0, (a, b) => a + b);

    final debtForExtra = debtsList.firstWhere(
      (d) => d.currentBalance > 0,
      orElse: () => Debt(
        name: '',
        startBalance: 0,
        currentBalance: 0,
        apr: 0,
        minimumPayment: 0,
        nextPaymentDue: DateTime.now(),
        id: -1,
      ),
    );

    if (debtForExtra.currentBalance <= allExtra + debtForExtra.minimumPayment) {
      return true;
    }

    for (final debt in debtsList) {
      if (debt.currentBalance > 0 &&
          debt.currentBalance <= debt.minimumPayment) {
        return true;
      }
    }
    return false;
  }
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
