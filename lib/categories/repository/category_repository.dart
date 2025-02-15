import '../../database/database.dart';
import '../../transaction/models/transaction_type.dart';

abstract class CategoryRepository {
  Stream<List<Category>> get categories;

  Stream<List<Subcategory>> get subcategories;

  Future<int> insertCategory(
      {required String name,
      required int iconCode,
      required TransactionType type});

  Future<void> updateCategory({required int id, required String name,
    required int iconCode,
    required TransactionType type});

  Future<Category> getCategoryById(int categoryId);

  Future<List<Category>> getAllCategories();

  Future<int> deleteCategory(Category category);
}
