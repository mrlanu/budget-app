import 'dart:convert';

import 'package:budget_app/accounts_list/repository/account_repository.dart';
import 'package:budget_app/categories/repository/category_repository.dart';
import 'package:budget_app/constants/api.dart';
import 'package:budget_app/transaction/models/models.dart';
import 'package:http/http.dart' as http;

import '../transaction/repository/transaction_repository.dart';

Future<Map<String, dynamic>> fetchOldData(
    {required CategoryRepository categoryRepository,
    required AccountRepository accountRepository,
    required TransactionRepository transactionRepository}) async {
  final count = await transactionRepository.countAllTransactions();
  print('Transactions: $count');
  final idMapping = <String, int>{};
  final budgetResponse = await http
      .get(Uri.parse('$baseURL/api/budgets/64c00f7b68288437489cc18a'));
  if (budgetResponse.statusCode == 200) {
    final budgetData = jsonDecode(budgetResponse.body);
    for (var category in budgetData['categoryList']) {
      final catType = switch (category['type']){
        'INCOME' => TransactionType.INCOME,
        'EXPENSE' => TransactionType.EXPENSE,
        'ACCOUNT' => TransactionType.ACCOUNT,
        _ => throw FormatException('Invalid'),
      };
      final newCategoryId = await categoryRepository.insertCategory(
        name: category['name'],
        type: catType,
        iconCode: category['iconCode'],
      );
      idMapping[category['id']] = newCategoryId;
      for (var subCat in category['subcategoryList']) {
        final newSubCatId = await categoryRepository.insertSubcategory(
          categoryId: newCategoryId,
          name: subCat['name'],
        );
        idMapping[subCat['id']] = newSubCatId;
      }
    }
    for (var acc in budgetData['accountList']) {
      final newAccId = await accountRepository.insertAccount(
        name: acc['name'],
        categoryId: idMapping[acc['categoryId']]!,
        balance: acc['balance'],
        initialBalance: acc['initialBalance'],
        includeInTotal: acc['includeInTotal'],
        currency: acc['currency'],
      );
      idMapping[acc['id']] = newAccId;
    }
  } else {
    throw Exception('Failed to load data');
  }
  final transactionsResponse = await http.get(
      Uri.parse('$baseURL/api/transactions/budgets/64c00f7b68288437489cc18a'));
  if (transactionsResponse.statusCode == 200) {
    final transactionsData = jsonDecode(transactionsResponse.body);
    for (var tr in transactionsData) {
      final trType = switch (tr['type']) {
        'INCOME' => TransactionType.INCOME,
        'EXPENSE' => TransactionType.EXPENSE,
        'ACCOUNT' => TransactionType.ACCOUNT,
        'TRANSFER' => TransactionType.TRANSFER,
        _ => throw FormatException('Invalid'),
      };
      final newTrId = await transactionRepository.insertTransaction(
        type: trType,
        description: tr['description'],
        date: DateTime.parse(tr['date']).toUtc(),
        amount: tr['amount'],
        fromAccountId: idMapping[tr['fromAccountId']]!,
        toAccountId: tr['toAccountId'] != null ? idMapping[tr['toAccountId']]! : null,
        categoryId: tr['categoryId'] != null ? idMapping[tr['categoryId']]! : null,
        subcategoryId: tr['subcategoryId'] != null ? idMapping[tr['subcategoryId']]! : null,
      );
      idMapping[tr['id']] = newTrId;
    }
  } else {
    throw Exception('Failed to load data');
  }
  return {};
}
