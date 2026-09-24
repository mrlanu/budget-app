import 'package:qruto_budget/accounts_list/repository/account_repository.dart';
import 'package:qruto_budget/database/database.dart';
import 'package:qruto_budget/database/recurring_transaction_with_detail.dart';
import 'package:qruto_budget/database/tables.dart';
import 'package:qruto_budget/database/transaction_with_detail.dart';
import 'package:qruto_budget/transaction/models/transaction_type.dart';
import 'package:qruto_budget/transaction/repository/transaction_repository.dart';
import 'package:drift/drift.dart';

abstract class RecurringRepository {
  Stream<List<RecurringTransactionWithDetails>> watchAll();

  Future<int> insertRecurring({
    required double amount,
    required int categoryId,
    int? subcategoryId,
    required int fromAccountId,
    required String description,
    required TransactionType type,
    required RecurringFrequency frequency,
    required DateTime nextDate,
    bool isActive = true,
  });

  Future<void> setActive({required int id, required bool isActive});

  Future<void> deleteRecurring(int id);

  /// Creates due transactions and advances nextDate. Returns how many were created.
  Future<int> materializeDue({DateTime? asOf});
}

class RecurringRepositoryDrift extends RecurringRepository {
  RecurringRepositoryDrift({
    required AppDatabase database,
    required TransactionRepository transactionRepository,
    required AccountRepository accountRepository,
  })  : _database = database,
        _transactionRepository = transactionRepository,
        _accountRepository = accountRepository;

  final AppDatabase _database;
  final TransactionRepository _transactionRepository;
  final AccountRepository _accountRepository;

  @override
  Stream<List<RecurringTransactionWithDetails>> watchAll() =>
      _database.watchRecurringWithDetails();

  @override
  Future<int> insertRecurring({
    required double amount,
    required int categoryId,
    int? subcategoryId,
    required int fromAccountId,
    required String description,
    required TransactionType type,
    required RecurringFrequency frequency,
    required DateTime nextDate,
    bool isActive = true,
  }) =>
      _database.insertRecurringTransaction(RecurringTransactionsCompanion.insert(
        amount: amount,
        categoryId: categoryId,
        subcategoryId: Value(subcategoryId),
        fromAccountId: fromAccountId,
        description: description,
        type: type,
        frequency: frequency,
        nextDate: nextDate,
        isActive: Value(isActive),
      ));

  @override
  Future<void> setActive({required int id, required bool isActive}) async {
    final current = await _database.getRecurringTransactionById(id);
    await _database.updateRecurringTransaction(
      current.copyWith(isActive: isActive),
    );
  }

  @override
  Future<void> deleteRecurring(int id) =>
      _database.deleteRecurringTransaction(id);

  @override
  Future<int> materializeDue({DateTime? asOf}) async {
    final today = _dateOnly(asOf ?? DateTime.now());
    final templates = await _database.getActiveRecurringTransactions();
    var created = 0;

    for (final template in templates) {
      var nextDate = _dateOnly(template.nextDate);
      var current = template;

      while (!nextDate.isAfter(today)) {
        final transactionId = await _transactionRepository.insertTransaction(
          date: nextDate,
          type: current.type,
          amount: current.amount,
          categoryId: current.categoryId,
          subcategoryId: current.subcategoryId,
          fromAccountId: current.fromAccountId,
          description: current.description,
        );
        final newTransaction =
            await _transactionRepository.getTransactionById(transactionId);
        await _applyBalanceForNewTransaction(newTransaction);
        created++;

        nextDate = _advanceDate(nextDate, current.frequency);
        current = current.copyWith(nextDate: nextDate);
        await _database.updateRecurringTransaction(current);
      }
    }

    return created;
  }

  Future<void> _applyBalanceForNewTransaction(
      TransactionWithDetails newTransaction) async {
    final accounts = await _accountRepository.getAllAccounts();
    for (final acc in accounts) {
      if (acc.id != newTransaction.fromAccount.id) continue;
      final balance = acc.balance +
          (newTransaction.type == TransactionType.EXPENSE
              ? -newTransaction.amount
              : newTransaction.amount);
      await _accountRepository.updateAccount(
        id: acc.id,
        name: acc.name,
        includeInTotal: acc.includeInTotal,
        balance: balance,
        initialBalance: acc.initialBalance,
        currency: acc.currency ?? '',
        categoryId: acc.categoryId,
      );
    }
  }

  static DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static DateTime _advanceDate(DateTime date, RecurringFrequency frequency) {
    return switch (frequency) {
      RecurringFrequency.weekly => date.add(const Duration(days: 7)),
      RecurringFrequency.monthly => DateTime(date.year, date.month + 1, date.day),
    };
  }

  /// First occurrence after [fromDate] for the given frequency.
  static DateTime nextOccurrenceAfter(
      DateTime fromDate, RecurringFrequency frequency) {
    return _advanceDate(_dateOnly(fromDate), frequency);
  }
}
