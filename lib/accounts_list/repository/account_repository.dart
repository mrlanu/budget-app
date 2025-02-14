import 'package:budget_app/accounts_list/account_edit/model/account_with_details.dart';

import '../../database/database.dart';

abstract class AccountRepository {
  Stream<List<AccountWithDetails>> get accounts;
  Future<Account> createAccount(Account account);
  Future<void> updateAccount(Account account);
  Future<Account> getAccountById(int accountId);
  Future<List<Account>> getAllAccounts();
}
