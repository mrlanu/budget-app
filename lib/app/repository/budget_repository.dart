import 'package:budget_app/constants/api.dart';
import 'package:budget_app/transactions/models/transaction_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import '../../budgets/budgets.dart';

abstract class BudgetRepository {
  Stream<Budget> get budget;

  Future<List<Budget>> fetchAvailableBudgets(String userId);

  List<Category> getCategoriesByType(TransactionType type);

  List<Category> getCategories();

  Category getCategoryById(String name);

  Account getAccountById(String accountId);
  List<Account> getAccounts();

  Future<void> saveCategory(Category category);

  Future<void> saveSubcategory(Category category, Subcategory subcategory);

  Future<void> createAccount(Account account);

  Future<void> createBeginningBudget({required String userId});
}

class BudgetRepositoryImpl extends BudgetRepository {
  final FirebaseFirestore _firebaseFirestore;
  final _budgetStreamController = BehaviorSubject<Budget>.seeded(Budget());

  BudgetRepositoryImpl({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance {
    _init();
  }

  void _init() async {
    final userId = await getUserId();
    final budgetId = await getCurrentBudgetId();
    _firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('budgets')
        .doc(budgetId)
        .snapshots()
        .map((event) => Budget.fromFirestore(event))
        .listen((budget) {
      _budgetStreamController.add(budget);
    });
  }

  @override
  Stream<Budget> get budget => _budgetStreamController.asBroadcastStream();

  Future<List<Budget>> fetchAvailableBudgets(String userId) async {
    final budgets = (await _firebaseFirestore
            .collection('users')
            .doc(userId)
            .collection('budgets')
            .get())
        .docs
        .map((e) => Budget.fromFirestore(e))
        .toList();
    return budgets;
  }

  Category getCategoryById(String id) =>
      _budgetStreamController.value.categoryList
          .where((cat) => cat.id == id)
          .first;

  List<Category> getCategoriesByType(TransactionType type) =>
      _budgetStreamController.value.categoryList
          .where((cat) => cat.type == type)
          .toList();

  List<Category> getCategories() =>
      _budgetStreamController.value.categoryList;

  List<Account> getAccounts() => _budgetStreamController.value.accountList;

  Account getAccountById(String accountId) =>
      _budgetStreamController.value.accountList
          .where((acc) => acc.id == accountId)
          .first;

  Future<void> saveCategory(Category category) async {
    final categories = [..._budgetStreamController.value.categoryList];
    final catIndex = categories.indexWhere((cat) => cat.id == category.id);

    if (catIndex == -1) {
      categories.add(category);
    } else {
      categories.removeAt(catIndex);
      categories.insert(catIndex, category);
    }
    updateBudget(
        _budgetStreamController.value.copyWith(categoryList: categories));
  }

  Future<void> saveSubcategory(
      Category category, Subcategory subcategory) async {
    final subcategoriesCopy = [
      ...getCategoryById(category.id).subcategoryList
    ];
    final subCatIndex = subcategoriesCopy.indexWhere((sc) => sc.id == subcategory.id);
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

    updateBudget(
        _budgetStreamController.value.copyWith(categoryList: categories));
  }

  Future<void> createAccount(Account account) async {
    final accountsCopy = [..._budgetStreamController.value.accountList];
    accountsCopy.add(account);
    updateBudget(
        _budgetStreamController.value.copyWith(accountList: accountsCopy));
  }

  Future<void> updateBudget(Budget budget) async {
    final userId = await getUserId();
    final budgetId = await getCurrentBudgetId();
    _firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('budgets')
        .doc(budgetId)
        .set(budget.toFirestore());
  }

  Future<void> createBeginningBudget({required String userId}) async {
    final ref = await _firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('budgets')
        .add(Budget().toFirestore());

    final beginningBudget = Budget(
        id: ref.id, categoryList: categoryList, accountList: accountList);

    await _firebaseFirestore
        .doc('users/$userId/budgets/${ref.id}')
        .set(beginningBudget.toFirestore());
  }
}

final categoryList = <Category>[
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
      categoryId: categoryList[2].id,
      balance: 2000.0,
      initialBalance: 2000.0)
];
