part of 'categories_cubit.dart';

enum CategoriesStatus { loading, success, failure }

class CategoriesState extends Equatable {
  final CategoriesStatus status;
  final List<Category> categories;
  final TransactionType transactionType;
  final String? name;
  final Category? editCategory;

  const CategoriesState({
    this.status = CategoriesStatus.loading,
    this.categories = const [],
    this.transactionType = TransactionType.EXPENSE,
    this.name,
    this.editCategory,
  });

  CategoriesState copyWith(
      {CategoriesStatus? status,
      List<Category>? categories,
      TransactionType? transactionType,
      String? name,
      Category? editCategory}) {
    return CategoriesState(
        status: status ?? this.status,
        categories: categories ?? this.categories,
        transactionType: transactionType ?? this.transactionType,
        name: name ?? this.name,
        editCategory: editCategory ?? this.editCategory);
  }

  CategoriesState resetCategory() {
    return CategoriesState(
        status: this.status,
        categories: this.categories,
        transactionType: this.transactionType,
        name: this.name,
        editCategory: null);
  }

  @override
  List<Object?> get props =>
      [status, categories, transactionType, name, editCategory];
}
