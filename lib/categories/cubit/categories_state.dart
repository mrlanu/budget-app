part of 'categories_cubit.dart';

enum CategoriesStatus { loading, success, failure }

class CategoriesState extends Equatable {
  final CategoriesStatus status;
  final List<Category> categories;
  final TransactionType transactionType;
  final String? errorMessage;

  const CategoriesState(
      {this.status = CategoriesStatus.loading,
      this.categories = const [],
      this.transactionType = TransactionType.EXPENSE,
      this.errorMessage});

  List<Category> get filteredCategories => categories
      .where(
        (c) => c.type == transactionType,
      )
      .toList();

  CategoriesState copyWith(
      {CategoriesStatus? status,
      List<Category>? categories,
      TransactionType? transactionType,
      String? errorMessage}) {
    return CategoriesState(
        status: status ?? this.status,
        categories: categories ?? this.categories,
        transactionType: transactionType ?? this.transactionType,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  CategoriesState resetCategory() {
    return CategoriesState(
        status: this.status,
        categories: this.categories,
        transactionType: this.transactionType);
  }

  @override
  List<Object?> get props =>
      [status, categories, transactionType, errorMessage];
}
