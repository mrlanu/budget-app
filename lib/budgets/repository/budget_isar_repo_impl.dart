import 'package:budget_app/accounts_list/models/account.dart';
import 'package:budget_app/budgets/models/budget.dart';
import 'package:budget_app/categories/models/category.dart';
import 'package:budget_app/categories/models/models.dart';
import 'package:budget_app/subcategories/models/subcategory.dart';
import 'package:budget_app/transaction/models/models.dart';
import 'package:isar/isar.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import 'budget_repository.dart';

class BudgetIsarRepoImpl implements BudgetRepository {

  BudgetIsarRepoImpl({required this.isar});

  final Isar isar;

  final _budgetStreamController = BehaviorSubject<Budget>();

  @override
  Stream<Budget> get budget => _budgetStreamController.asBroadcastStream();

  @override
  Future<String> createBeginningBudget() async {
    final categories = _createSomeCats();
    final accounts = _createSomeAccs(categories[0]);
    final newBudget = Budget(
        id: Uuid().v4(),
        accountList: accounts,
        categoryList: categories);
    await isar.writeTxn(() async {
      await isar.budgets.put(newBudget); // insert & update
    });
    return newBudget.id;
  }

  @override
  Future<void> createAccount(Account account) {
    // TODO: implement createAccount
    throw UnimplementedError();
  }

  @override
  Future<void> createCategory(Category category) {
    // TODO: implement createCategory
    throw UnimplementedError();
  }

  @override
  Future<void> createSubcategory(Category category, Subcategory subcategory) {
    // TODO: implement createSubcategory
    throw UnimplementedError();
  }

  @override
  Future<void> deleteBudget() {
    // TODO: implement deleteBudget
    throw UnimplementedError();
  }

  @override
  Future<List<String>> fetchAvailableBudgets() async {
    return (await isar.budgets.where().findAll()).map((e) => e.id).toList();
  }

  @override
  Future<void> fetchBudget(String budgetId) async {
    final result = (await isar.budgets.filter().idEqualTo(budgetId).findAll())[0];
    _budgetStreamController.add(result);
  }

  @override
  void pushUpdatedAccounts(List<Account> accounts) {
    final currentBudget = _budgetStreamController.value;
    _budgetStreamController.add(currentBudget.copyWith(accountList: accounts));
  }

  @override
  Future<void> updateAccount(Account account) {
    // TODO: implement updateAccount
    throw UnimplementedError();
  }

  @override
  Future<void> updateCategory(Category category) {
    // TODO: implement updateCategory
    throw UnimplementedError();
  }

  @override
  Future<void> updateSubcategory(Category category, Subcategory subcategory) {
    // TODO: implement updateSubcategory
    throw UnimplementedError();
  }

  Category _getCategoryById(String id) =>
      _budgetStreamController.value.categoryList
          .where((cat) => cat.id == id)
          .first;

  List<Account> _createSomeAccs(Category category) => [
        Account(
            id: Uuid().v4(),
            name: 'Chase',
            balance: 1000,
            initialBalance: 1000,
            currency: 'USD',
            includeInTotal: true,
            category: category.id),
      ];

  List<Category> _createSomeCats() => [
        Category(
          id: Uuid().v4(),
          name: 'Checking',
          iconCode: 61675,
          type: TransactionType.ACCOUNT,
          subcategoryList: [],
        ),
        Category(
            id: Uuid().v4(),
            name: 'Fun',
            iconCode: 62922,
            type: TransactionType.EXPENSE,
            subcategoryList: [
              Subcategory(id: Uuid().v4(), name: 'Alcohol'),
              Subcategory(id: Uuid().v4(), name: 'Girls')
            ]),
        Category(
            id: Uuid().v4(),
            name: 'Bills',
            iconCode: 61675,
            type: TransactionType.EXPENSE,
            subcategoryList: [
              Subcategory(id: Uuid().v4(), name: 'Gas'),
              Subcategory(id: Uuid().v4(), name: 'Electricity')
            ]),
      ];
}
