import 'package:flutter_test/flutter_test.dart';
import 'package:qruto_budget/database/database.dart';
import 'package:qruto_budget/debt_payoff_planner/cubits/strategy_cubit/strategy_cubit.dart';
import 'package:qruto_budget/debt_payoff_planner/repository/debts_repository.dart';

Debt _debt({
  required int id,
  required String name,
  required double balance,
  required double apr,
  double startBalance = 0,
  double minPayment = 100,
  DateTime? nextPaymentDue,
}) {
  return Debt(
    id: id,
    name: name,
    startBalance: startBalance > 0 ? startBalance : balance,
    currentBalance: balance,
    apr: apr,
    minimumPayment: minPayment,
    nextPaymentDue: nextPaymentDue ?? DateTime(2026, 1, 15),
  );
}

/// In-memory fake so tests do not need native sqlite.
class FakeDebtsRepository implements DebtsRepository {
  final List<Debt> debts = [];
  final List<Payment> payments = [];
  var _nextDebtId = 1;
  var _nextPaymentId = 1;

  @override
  Future<List<Debt>> fetchAllDebts() async => List.from(debts);

  @override
  Future<Debt?> getDebtById(int debtId) async {
    try {
      return debts.firstWhere((d) => d.id == debtId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<int> insertDebt({
    required String name,
    required double startBalance,
    required double currentBalance,
    required DateTime nextPaymentDue,
    required double apr,
    required double minimumPayment,
  }) async {
    final id = _nextDebtId++;
    debts.add(Debt(
      id: id,
      name: name,
      startBalance: startBalance,
      currentBalance: currentBalance,
      apr: apr,
      minimumPayment: minimumPayment,
      nextPaymentDue: nextPaymentDue,
    ));
    return id;
  }

  @override
  Future<void> updateDebt({
    required int id,
    required String name,
    required double startBalance,
    required double currentBalance,
    required DateTime nextPaymentDue,
    required double apr,
    required double minimumPayment,
  }) async {
    final index = debts.indexWhere((d) => d.id == id);
    if (index < 0) throw StateError('missing');
    debts[index] = Debt(
      id: id,
      name: name,
      startBalance: startBalance,
      currentBalance: currentBalance,
      apr: apr,
      minimumPayment: minimumPayment,
      nextPaymentDue: nextPaymentDue,
    );
  }

  @override
  Future<void> deleteDebt({required int debtId}) async {
    payments.removeWhere((p) => p.debtId == debtId);
    debts.removeWhere((d) => d.id == debtId);
  }

  @override
  Future<List<Payment>> getPaymentsForDebt(int debtId) async =>
      payments.where((p) => p.debtId == debtId).toList()
        ..sort((a, b) => b.date.compareTo(a.date));

  @override
  Future<Payment?> getLastPaymentForDebt(int debtId) async {
    final list = await getPaymentsForDebt(debtId);
    return list.isEmpty ? null : list.first;
  }

  @override
  Future<Map<int, Payment?>> getLastPaymentsForDebts(List<int> debtIds) async {
    final map = <int, Payment?>{};
    for (final id in debtIds) {
      map[id] = await getLastPaymentForDebt(id);
    }
    return map;
  }

  @override
  Future<void> recordPayment({
    required int debtId,
    required double amount,
    required DateTime date,
  }) async {
    final debt = await getDebtById(debtId);
    if (debt == null) throw StateError('Debt $debtId not found');
    if (amount <= 0) throw ArgumentError('Payment amount must be positive');
    if (amount > debt.currentBalance) {
      throw ArgumentError('Payment cannot exceed current balance');
    }

    final newBalance =
        debt.currentBalance - amount < 0 ? 0.0 : debt.currentBalance - amount;
    final nextDue = DebtRepositoryDrift.advanceOneMonth(debt.nextPaymentDue);

    payments.add(Payment(
      id: _nextPaymentId++,
      debtId: debtId,
      amount: amount,
      date: date,
    ));
    await updateDebt(
      id: debt.id,
      name: debt.name,
      startBalance: debt.startBalance,
      currentBalance: newBalance,
      nextPaymentDue: nextDue,
      apr: debt.apr,
      minimumPayment: debt.minimumPayment,
    );
  }

  @override
  Future<void> updatePayment({
    required int paymentId,
    required double amount,
    required DateTime date,
  }) async {
    if (amount <= 0) throw ArgumentError('Payment amount must be positive');
    final index = payments.indexWhere((p) => p.id == paymentId);
    if (index < 0) throw StateError('Payment $paymentId not found');
    final payment = payments[index];
    final debt = await getDebtById(payment.debtId);
    if (debt == null) throw StateError('Debt not found');

    final balanceAfterRestore = debt.currentBalance + payment.amount;
    if (amount > balanceAfterRestore) {
      throw ArgumentError('Payment cannot exceed remaining balance');
    }
    final newBalance = balanceAfterRestore - amount;

    payments[index] = payment.copyWith(amount: amount, date: date);
    await updateDebt(
      id: debt.id,
      name: debt.name,
      startBalance: debt.startBalance,
      currentBalance: newBalance,
      nextPaymentDue: debt.nextPaymentDue,
      apr: debt.apr,
      minimumPayment: debt.minimumPayment,
    );
  }

  @override
  Future<void> deletePayment({required int paymentId}) async {
    final index = payments.indexWhere((p) => p.id == paymentId);
    if (index < 0) throw StateError('Payment $paymentId not found');
    final payment = payments[index];
    final debt = await getDebtById(payment.debtId);
    if (debt == null) throw StateError('Debt not found');

    payments.removeAt(index);
    await updateDebt(
      id: debt.id,
      name: debt.name,
      startBalance: debt.startBalance,
      currentBalance: debt.currentBalance + payment.amount,
      nextPaymentDue: debt.nextPaymentDue,
      apr: debt.apr,
      minimumPayment: debt.minimumPayment,
    );
  }
}

void main() {
  group('StrategyCubit.sortDebts', () {
    test('snowball orders by lowest balance first', () {
      final debts = [
        _debt(id: 1, name: 'Big', balance: 5000, apr: 5),
        _debt(id: 2, name: 'Small', balance: 500, apr: 20),
        _debt(id: 3, name: 'Mid', balance: 2000, apr: 10),
      ];

      StrategyCubit.sortDebts(debts, StrategyState.snowball);

      expect(debts.map((d) => d.name), ['Small', 'Mid', 'Big']);
    });

    test('avalanche orders by highest APR first', () {
      final debts = [
        _debt(id: 1, name: 'LowApr', balance: 500, apr: 5),
        _debt(id: 2, name: 'HighApr', balance: 5000, apr: 22),
        _debt(id: 3, name: 'MidApr', balance: 2000, apr: 12),
      ];

      StrategyCubit.sortDebts(debts, StrategyState.avalanche);

      expect(debts.map((d) => d.name), ['HighApr', 'MidApr', 'LowApr']);
    });
  });

  group('DebtRepositoryDrift.advanceOneMonth', () {
    test('advances calendar month', () {
      expect(
        DebtRepositoryDrift.advanceOneMonth(DateTime(2026, 1, 15)),
        DateTime(2026, 2, 15),
      );
    });

    test('clamps day overflow', () {
      expect(
        DebtRepositoryDrift.advanceOneMonth(DateTime(2026, 1, 31)),
        DateTime(2026, 2, 28),
      );
    });
  });

  group('FakeDebtsRepository payments', () {
    late FakeDebtsRepository repo;

    setUp(() {
      repo = FakeDebtsRepository();
    });

    test('recordPayment reduces currentBalance and stores payment', () async {
      final id = await repo.insertDebt(
        name: 'Card',
        startBalance: 1000,
        currentBalance: 1000,
        nextPaymentDue: DateTime(2026, 1, 15),
        apr: 18,
        minimumPayment: 50,
      );

      await repo.recordPayment(
        debtId: id,
        amount: 200,
        date: DateTime(2026, 1, 10),
      );

      final debt = await repo.getDebtById(id);
      expect(debt!.currentBalance, 800);
      expect(debt.startBalance, 1000);
      expect(debt.nextPaymentDue, DateTime(2026, 2, 15));

      final payments = await repo.getPaymentsForDebt(id);
      expect(payments, hasLength(1));
      expect(payments.first.amount, 200);
    });

    test('updateDebt updates existing row instead of inserting', () async {
      final id = await repo.insertDebt(
        name: 'Loan',
        startBalance: 2000,
        currentBalance: 2000,
        nextPaymentDue: DateTime(2026, 3, 1),
        apr: 6,
        minimumPayment: 100,
      );

      await repo.updateDebt(
        id: id,
        name: 'Car Loan',
        startBalance: 2000,
        currentBalance: 1500,
        nextPaymentDue: DateTime(2026, 4, 1),
        apr: 5.5,
        minimumPayment: 120,
      );

      final debts = await repo.fetchAllDebts();
      expect(debts, hasLength(1));
      expect(debts.first.name, 'Car Loan');
      expect(debts.first.currentBalance, 1500);
      expect(debts.first.startBalance, 2000);
    });

    test('deleteDebt removes related payments', () async {
      final id = await repo.insertDebt(
        name: 'Temp',
        startBalance: 100,
        currentBalance: 100,
        nextPaymentDue: DateTime(2026, 1, 1),
        apr: 10,
        minimumPayment: 20,
      );
      await repo.recordPayment(
        debtId: id,
        amount: 20,
        date: DateTime(2026, 1, 1),
      );

      await repo.deleteDebt(debtId: id);

      expect(await repo.fetchAllDebts(), isEmpty);
      expect(await repo.getPaymentsForDebt(id), isEmpty);
    });

    test('updatePayment adjusts balance by amount delta', () async {
      final id = await repo.insertDebt(
        name: 'Card',
        startBalance: 1000,
        currentBalance: 1000,
        nextPaymentDue: DateTime(2026, 1, 15),
        apr: 18,
        minimumPayment: 50,
      );
      await repo.recordPayment(
        debtId: id,
        amount: 200,
        date: DateTime(2026, 1, 10),
      );
      final payment = (await repo.getPaymentsForDebt(id)).first;

      await repo.updatePayment(
        paymentId: payment.id,
        amount: 150,
        date: DateTime(2026, 1, 12),
      );

      final debt = await repo.getDebtById(id);
      expect(debt!.currentBalance, 850);
      final updated = (await repo.getPaymentsForDebt(id)).first;
      expect(updated.amount, 150);
      expect(updated.date, DateTime(2026, 1, 12));
    });

    test('deletePayment restores amount to balance', () async {
      final id = await repo.insertDebt(
        name: 'Card',
        startBalance: 1000,
        currentBalance: 1000,
        nextPaymentDue: DateTime(2026, 1, 15),
        apr: 18,
        minimumPayment: 50,
      );
      await repo.recordPayment(
        debtId: id,
        amount: 200,
        date: DateTime(2026, 1, 10),
      );
      final payment = (await repo.getPaymentsForDebt(id)).first;

      await repo.deletePayment(paymentId: payment.id);

      final debt = await repo.getDebtById(id);
      expect(debt!.currentBalance, 1000);
      expect(await repo.getPaymentsForDebt(id), isEmpty);
    });
  });

  group('StrategyCubit interest guard', () {
    late FakeDebtsRepository repo;
    late StrategyCubit cubit;

    setUp(() {
      repo = FakeDebtsRepository();
      cubit = StrategyCubit(debtsRepository: repo);
    });

    tearDown(() async {
      await cubit.close();
    });

    test('emits failure when interest exceeds minimum payment', () async {
      await repo.insertDebt(
        name: 'Bad Debt',
        startBalance: 10000,
        currentBalance: 10000,
        nextPaymentDue: DateTime(2026, 1, 1),
        apr: 120,
        minimumPayment: 50,
      );

      await cubit.fetchStrategy();

      expect(cubit.state.status, StrategyStateStatus.failure);
      expect(cubit.state.errorMessage, contains('Interest'));
    });

    test('emits success for a simple payoff', () async {
      await repo.insertDebt(
        name: 'Card',
        startBalance: 500,
        currentBalance: 500,
        nextPaymentDue: DateTime(2026, 1, 1),
        apr: 12,
        minimumPayment: 100,
      );

      await cubit.changeExtraPayment('50');
      await cubit.fetchStrategy();

      expect(cubit.state.status, StrategyStateStatus.success);
      expect(cubit.state.debtPayoffStrategy!.totalDuration, greaterThan(0));
    });
  });
}
