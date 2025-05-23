import 'package:qruto_budget/accounts_list/account_edit/model/account_with_details.dart';
import 'package:qruto_budget/accounts_list/repository/account_repository.dart';
import 'package:qruto_budget/database/database.dart';

class AccountRepositoryDrift extends AccountRepository {
  AccountRepositoryDrift({required AppDatabase database})
      : _database = database;

  final AppDatabase _database;

  @override
  Stream<List<AccountWithDetails>> get accounts =>
      _database.watchAccountsWithDetails();

  @override
  Future<AccountWithDetails> getAccountById(int accountId) =>
      _database.getAccountWithDetailsById(accountId);

  @override
  Future<List<Account>> getAllAccounts() => _database.getAllAccounts();

  @override
  Future<int> insertAccount(
          {required String name,
          required int categoryId,
          String currency = 'USD',
          double balance = 0.0,
          double initialBalance = 0.0,
          bool includeInTotal = true}) =>
      _database.insertAccount(AccountsCompanion.insert(
          name: name,
          balance: balance,
          initialBalance: initialBalance,
          categoryId: categoryId,
          includeInTotal: includeInTotal));

  @override
  Future<void> updateAccount(
          {required int id,
          required String name,
          required int categoryId,
          String currency = 'USD',
          double balance = 0.0,
          double initialBalance = 0.0,
          bool includeInTotal = true}) =>
      _database.updateAccount(Account(
          id: id,
          name: name,
          balance: balance,
          initialBalance: initialBalance,
          categoryId: categoryId,
          includeInTotal: includeInTotal));

  @override
  Future<int> deleteAccount(int accountId) async {
    final hasTransactions =
        await _database.hasTransactionsForAccount(accountId);
    if (hasTransactions) {
      throw AccountInUseException(
          'Can\'t be deleted. Some transactions belong to this account.\n');
    }
    return await _database.deleteAccount(accountId);
  }
}
