part of 'categories_cubit.dart';

enum CategoriesStatus { loading, success, failure }

class CategoriesState extends Equatable {
  final CategoriesStatus status;
  final List<Category> categories;
  final TransactionType transactionType;
  final String? name;
  final int iconCode;
  final Category? editCategory;
  final String? errorMessage;

  const CategoriesState(
      {this.status = CategoriesStatus.loading,
      this.categories = const [],
      this.transactionType = TransactionType.EXPENSE,
      this.name,
      this.iconCode = -1,
      this.editCategory,
      this.errorMessage});

  CategoriesState copyWith(
      {CategoriesStatus? status,
      List<Category>? categories,
      TransactionType? transactionType,
      String? name,
      int? iconCode,
      Category? editCategory,
      String? errorMessage}) {
    return CategoriesState(
        status: status ?? this.status,
        categories: categories ?? this.categories,
        transactionType: transactionType ?? this.transactionType,
        name: name ?? this.name,
        iconCode: iconCode ?? this.iconCode,
        editCategory: editCategory ?? this.editCategory,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  CategoriesState resetCategory() {
    return CategoriesState(
        status: this.status,
        categories: this.categories,
        transactionType: this.transactionType,
        name: null,
        iconCode: 0,
        editCategory: null);
  }

  @override
  List<Object?> get props => [
        status,
        categories,
        transactionType,
        name,
        iconCode,
        editCategory,
        errorMessage
      ];
}
