import 'package:authentication_repository/authentication_repository.dart';
import 'package:budget_app/accounts/repository/models/account_model.dart';

abstract class AccountsRepository {

  final User user;

  AccountsRepository({required this.user});

  Future<void> deleteAccount(String id);

  Future<List<AccountModel>> getAccounts();

  Future<void> saveAccount(AccountModel accountModel);

}
