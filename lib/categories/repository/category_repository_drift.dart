import 'package:budget_app/categories/repository/category_repository.dart';

import '../../database/database.dart';
import '../../transaction/models/transaction_type.dart';

class CategoryRepositoryDrift extends CategoryRepository {
  CategoryRepositoryDrift({required AppDatabase database})
      : _database = database;

  final AppDatabase _database;

  @override
  Stream<List<Category>> get categories => _database.watchAllCategories();

  @override
  Stream<List<Subcategory>> get subcategories =>
      _database.watchAllSubcategories();

  @override
  Future<int> insertCategory(
          {required String name,
          required int iconCode,
          required TransactionType type}) =>
      _database.insert(CategoriesCompanion.insert(
          name: name, iconCode: iconCode, type: type));

  @override
  Future<void> updateCategory(
          {required int id,
          required String name,
          required int iconCode,
          required TransactionType type}) =>
      _database.updateCategory(
          Category(id: id, name: name, iconCode: iconCode, type: type));

  @override
  Future<List<Category>> getAllCategories() => _database.getAllCategories();

  @override
  Future<Category> getCategoryById(int categoryId) =>
      _database.categoryById(categoryId);

  @override
  Future<int> deleteCategory(Category category) =>
      _database.deleteCategory(category.id);
}
