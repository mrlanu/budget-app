import 'dart:convert';

import 'package:budget_app/transactions/models/transaction_type.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import '../../budgets/budgets.dart';
import '../../constants/api.dart';

abstract class BudgetRepository {
  Future<List<String>> fetchAvailableBudgets();

  Future<void> fetchBudget(String budgetId);

  Stream<Budget> get budget;

  Future<void> saveBudget({required Budget budget});

  Future<String> createBeginningBudget();

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
  final _budgetStreamController = BehaviorSubject<Budget>.seeded(Budget());

  @override
  Stream<Budget> get budget => _budgetStreamController.asBroadcastStream();

  @override
  Future<List<String>> fetchAvailableBudgets() async {
    final url = isTestMode
        ? Uri.http(
            baseURL,
            '/api/budgets',
          )
        : Uri.https(baseURL, '/api/budgets');

    final response = await http.get(url, headers: await getHeaders());
    final result =
        (json.decode(response.body) as List).map((b) => b as String).toList();
    return result;
  }

  @override
  Future<void> fetchBudget(String budgetId) async {
    final url = isTestMode
        ? Uri.http(baseURL, '/api/budgets/$budgetId')
        : Uri.https(baseURL, '/api/budgets/$budgetId');

    final response = await http.get(url, headers: await getHeaders());
    final budget = Budget.fromJson(jsonDecode(response.body));
    _budgetStreamController.add(budget);
  }

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
    /*saveBudget(
        _budgetStreamController.value.copyWith(categoryList: categories));*/
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

    /*saveBudget(
        _budgetStreamController.value.copyWith(categoryList: categories));*/
  }

  @override
  Future<void> createAccount(Account account) async {
    final accountsCopy = [..._budgetStreamController.value.accountList];
    accountsCopy.add(account);
    /*saveBudget(
        _budgetStreamController.value.copyWith(accountList: accountsCopy));*/
  }

  @override
  Future<void> saveBudget({required Budget budget}) async {
    final url = isTestMode
        ? Uri.http(baseURL, '/api/budgets')
        : Uri.https(baseURL, '/api/budgets');
    final budgetResponse = await http.post(url,
        headers: await getHeaders(), body: json.encode(budget.toJson()));
    final newBudget = Budget.fromJson(jsonDecode(budgetResponse.body));
  }

  @override
  Future<String> createBeginningBudget() async {
    final url = isTestMode
        ? Uri.http(baseURL, '/api/budgets')
        : Uri.https(baseURL, '/api/budgets');
    final budgetResponse = await http.post(url, headers: await getHeaders());
    final newBudget = Budget.fromJson(jsonDecode(budgetResponse.body));
    return newBudget.id;
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
