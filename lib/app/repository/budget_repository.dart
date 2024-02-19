import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import '../../budgets/budgets.dart';
import '../../constants/api.dart';
import '../../transaction/transaction.dart';

class BudgetFailure implements Exception {
  final String message;

  const BudgetFailure([
    this.message = 'An unknown exception occurred.',
  ]);
}

abstract class BudgetRepository {
  // BUDGETS
  Future<List<String>> fetchAvailableBudgets();
  Future<void> fetchBudget(String budgetId);
  Stream<Budget> get budget;
  Future<String> createBeginningBudget();

  //ACCOUNTS
  List<Account> getAccounts();
  Account getAccountById(String accountId);
  Future<void> createAccount(Account account);
  Future<void> updateAccount(Account account);

  //CATEGORIES
  List<Category> getCategories();
  Category getCategoryById(String name);
  List<Category> getCategoriesByType(TransactionType type);
  Future<void> createCategory(Category category);
  Future<void> updateCategory(Category category);

  //SUBCATEGORIES
  Future<void> createSubcategory(Category category, Subcategory subcategory);
  Future<void> updateSubcategory(Category category, Subcategory subcategory);

  //OTHER
  void pushUpdatedAccounts(List<Account> accounts);
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
  Future<String> createBeginningBudget() async {
    final url = isTestMode
        ? Uri.http(baseURL, '/api/budgets')
        : Uri.https(baseURL, '/api/budgets');
    final budgetResponse = await http.post(url, headers: await getHeaders());
    final newBudget = Budget.fromJson(jsonDecode(budgetResponse.body));
    return newBudget.id;
  }

  @override
  List<Account> getAccounts() => _budgetStreamController.value.accountList;

  @override
  Account getAccountById(String accountId) =>
      _budgetStreamController.value.accountList
          .where((acc) => acc.id == accountId)
          .first;

  @override
  Future<void> createAccount(Account account) async {
    final currentBudget = _budgetStreamController.value;
    final path = '/api/budgets/${currentBudget.id}/accounts';
    final url = isTestMode ? Uri.http(baseURL, path) : Uri.https(baseURL, path);
    final accResponse = await http.post(url,
        headers: await getHeaders(), body: json.encode(account.toJson()));
    if (accResponse.statusCode != 200) {
      throw BudgetFailure(jsonDecode(accResponse.body)['message']);
    }
    final newCategory = Account.fromJson(jsonDecode(accResponse.body));
    final accounts = [..._budgetStreamController.value.accountList];
    accounts.add(account);
    _budgetStreamController.add(currentBudget.copyWith(accountList: accounts));
  }

  @override
  Future<void> updateAccount(Account account) async {
    final currentBudget = _budgetStreamController.value;
    final path = '/api/budgets/${currentBudget.id}/accounts';
    final url = isTestMode ? Uri.http(baseURL, path) : Uri.https(baseURL, path);
    final accResponse = await http.put(url,
        headers: await getHeaders(), body: json.encode(account.toJson()));
    if (accResponse.statusCode != 200) {
      throw BudgetFailure(jsonDecode(accResponse.body)['message']);
    }
    final updatedAccount = Account.fromJson(jsonDecode(accResponse.body));
    final accounts = [...currentBudget.accountList];
    final accIndex = accounts.indexWhere((acc) => acc.id == account.id);
    accounts.removeAt(accIndex);
    accounts.insert(accIndex, account);
    _budgetStreamController.add(currentBudget.copyWith(accountList: accounts));
  }

  @override
  List<Category> getCategories() => _budgetStreamController.value.categoryList;

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
  Future<void> createCategory(Category category) async {
    final currentBudget = _budgetStreamController.value;

    final path = '/api/budgets/${currentBudget.id}/categories';
    final url = isTestMode ? Uri.http(baseURL, path) : Uri.https(baseURL, path);
    final catResponse = await http.post(url,
        headers: await getHeaders(), body: json.encode(category.toJson()));
    if (catResponse.statusCode != 200) {
      throw BudgetFailure(jsonDecode(catResponse.body)['message']);
    }
    final newCategory = Category.fromJson(jsonDecode(catResponse.body));
    final categories = [...currentBudget.categoryList];
    categories.add(category);
    _budgetStreamController
        .add(currentBudget.copyWith(categoryList: categories));
  }

  @override
  Future<void> updateCategory(Category category) async {
    final currentBudget = _budgetStreamController.value;

    final path = '/api/budgets/${currentBudget.id}/categories';
    final url = isTestMode ? Uri.http(baseURL, path) : Uri.https(baseURL, path);
    final catResponse = await http.put(url,
        headers: await getHeaders(), body: json.encode(category.toJson()));
    if (catResponse.statusCode != 200) {
      throw BudgetFailure(jsonDecode(catResponse.body)['message']);
    }
    final updatedCategory = Category.fromJson(jsonDecode(catResponse.body));
    final categories = [...currentBudget.categoryList];
    final catIndex = categories.indexWhere((cat) => cat.id == category.id);
    categories.removeAt(catIndex);
    categories.insert(catIndex, category);
    _budgetStreamController
        .add(currentBudget.copyWith(categoryList: categories));
  }

  @override
  Future<void> createSubcategory(
      Category category, Subcategory subcategory) async {
    final currentBudget = _budgetStreamController.value;
    final path =
        '/api/budgets/${currentBudget.id}/categories/${category.id}/subcategories';
    final url = isTestMode ? Uri.http(baseURL, path) : Uri.https(baseURL, path);
    final catResponse = await http.post(url,
        headers: await getHeaders(), body: json.encode(subcategory.toJson()));
    if (catResponse.statusCode != 200) {
      throw BudgetFailure(jsonDecode(catResponse.body)['message']);
    }
    final subcategoriesCopy = [...getCategoryById(category.id).subcategoryList];

    subcategoriesCopy.add(subcategory);

    final categories = [..._budgetStreamController.value.categoryList];
    final catIndex = categories.indexWhere((cat) => cat.id == category.id);

    categories.removeAt(catIndex);
    categories.insert(
        catIndex, category.copyWith(subcategoryList: subcategoriesCopy));

    _budgetStreamController
        .add(currentBudget.copyWith(categoryList: categories));
  }

  @override
  Future<void> updateSubcategory(
      Category category, Subcategory subcategory) async {
    final currentBudget = _budgetStreamController.value;
    final path =
        '/api/budgets/${currentBudget.id}/categories/${category.id}/subcategories';
    final url = isTestMode ? Uri.http(baseURL, path) : Uri.https(baseURL, path);
    final catResponse = await http.put(url,
        headers: await getHeaders(), body: json.encode(subcategory.toJson()));
    if (catResponse.statusCode != 200) {
      throw BudgetFailure(jsonDecode(catResponse.body)['message']);
    }
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

    _budgetStreamController
        .add(currentBudget.copyWith(categoryList: categories));
  }

  @override
  void pushUpdatedAccounts(List<Account> accounts) {
    final currentBudget = _budgetStreamController.value;
    _budgetStreamController.add(currentBudget.copyWith(accountList: accounts));
  }
}
