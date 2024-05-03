import 'package:budget_app/accounts_list/models/account.dart';
import 'package:budget_app/categories/models/category.dart';
import 'package:budget_app/transaction/models/comprehensive_transaction.dart';
import 'package:budget_app/transaction/models/transaction.dart';
import 'package:budget_app/transaction/repository/budget_repository.dart';
import 'package:isar/isar.dart';

class BudgetRepoIsarImpl implements BudgetRepository {
  BudgetRepoIsarImpl({required this.isar});

  final Isar isar;

  @override
  Stream<List<Transaction>> transactionsByDate(DateTime dateTime) {
    // Get the first datetime of the given month
    DateTime firstDateTimeOfMonth = DateTime(dateTime.year, dateTime.month, 1);
    // Get the last datetime of the given month
    DateTime lastDayOfMonth = DateTime(dateTime.year, dateTime.month + 1, 0);
    DateTime lastDateTimeOfMonth = DateTime(dateTime.year, dateTime.month,
        lastDayOfMonth.day, 23, 59, 59, 999, 999);
    final trByDate = isar.transactions
        .filter()
        .dateGreaterThan(firstDateTimeOfMonth)
        .and()
        .dateLessThan(lastDateTimeOfMonth)
        .build();
    return trByDate.watch(fireImmediately: true);
  }

  @override
  Stream<List<Account>> get accounts =>
      isar.accounts.where().build().watch(fireImmediately: true);

  @override
  Stream<List<Category>> get categories =>
      isar.categorys.where().build().watch(fireImmediately: true);

  @override
  Future<void> saveTransaction(Transaction transaction) async {
    try {
      await isar.writeTxnSync(() async {
        await isar.transactions.putSync(transaction);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> deleteTransactionOrTransfer(
      {required ComprehensiveTransaction transaction}) async {
    await isar.writeTxn(() async {
      await isar.transactions.delete(transaction.id);
    });
  }

  @override
  Future<Account?> fetchAccountById(int accountId) =>
      isar.accounts.get(accountId);

  @override
  Future<void> saveAccount(Account account) async {
    await isar.writeTxnSync(() async {
      await isar.accounts.putSync(account); // insert & update
    });
  }

  @override
  Future<Category?> fetchCategoryById(int categoryId) =>
      isar.categorys.get(categoryId);

  @override
  Stream<Category?> watchCategoryById(int categoryId) =>
      isar.categorys.watchObject(categoryId, fireImmediately: true);

  @override
  Future<void> saveCategory(Category category) async {
    await isar.writeTxn(() async {
      await isar.categorys.put(category); // insert & update
    });
  }

  @override
  Future<List<Category>> fetchAllCategory() async {
    return isar.categorys.where().findAll();
  }

  @override
  Future<void> saveAccounts(List<Account> updatedAccounts) async {
    await isar.writeTxn(() async {
      await isar.accounts.putAll(updatedAccounts);
    });
  }

  @override
  Future<void> clearAll() async {
    await isar.writeTxn(() async {
      await isar.clear();
    });
  }

  @override
  Future<void> deleteCategory({required int categoryId}) async {
    if (await _isAnyTransactionRelatesOnCategory(categoryId)) {
      throw new CategoryFailure(
          "Declined. One or many transactions relate on this category.");
    }
    if (await _hasAnySubcategory(categoryId)) {
      throw new CategoryFailure("Declined. Category has some subcategories");
    }

    await isar.writeTxn(() async {
      await isar.categorys.delete(categoryId);
    });
  }

  Future<bool> _isAnyTransactionRelatesOnCategory(int categoryId) async {
    final anyTr = await isar.transactions
        .filter()
        .category((category) => category.idEqualTo(categoryId))
        .findFirst();
    return anyTr != null;
  }

  Future<bool> _hasAnySubcategory(int categoryId) async {
    final cat = await isar.categorys.get(categoryId);
    return cat!.subcategoryList.length > 0;
  }
}
