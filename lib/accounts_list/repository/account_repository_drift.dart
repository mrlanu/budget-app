import 'package:budget_app/accounts_list/account_edit/model/account_with_details.dart';
import 'package:budget_app/accounts_list/repository/account_repository.dart';
import 'package:budget_app/database/database.dart';

class AccountRepositoryDrift extends AccountRepository {
  AccountRepositoryDrift({required AppDatabase database})
      : _database = database;

  final AppDatabase _database;

  @override
  Stream<List<AccountWithDetails>> get accounts => _database.watchAccountsWithDetails();

  @override
  Future<Account> createAccount(Account account) => _database.insertAccount(account);

  @override
  Future<Account> getAccountById(int accountId) => _database.accountById(accountId);

  @override
  Future<List<Account>> getAllAccounts() => _database.getAllAccounts();

  @override
  Future<void> updateAccount(Account account) => _database.updateAccount(account);

}
