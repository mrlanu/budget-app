import 'package:budget_app/accounts_list/models/account.dart';
import 'package:budget_app/categories/models/category.dart';
import 'package:budget_app/subcategories/models/models.dart';
import 'package:budget_app/transaction/models/comprehensive_transaction.dart';
import 'package:budget_app/transaction/models/transaction.dart';
import 'package:budget_app/transaction/repository/transactions_repository.dart';
import 'package:isar/isar.dart';
import 'package:rxdart/rxdart.dart';

class TransactionRepoIsarImpl implements TransactionsRepository {
  TransactionRepoIsarImpl({required this.isar});

  final Isar isar;
  final _transactionsStreamController = BehaviorSubject<List<Transaction>>();
  final _accountsStreamController = BehaviorSubject<List<Account>>();
  final _categoriesStreamController = BehaviorSubject<List<Category>>();
  final _subcategoriesStreamController = BehaviorSubject<List<Subcategory>>();

  @override
  Stream<List<Transaction>> get transactions =>
      _transactionsStreamController.asBroadcastStream();

  @override
  Stream<List<Account>> get accounts =>
      isar.accounts.where().build().watch(fireImmediately: true);

  @override
  Stream<List<Category>> get categories =>
      isar.categorys.where().build().watch(fireImmediately: true);

  @override
  Stream<List<Subcategory>> get subcategories =>
      isar.subcategorys.where().build().watch(fireImmediately: true);

  @override
  Future<void> createTransaction(Transaction transaction) async {
    await isar.writeTxnSync(() async {
      await isar.transactions.putSync(transaction); // insert & update
    });
    final transactions = [..._transactionsStreamController.value];
    transactions.add(transaction);
    _transactionsStreamController.add(transactions);
  }

  @override
  Future<void> deleteTransactionOrTransfer(
      {required ComprehensiveTransaction transaction}) {
    // TODO: implement deleteTransactionOrTransfer
    throw UnimplementedError();
  }

  @override
  Future<void> fetchTransactions(DateTime dateTime) async {
    // Get the first datetime of the given month
    DateTime firstDateTimeOfMonth = DateTime(dateTime.year, dateTime.month, 1);
    // Get the last datetime of the given month
    DateTime lastDayOfMonth = DateTime(dateTime.year, dateTime.month + 1, 0);
    DateTime lastDateTimeOfMonth = DateTime(dateTime.year, dateTime.month,
        lastDayOfMonth.day, 23, 59, 59, 999, 999);
    final transactions = await isar.transactions
        .filter()
        .dateGreaterThan(firstDateTimeOfMonth)
        .and()
        .dateLessThan(lastDateTimeOfMonth)
        .findAll();
    _transactionsStreamController.add(transactions);
  }

  @override
  Future<void> fetchAccounts() async {
    final accounts = await isar.accounts.where().findAll();
    _accountsStreamController.add(accounts);
  }

  @override
  Future<void> fetchCategories() {
    // TODO: implement fetchCategories
    throw UnimplementedError();
  }

  @override
  Future<void> fetchSubcategories() {
    // TODO: implement fetchSubcategories
    throw UnimplementedError();
  }

  @override
  Future<void> updateTransaction(Transaction transaction) {
    // TODO: implement updateTransaction
    throw UnimplementedError();
  }

  @override
  Future<void> updateTransfer(Transaction transfer) {
    // TODO: implement updateTransfer
    throw UnimplementedError();
  }

  @override
  Future<void> createAccount(Account account) {
    // TODO: implement createAccount
    throw UnimplementedError();
  }

  @override
  Future<void> updateAccount(Account account) {
    // TODO: implement updateAccount
    throw UnimplementedError();
  }

  @override
  Future<void> createCategory(Category category) async {
    await isar.writeTxn(() async {
      await isar.categorys.put(category); // insert & update
    });
  }

  @override
  Future<void> updateCategory(Category category) {
    // TODO: implement updateCategory
    throw UnimplementedError();
  }

  @override
  Future<void> createSubcategory(Category category, Subcategory subcategory) {
    // TODO: implement createSubcategory
    throw UnimplementedError();
  }

  @override
  Future<void> updateSubcategory(Category category, Subcategory subcategory) {
    // TODO: implement updateSubcategory
    throw UnimplementedError();
  }
}
