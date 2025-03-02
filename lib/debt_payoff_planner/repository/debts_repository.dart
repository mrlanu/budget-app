import 'package:budget_app/database/database.dart';

class DebtFailure implements Exception {
  final String message;

  const DebtFailure([
    this.message = 'An unknown exception occurred.',
  ]);
}

abstract class DebtsRepository {
  Future<List<Debt>> fetchAllDebts();

  Future<int> insertDebt(
      {required String name,
      required double startBalance,
      required double currentBalance,
      required DateTime nextPaymentDue,
      required double apr,
      required double minimumPayment});

  Future<void> deleteDebt({required int debtId});
}

class DebtRepositoryDrift extends DebtsRepository {
  DebtRepositoryDrift({required AppDatabase database}) : _database = database;

  final AppDatabase _database;

  @override
  Future<List<Debt>> fetchAllDebts() async {
    try {
      return await _database.getAllDebts();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<int> insertDebt(
      {required String name,
      required double startBalance,
      required double currentBalance,
      required DateTime nextPaymentDue,
      required double apr,
      required double minimumPayment}) async {
    try {
      return _database.insertDebt(DebtsCompanion.insert(
          name: name,
          startBalance: startBalance,
          currentBalance: currentBalance,
          apr: apr,
          minimumPayment: minimumPayment,
          nextPaymentDue: nextPaymentDue));
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> deleteDebt({required int debtId}) async {
    try {
      await _database.deleteDebt(debtId);
    } catch (e) {
      throw Exception(e);
    }
  }
}
