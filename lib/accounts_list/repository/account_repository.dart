import 'package:qruto_budget/accounts_list/account_edit/model/account_with_details.dart';

import '../../database/database.dart';

class AccountInUseException implements Exception {
  final String message;

  AccountInUseException(this.message);

  @override
  String toString() => message;
}

abstract class AccountRepository {
  Stream<List<AccountWithDetails>> get accounts;

  Future<int> insertAccount(
      {required String name,
      required int categoryId,
      String currency = 'USD',
      double balance = 0.0,
      double initialBalance = 0.0,
      bool includeInTotal = true});

  Future<void> updateAccount(
      {required int id,
      required String name,
      required int categoryId,
      String currency = 'USD',
      double balance = 0.0,
      double initialBalance = 0.0,
      bool includeInTotal = true});

  Future<AccountWithDetails> getAccountById(int accountId);

  Future<List<Account>> getAllAccounts();

  Future<int> deleteAccount(int accountId);
}
