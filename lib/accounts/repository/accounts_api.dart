import 'package:budget_app/accounts/repository/models/account_model.dart';

abstract class AccountsApi {

  const AccountsApi();

  Future<void> getAccounts();

  Future<void> saveAccount(AccountModel accountModel);

  Future<void> deleteAccount(String id);
}

class AccountNotFoundException implements Exception {}
