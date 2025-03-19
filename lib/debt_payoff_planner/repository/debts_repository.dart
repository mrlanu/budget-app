import 'package:qruto_budget/database/database.dart';

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
  Future<List<Debt>> fetchAllDebts() => _database.getAllDebts();

  @override
  Future<int> insertDebt(
      {required String name,
      required double startBalance,
      required double currentBalance,
      required DateTime nextPaymentDue,
      required double apr,
      required double minimumPayment}) => _database.insertDebt(DebtsCompanion.insert(
          name: name,
          startBalance: startBalance,
          currentBalance: currentBalance,
          apr: apr,
          minimumPayment: minimumPayment,
          nextPaymentDue: nextPaymentDue));

  @override
  Future<void> deleteDebt({required int debtId}) => _database.deleteDebt(debtId);
}
