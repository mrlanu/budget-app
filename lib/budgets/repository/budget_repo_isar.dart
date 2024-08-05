import 'package:budget_app/budgets/repository/shared_extension.dart';
import 'package:isar/isar.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import '../../accounts_list/models/models.dart';
import '../../categories/models/models.dart';
import '../../subcategories/models/models.dart';
import '../../transaction/models/models.dart';
import '../../utils/fast_hash.dart';
import '../models/models.dart';
import 'budget_repository.dart';

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
    Transaction? editedTransaction;
    if (transaction.id != null) {
      editedTransaction = await isar.transactions.get(transaction.isarId);
    }
    final updatedAccounts = transaction.type == TransactionType.TRANSFER
        ? await SharedExtension.updateBudgetOnTransfer(
        budget: budget,
        transfer: transaction,
        editedTransaction: editedTransaction)
        : await SharedExtension.updateBudgetOnTransaction(budget: budget,
        transaction: transaction,
        editedTransaction: editedTransaction);

    await isar.writeTxn(() async {
      await isar.budgets.put(budget.copyWith(accountList: updatedAccounts));
    });
    _budgetStreamController.add(budget.copyWith(accountList: updatedAccounts));
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
