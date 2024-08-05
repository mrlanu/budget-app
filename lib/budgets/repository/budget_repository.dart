import 'package:budget_app/transaction/models/models.dart';

import '../../accounts_list/models/account.dart';
import '../../budgets/budgets.dart';
import '../../categories/models/category.dart';
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
