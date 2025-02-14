import '../../database/database.dart';

abstract class CategoryRepository {
  Stream<List<Category>> get categories;
  Stream<List<Subcategory>> get subcategories;
  Future<Category> createCategory(Category category);
  Future<void> updateCategory(Category category);
  Future<Category> getCategoryById(int categoryId);
  Future<List<Category>> getAllCategories();
}
