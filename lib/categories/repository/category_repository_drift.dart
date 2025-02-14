import 'package:budget_app/categories/repository/category_repository.dart';

import '../../database/database.dart';

class CategoryRepositoryDrift extends CategoryRepository {
  CategoryRepositoryDrift({required AppDatabase database})
      : _database = database;

  final AppDatabase _database;

  @override
  Stream<List<Category>> get categories => _database.watchAllCategories();

  @override
  Stream<List<Subcategory>> get subcategories => _database.watchAllSubcategories();

  @override
  Future<Category> createCategory(Category category) => _database.insertCategory(category);

  @override
  Future<List<Category>> getAllCategories() => _database.getAllCategories();

  @override
  Future<Category> getCategoryById(int categoryId) => _database.categoryById(categoryId);

  @override
  Future<void> updateCategory(Category category) => _database.updateCategory(category);
}
