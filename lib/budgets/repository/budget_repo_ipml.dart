import 'package:budget_app/budgets/repository/shared_extension.dart';
import 'package:network/network.dart';
import 'package:rxdart/rxdart.dart';

import '../../accounts_list/models/models.dart';
import '../../categories/models/models.dart';
import '../../constants/api.dart';
import '../../subcategories/models/models.dart';
import '../../transaction/models/models.dart';
import '../models/models.dart';
import 'budget_repository.dart';

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
        ..._getCategoryById(category.id).subcategoryList
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
        ..._getCategoryById(category.id).subcategoryList
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
  Future<void> updateBudgetOnTransaction(Transaction transaction) async {
    final budget = _budgetStreamController.value;
    Transaction? editedTransaction;
    if (transaction.id != null) {
      editedTransaction = await _fetchTransactionById(transaction.id!);
    }
    final updatedAccounts = transaction.type == TransactionType.TRANSFER
        ? await SharedExtension.updateBudgetOnTransfer(
        budget: budget,
        transfer: transaction,
        editedTransaction: editedTransaction)
        : await SharedExtension.updateBudgetOnTransaction(
        budget: budget,
        transaction: transaction,
        editedTransaction: editedTransaction);

    _budgetStreamController.add(budget.copyWith(accountList: updatedAccounts));
  }

  Future<Transaction> _fetchTransactionById(String transactionId) async {
    try {
      final response = await _networkClient.get<Map<String, dynamic>>(
          baseURL + '/api/transactions/$transactionId');
      return Transaction.fromJson(response.data!);
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  Category _getCategoryById(String id) =>
      _budgetStreamController.value.categoryList
          .where((cat) => cat.id == id)
          .first;
}
