import 'package:budget_app/transaction/models/models.dart';
import 'package:budget_app/utils/utils.dart';
import 'package:isar/isar.dart';
import 'package:network/network.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import '../../accounts_list/models/account.dart';
import '../../budgets/budgets.dart';
import '../../categories/models/category.dart';
import '../../constants/api.dart';
import '../../subcategories/models/subcategory.dart';

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
  Future<void> createCategory(Category category);

  Future<void> updateCategory(Category category);

  //SUBCATEGORIES
  Future<void> createSubcategory(Category category, Subcategory subcategory);

  Future<void> updateSubcategory(Category category, Subcategory subcategory);

  //OTHER
  Future<void> updateBudgetOnTransaction(Transaction transaction);

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
    //final currentBudget = _budgetStreamController.value;
    //_budgetStreamController.add(currentBudget.copyWith(accountList: accounts));
  }

  Category _getCategoryById(String id) =>
      _budgetStreamController.value.categoryList
          .where((cat) => cat.id == id)
          .first;
}

class BudgetRepositoryIsar extends BudgetRepository {
  BudgetRepositoryIsar({required this.isar});

  final Isar isar;
  final _budgetStreamController = BehaviorSubject<Budget>();

  @override
  Stream<Budget> get budget => _budgetStreamController.asBroadcastStream();

  @override
  Future<List<String>> fetchAvailableBudgets() async {
    final budgets = await isar.budgets.where().findAll();
    final result = budgets.map((b) => b.id).toList();
    return result;
  }

  @override
  Future<void> fetchBudget(String budgetId) async {
    final budget = await isar.budgets.get(fastHash(budgetId));
    _budgetStreamController.add(budget!);
  }

  @override
  Future<String> createBeginningBudget() async {
    final beginningBudget = Budget(
        id: Uuid().v4(), categoryList: _categoryList, accountList: accountList);
    try {
      await isar.writeTxnSync(() async {
        await isar.budgets.putSync(beginningBudget);
      });
      return beginningBudget.id;
    } catch (e) {
      print(e);
    }
    return '';
  }

  @override
  Future<void> createAccount(Account account) async {
    final currentBudget = _budgetStreamController.value;
    final accounts = [...currentBudget.accountList];
    accounts.add(account);
    await isar.writeTxn(() async {
      final budget = await isar.budgets.get(currentBudget.isarId);
      await isar.budgets.put(
          budget!.copyWith(accountList: accounts)); // perform update operations
    });

    _budgetStreamController.add(currentBudget.copyWith(accountList: accounts));
  }

  @override
  Future<void> updateAccount(Account account) async {
    final currentBudget = _budgetStreamController.value;
    final accounts = [...currentBudget.accountList];
    final accIndex = accounts.indexWhere((acc) => acc.id == account.id);
    accounts.removeAt(accIndex);
    accounts.insert(accIndex, account);
    await isar.writeTxn(() async {
      final budget = await isar.budgets.get(currentBudget.isarId);
      await isar.budgets.put(
          budget!.copyWith(accountList: accounts)); // perform update operations
    });
    _budgetStreamController.add(currentBudget.copyWith(accountList: accounts));
  }

  @override
  Future<void> createCategory(Category category) async {
    final currentBudget = _budgetStreamController.value;
    final categories = [...currentBudget.categoryList];
    categories.add(category);
    await isar.writeTxn(() async {
      final budget = await isar.budgets.get(currentBudget.isarId);
      await isar.budgets.put(budget!
          .copyWith(categoryList: categories)); // perform update operations
    });
    _budgetStreamController
        .add(currentBudget.copyWith(categoryList: categories));
  }

  @override
  Future<void> updateCategory(Category category) async {
    final currentBudget = _budgetStreamController.value;
    final categories = [...currentBudget.categoryList];
    final catIndex = categories.indexWhere((cat) => cat.id == category.id);
    categories.removeAt(catIndex);
    categories.insert(catIndex, category);
    await isar.writeTxn(() async {
      final budget = await isar.budgets.get(currentBudget.isarId);
      await isar.budgets.put(budget!
          .copyWith(categoryList: categories)); // perform update operations
    });
    _budgetStreamController
        .add(currentBudget.copyWith(categoryList: categories));
  }

  @override
  Future<void> createSubcategory(
      Category category, Subcategory subcategory) async {
    final currentBudget = _budgetStreamController.value;
    final subcategoriesCopy = [
      ..._getCategoryById(category.id).subcategoryList
    ];

    subcategoriesCopy.add(subcategory);

    final categories = [..._budgetStreamController.value.categoryList];
    final catIndex = categories.indexWhere((cat) => cat.id == category.id);

    categories.removeAt(catIndex);
    categories.insert(
        catIndex, category.copyWith(subcategoryList: subcategoriesCopy));
    await isar.writeTxn(() async {
      final budget = await isar.budgets.get(currentBudget.isarId);
      await isar.budgets.put(budget!
          .copyWith(categoryList: categories)); // perform update operations
    });
    _budgetStreamController
        .add(currentBudget.copyWith(categoryList: categories));
  }

  @override
  Future<void> updateSubcategory(
      Category category, Subcategory subcategory) async {
    final currentBudget = _budgetStreamController.value;

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
    await isar.writeTxn(() async {
      final budget = await isar.budgets.get(currentBudget.isarId);
      await isar.budgets.put(budget!
          .copyWith(categoryList: categories)); // perform update operations
    });
    _budgetStreamController
        .add(currentBudget.copyWith(categoryList: categories));
  }

  @override
  Future<void> deleteBudget() async {
    final currentBudget = _budgetStreamController.value;
  }

  @override
  Future<void> updateBudgetOnTransaction(Transaction transaction) async {
    final budget = _budgetStreamController.value;
    final updatedAccounts = transaction.type == TransactionType.TRANSFER
        ? await _updateBudgetOnTransfer(budget: budget, transfer: transaction)
        : await _updateBudgetOnTransaction(budget: budget, transaction: transaction);

    await isar.writeTxn(() async {
      await isar.budgets.put(budget.copyWith(accountList: updatedAccounts));
    });
    _budgetStreamController.add(budget.copyWith(accountList: updatedAccounts));
  }

  Future<List<Account>> _updateBudgetOnTransaction({required Budget budget, required Transaction transaction}) async {
    List<Account> updatedAccounts = [];

    //find the acc from editedTransaction and return amount
    //find the acc from transaction and update amount
    if (transaction.id != null) {
      final editedTr = await isar.transactions.get(transaction.isarId);
      updatedAccounts = budget.accountList.map((acc) {
        if (acc.id == editedTr!.fromAccountId) {
          return acc.copyWith(
              balance: acc.balance +
                  (editedTr.type == TransactionType.EXPENSE
                      ? editedTr.amount
                      : -editedTr.amount));
        } else {
          return acc;
        }
      }).toList();
    } else {
      updatedAccounts = [...budget.accountList];
    }
    updatedAccounts = updatedAccounts.map((acc) {
      if (acc.id == transaction.fromAccountId) {
        return acc.copyWith(
            balance: acc.balance +
                (transaction.type == TransactionType.EXPENSE
                    ? -transaction.amount
                    : transaction.amount));
      } else {
        return acc;
      }
    }).toList();

    return updatedAccounts;
  }

  Future<List<Account>> _updateBudgetOnTransfer({required Budget budget, required Transaction transfer}) async {
    List<Account> updatedAccounts = [];

    //find the acc from editedTransaction and return amount
    //find the acc from transaction and update amount
    if (transfer.id != null) {
      final editedTr = await isar.transactions.get(transfer.isarId);
      updatedAccounts = budget.accountList.map((acc) {
        if (acc.id == editedTr!.fromAccountId) {
          return acc.copyWith(balance: acc.balance + editedTr.amount);
        } else {
          return acc;
        }
      }).toList();
      updatedAccounts = updatedAccounts.map((acc) {
        if (acc.id == editedTr!.toAccountId) {
          return acc.copyWith(balance: acc.balance - editedTr.amount);
        } else {
          return acc;
        }
      }).toList();
    } else {
      updatedAccounts = [...budget.accountList];
    }

    updatedAccounts = updatedAccounts.map((acc) {
      if (acc.id == transfer.fromAccountId) {
        return acc.copyWith(balance: acc.balance - transfer.amount);
      } else {
        return acc;
      }
    }).toList();
    updatedAccounts = updatedAccounts.map((acc) {
      if (acc.id == transfer.toAccountId) {
        return acc.copyWith(balance: acc.balance + transfer.amount);
      } else {
        return acc;
      }
    }).toList();

    return updatedAccounts;
  }

  Category _getCategoryById(String id) =>
      _budgetStreamController.value.categoryList
          .where((cat) => cat.id == id)
          .first;
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
