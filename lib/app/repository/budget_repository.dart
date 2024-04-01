import 'package:network/network.dart';
import 'package:rxdart/rxdart.dart';

import '../../budgets/budgets.dart';
import '../../constants/api.dart';
import '../../transaction/transaction.dart';

abstract class BudgetRepository {
  // BUDGETS
  Future<List<String>> fetchAvailableBudgets();

  Future<void> fetchBudget(String budgetId);

  Stream<Budget> get budget;

  Future<String> createBeginningBudget();

  //ACCOUNTS
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

  Future<void> deleteBudget();
}

class BudgetRepositoryImpl extends BudgetRepository {
  BudgetRepositoryImpl({NetworkClient? networkClient})
      : _networkClient = networkClient ?? NetworkClient.instance;

  final NetworkClient _networkClient;

  final _budgetStreamController = BehaviorSubject<Budget>();

  @override
  Stream<Budget> get budget => _budgetStreamController.asBroadcastStream();

  @override
  Future<List<String>> fetchAvailableBudgets() async {
    try {
      final response =
          await _networkClient.get<List<dynamic>>(baseURL + '/api/budgets');
      final result = response.data!.map((b) => b as String).toList();
      return result;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  @override
  Future<void> fetchBudget(String budgetId) async {
    try {
      final response = await _networkClient
          .get<Map<String, dynamic>>(baseURL + '/api/budgets/$budgetId');
      final result = Budget.fromJson(response.data!);
      _budgetStreamController.add(result);
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  @override
  Future<String> createBeginningBudget() async {
    try {
      final response = await _networkClient
          .post<Map<String, dynamic>>(baseURL + '/api/budgets');
      final result = Budget.fromJson(response.data!);
      return result.id;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
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
    try {
      final response = await _networkClient
          .post<Map<String, dynamic>>(baseURL + path, data: account.toJson());
      final newCategory = Account.fromJson(response.data!);
      final accounts = [..._budgetStreamController.value.accountList];
      accounts.add(account);
      _budgetStreamController
          .add(currentBudget.copyWith(accountList: accounts));
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  @override
  Future<void> updateAccount(Account account) async {
    final currentBudget = _budgetStreamController.value;
    final path = '/api/budgets/${currentBudget.id}/accounts';

    try {
      final response = await _networkClient
          .put<Map<String, dynamic>>(baseURL + path, data: account.toJson());
      final updatedAccount = Account.fromJson(response.data!);
      final accounts = [...currentBudget.accountList];
      final accIndex = accounts.indexWhere((acc) => acc.id == account.id);
      accounts.removeAt(accIndex);
      accounts.insert(accIndex, account);
      _budgetStreamController
          .add(currentBudget.copyWith(accountList: accounts));
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
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

    try {
      final response = await _networkClient
          .post<Map<String, dynamic>>(baseURL + path, data: category.toJson());
      final newCategory = Category.fromJson(response.data!);
      final categories = [...currentBudget.categoryList];
      categories.add(category);
      _budgetStreamController
          .add(currentBudget.copyWith(categoryList: categories));
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  @override
  Future<void> updateCategory(Category category) async {
    final currentBudget = _budgetStreamController.value;
    final path = '/api/budgets/${currentBudget.id}/categories';

    try {
      final response = await _networkClient
          .put<Map<String, dynamic>>(baseURL + path, data: category.toJson());
      final updatedCategory = Category.fromJson(response.data!);
      final categories = [...currentBudget.categoryList];
      final catIndex = categories.indexWhere((cat) => cat.id == category.id);
      categories.removeAt(catIndex);
      categories.insert(catIndex, category);
      _budgetStreamController
          .add(currentBudget.copyWith(categoryList: categories));
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  @override
  Future<void> createSubcategory(
      Category category, Subcategory subcategory) async {
    final currentBudget = _budgetStreamController.value;
    final path =
        '/api/budgets/${currentBudget.id}/categories/${category.id}/subcategories';

    try {
      final response = await _networkClient.post<Map<String, dynamic>>(
          baseURL + path,
          data: subcategory.toJson());
      final subcategoriesCopy = [
        ...getCategoryById(category.id).subcategoryList
      ];

      subcategoriesCopy.add(subcategory);

      final categories = [..._budgetStreamController.value.categoryList];
      final catIndex = categories.indexWhere((cat) => cat.id == category.id);

      categories.removeAt(catIndex);
      categories.insert(
          catIndex, category.copyWith(subcategoryList: subcategoriesCopy));

      _budgetStreamController
          .add(currentBudget.copyWith(categoryList: categories));
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  @override
  Future<void> updateSubcategory(
      Category category, Subcategory subcategory) async {
    final currentBudget = _budgetStreamController.value;
    final path =
        '/api/budgets/${currentBudget.id}/categories/${category.id}/subcategories';

    try {
      final response = await _networkClient.put<Map<String, dynamic>>(
          baseURL + path,
          data: subcategory.toJson());
      final subcategoriesCopy = [
        ...getCategoryById(category.id).subcategoryList
      ];
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
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  @override
  Future<void> deleteBudget() async {
    final currentBudget = _budgetStreamController.value;

    try {
      await _networkClient.delete<Map<String, dynamic>>(
          baseURL + '/api/budgets/${currentBudget.id}');
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  @override
  void pushUpdatedAccounts(List<Account> accounts) {
    final currentBudget = _budgetStreamController.value;
    _budgetStreamController.add(currentBudget.copyWith(accountList: accounts));
  }
}
