import 'dart:async';

import 'package:budget_app/accounts_list/models/account.dart';
import 'package:budget_app/categories/models/category.dart';
import 'package:budget_app/subcategories/models/models.dart';

import '../transaction.dart';

class TransactionFailure implements Exception {
  final String message;

  const TransactionFailure([
    this.message = 'An unknown exception occurred.',
  ]);
}

abstract class TransactionsRepository {
  Stream<List<Transaction>> get transactions;
  Stream<List<Account>> get accounts;
  Stream<List<Category>> get categories;
  Stream<List<Subcategory>> get subcategories;

  Future<void> fetchTransactions(DateTime dateTime);
  Future<void> fetchAccounts();
  Future<void> fetchCategories();
  Future<void> fetchSubcategories();

  Future<void> createTransaction(Transaction transaction);

  Future<void> updateTransaction(Transaction transaction);

  Future<void> deleteTransactionOrTransfer(
      {required ComprehensiveTransaction transaction});

  Future<void> updateAccount(Account account);
  Future<void> createAccount(Account account);

  Future<void> updateCategory(Category category);
  Future<void> createCategory(Category category);

  Future<void> updateSubcategory(Category category, Subcategory subcategory);
  Future<void> createSubcategory(Category category, Subcategory subcategory);
}
