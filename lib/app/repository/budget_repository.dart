import 'package:budget_app/shared/shared.dart';
import 'package:budget_app/transactions/models/transaction_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import '../../budgets/budgets.dart';

abstract class BudgetRepository {
  Future<void> init();

  Stream<Budget> get budget;

  Future<void> saveBudget(Budget budget);

  Future<void> createBeginningBudget({required String userId});

  Future<List<Budget>> fetchAvailableBudgets(String userId);

  Future<void> saveCategory(Category category);

  List<Category> getCategoriesByType(TransactionType type);

  List<Category> getCategories();

  Category getCategoryById(String name);

  Account getAccountById(String accountId);

  List<Account> getAccounts();

  Future<void> createAccount(Account account);

  Future<void> saveSubcategory(Category category, Subcategory subcategory);
}

class BudgetRepositoryImpl extends BudgetRepository {
  final FirebaseFirestore _firebaseFirestore;
  final _budgetStreamController = BehaviorSubject<Budget>.seeded(Budget());

  BudgetRepositoryImpl({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance {}

  Future<void> init() async => (await _firebaseFirestore.userBudget())
          .snapshots()
          .map((event) => Budget.fromFirestore(event))
          .listen((budget) {
        _budgetStreamController.add(budget);
      });

  @override
  Stream<Budget> get budget => _budgetStreamController.asBroadcastStream();

  @override
  Future<List<Budget>> fetchAvailableBudgets(String userId) async =>
      (await _firebaseFirestore
              .collection('users')
              .doc(userId)
              .collection('budgets')
              .get())
          .docs
          .map((e) => Budget.fromFirestore(e))
          .toList();

  @override
  Category getCategoryById(String id) =>
      _budgetStreamController.value.categoryList
          .where((cat) => cat.id == id)
          .first;

  @override
  List<Category> getCategoriesByType(TransactionType type) =>
      _budgetStreamController.value.categoryList
          .where((cat) => cat.type == type)
          .toList();

  @override
  List<Category> getCategories() => _budgetStreamController.value.categoryList;

  @override
  List<Account> getAccounts() => _budgetStreamController.value.accountList;

  @override
  Account getAccountById(String accountId) =>
      _budgetStreamController.value.accountList
          .where((acc) => acc.id == accountId)
          .first;

  @override
  Future<void> saveCategory(Category category) async {
    final categories = [..._budgetStreamController.value.categoryList];
    final catIndex = categories.indexWhere((cat) => cat.id == category.id);

    if (catIndex == -1) {
      categories.add(category);
    } else {
      categories.removeAt(catIndex);
      categories.insert(catIndex, category);
    }
    saveBudget(
        _budgetStreamController.value.copyWith(categoryList: categories));
  }

  @override
  Future<void> saveSubcategory(
      Category category, Subcategory subcategory) async {
    final subcategoriesCopy = [...getCategoryById(category.id).subcategoryList];
    final subCatIndex =
        subcategoriesCopy.indexWhere((sc) => sc.id == subcategory.id);
    if (subCatIndex == -1) {
      subcategoriesCopy.add(subcategory);
    } else {
      subcategoriesCopy.removeAt(subCatIndex);
      subcategoriesCopy.insert(subCatIndex, subcategory);
    }

    final categories = [..._budgetStreamController.value.categoryList];
    final catIndex = categories.indexWhere((cat) => cat.id == category.id);

    categories.removeAt(catIndex);
    categories.insert(
        catIndex, category.copyWith(subcategoryList: subcategoriesCopy));

    saveBudget(
        _budgetStreamController.value.copyWith(categoryList: categories));
  }

  @override
  Future<void> createAccount(Account account) async {
    final accountsCopy = [..._budgetStreamController.value.accountList];
    accountsCopy.add(account);
    saveBudget(
        _budgetStreamController.value.copyWith(accountList: accountsCopy));
  }

  @override
  Future<void> saveBudget(Budget budget) async =>
      (await _firebaseFirestore.userBudget()).set(budget.toFirestore());

  @override
  Future<void> createBeginningBudget({required String userId}) async {
    final ref = await _firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('budgets')
        .add(Budget().toFirestore());

    final beginningBudget = Budget(
        id: ref.id, categoryList: _categoryList, accountList: accountList);

    await _firebaseFirestore
        .doc('users/$userId/budgets/${ref.id}')
        .set(beginningBudget.toFirestore());
  }
}

final _categoryList = <Category>[
  Category(
      id: Uuid().v4(),
      name: 'Fun',
      iconCode: 62922,
      subcategoryList: [
        Subcategory(id: Uuid().v4(), name: 'Alcohol'),
        Subcategory(id: Uuid().v4(), name: 'Girls')
      ],
      type: TransactionType.EXPENSE),
  Category(
      id: Uuid().v4(),
      name: 'Bills',
      iconCode: 61675,
      subcategoryList: [
        Subcategory(id: Uuid().v4(), name: 'Gas'),
        Subcategory(id: Uuid().v4(), name: 'Electricity')
      ],
      type: TransactionType.EXPENSE),
  Category(
      id: Uuid().v4(),
      name: 'Checking',
      iconCode: 61675,
      subcategoryList: [],
      type: TransactionType.ACCOUNT),
];
final accountList = <Account>[
  Account(
      id: Uuid().v4(),
      name: 'Chase',
      categoryId: _categoryList[2].id,
      balance: 2000.0,
      initialBalance: 2000.0)
];
