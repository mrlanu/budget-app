import 'dart:async';

import 'package:budget_app/accounts_list/models/account.dart';
import 'package:budget_app/categories/models/category.dart';

import '../transaction.dart';

class TransactionFailure implements Exception {
  final String message;

  const TransactionFailure([
    this.message = 'An unknown exception occurred.',
  ]);
}

abstract class BudgetRepository {
  Stream<List<Account>> get accounts;
  Stream<List<Category>> get categories;

  Stream<List<Transaction>> transactionsByDate(DateTime dateTime);

  Future<void> saveTransaction(Transaction transaction);

  Future<void> deleteTransactionOrTransfer(
      {required ComprehensiveTransaction transaction});

  Future<Account?> fetchAccountById(int accountId);
  Future<void> saveAccount(Account account);
  Future<void> saveAccounts(List<Account> updatedAccounts);

  Future<void> saveCategory(Category category);

  Stream<Category?> watchCategoryById(int categoryId);

  Future<Category?> fetchCategoryById(int categoryId);
  Future<void> clearAll();
}
