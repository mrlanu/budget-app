import 'dart:math' as math;

import 'package:qruto_budget/database/database.dart';

abstract class DebtsRepository {
  Future<List<Debt>> fetchAllDebts();

  Future<Debt?> getDebtById(int debtId);

  Future<int> insertDebt({
    required String name,
    required double startBalance,
    required double currentBalance,
    required DateTime nextPaymentDue,
    required double apr,
    required double minimumPayment,
  });

  Future<void> updateDebt({
    required int id,
    required String name,
    required double startBalance,
    required double currentBalance,
    required DateTime nextPaymentDue,
    required double apr,
    required double minimumPayment,
  });

  Future<void> deleteDebt({required int debtId});

  Future<List<Payment>> getPaymentsForDebt(int debtId);

  Future<Payment?> getLastPaymentForDebt(int debtId);

  Future<Map<int, Payment?>> getLastPaymentsForDebts(List<int> debtIds);

  /// Inserts a payment, reduces [currentBalance], and advances [nextPaymentDue].
  Future<void> recordPayment({
    required int debtId,
    required double amount,
    required DateTime date,
  });

  /// Updates a payment and adjusts [currentBalance] by the amount delta.
  Future<void> updatePayment({
    required int paymentId,
    required double amount,
    required DateTime date,
  });

  /// Deletes a payment and restores its amount to [currentBalance].
  Future<void> deletePayment({required int paymentId});
}

class DebtRepositoryDrift extends DebtsRepository {
  DebtRepositoryDrift({required AppDatabase database}) : _database = database;

  final AppDatabase _database;

  @override
  Future<List<Debt>> fetchAllDebts() => _database.getAllDebts();

  @override
  Future<Debt?> getDebtById(int debtId) => _database.getDebtById(debtId);

  @override
  Future<int> insertDebt({
    required String name,
    required double startBalance,
    required double currentBalance,
    required DateTime nextPaymentDue,
    required double apr,
    required double minimumPayment,
  }) =>
      _database.insertDebt(DebtsCompanion.insert(
        name: name,
        startBalance: startBalance,
        currentBalance: currentBalance,
        apr: apr,
        minimumPayment: minimumPayment,
        nextPaymentDue: nextPaymentDue,
      ));

  @override
  Future<void> updateDebt({
    required int id,
    required String name,
    required double startBalance,
    required double currentBalance,
    required DateTime nextPaymentDue,
    required double apr,
    required double minimumPayment,
  }) =>
      _database.updateDebt(Debt(
        id: id,
        name: name,
        startBalance: startBalance,
        currentBalance: currentBalance,
        apr: apr,
        minimumPayment: minimumPayment,
        nextPaymentDue: nextPaymentDue,
      ));

  @override
  Future<void> deleteDebt({required int debtId}) =>
      _database.deleteDebt(debtId);

  @override
  Future<List<Payment>> getPaymentsForDebt(int debtId) =>
      _database.getPaymentsForDebt(debtId);

  @override
  Future<Payment?> getLastPaymentForDebt(int debtId) =>
      _database.getLastPaymentForDebt(debtId);

  @override
  Future<Map<int, Payment?>> getLastPaymentsForDebts(List<int> debtIds) =>
      _database.getLastPaymentsForDebts(debtIds);

  @override
  Future<void> recordPayment({
    required int debtId,
    required double amount,
    required DateTime date,
  }) async {
    final debt = await _database.getDebtById(debtId);
    if (debt == null) {
      throw StateError('Debt $debtId not found');
    }
    if (amount <= 0) {
      throw ArgumentError('Payment amount must be positive');
    }
    if (amount > debt.currentBalance) {
      throw ArgumentError('Payment cannot exceed current balance');
    }

    final newBalance = math.max(0.0, debt.currentBalance - amount);
    final nextDue = _advanceOneMonth(debt.nextPaymentDue);

    await _database.transaction(() async {
      await _database.insertPayment(PaymentsCompanion.insert(
        debtId: debtId,
        amount: amount,
        date: date,
      ));
      await _database.updateDebt(debt.copyWith(
        currentBalance: newBalance,
        nextPaymentDue: nextDue,
      ));
    });
  }

  @override
  Future<void> updatePayment({
    required int paymentId,
    required double amount,
    required DateTime date,
  }) async {
    if (amount <= 0) {
      throw ArgumentError('Payment amount must be positive');
    }

    final payment = await _database.getPaymentById(paymentId);
    if (payment == null) {
      throw StateError('Payment $paymentId not found');
    }

    final debt = await _database.getDebtById(payment.debtId);
    if (debt == null) {
      throw StateError('Debt ${payment.debtId} not found');
    }

    // Restore old payment, then apply new amount.
    final balanceAfterRestore = debt.currentBalance + payment.amount;
    if (amount > balanceAfterRestore) {
      throw ArgumentError('Payment cannot exceed remaining balance');
    }
    final newBalance = math.max(0.0, balanceAfterRestore - amount);

    await _database.transaction(() async {
      await _database.updatePayment(payment.copyWith(
        amount: amount,
        date: date,
      ));
      await _database.updateDebt(debt.copyWith(currentBalance: newBalance));
    });
  }

  @override
  Future<void> deletePayment({required int paymentId}) async {
    final payment = await _database.getPaymentById(paymentId);
    if (payment == null) {
      throw StateError('Payment $paymentId not found');
    }

    final debt = await _database.getDebtById(payment.debtId);
    if (debt == null) {
      throw StateError('Debt ${payment.debtId} not found');
    }

    final restoredBalance = debt.currentBalance + payment.amount;

    await _database.transaction(() async {
      await _database.deletePayment(paymentId);
      await _database.updateDebt(debt.copyWith(currentBalance: restoredBalance));
    });
  }

  /// Advances [date] by one calendar month, clamping day-of-month overflow.
  static DateTime advanceOneMonth(DateTime date) => _advanceOneMonth(date);

  static DateTime _advanceOneMonth(DateTime date) {
    final year = date.month == 12 ? date.year + 1 : date.year;
    final month = date.month == 12 ? 1 : date.month + 1;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final day = math.min(date.day, daysInMonth);
    return DateTime(year, month, day);
  }
}
