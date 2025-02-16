import '../../database/database.dart';
import '../../transaction/models/transaction_type.dart';

abstract class CategoryRepository {
  Stream<List<Category>> get categories;

  Stream<List<Subcategory>> get subcategories;

  Future<int> insertCategory(
      {required String name,
      required int iconCode,
      required TransactionType type});

  Future<void> updateCategory(
      {required int id,
      required String name,
      required int iconCode,
      required TransactionType type});

  Future<int> insertSubcategory(
      {required String name, required int categoryId});

  Future<void> updateSubcategory(
      {required int id, required String name, required int categoryId});

  Future<Category> getCategoryById(int categoryId);

  Future<List<Category>> getAllCategories();

  Future<int> deleteCategory(int categoryId);
  Future<int> deleteSubcategory(int subcategoryId);

  Future<Subcategory> getSubcategoryById(int subcategoryId);

  Future<List<Subcategory>> fetchSubcategoriesByCategoryId(int categoryId);
}
