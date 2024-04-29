part of 'category_edit_bloc.dart';

enum CategoryEditStatus { loading, success, failure }

class CategoryEditState extends Equatable {
  final int? id;
  final String? name;
  final int iconCode;
  final List<Category> categoryList;
  final List<Subcategory> subcategoryList;
  final TransactionType type;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;
  final CategoryEditStatus catStatus;

  const CategoryEditState({
    this.id,
    this.name,
    this.iconCode = -1,
    this.categoryList = const [],
    this.subcategoryList = const [],
    this.type = TransactionType.EXPENSE,
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage,
    this.catStatus = CategoryEditStatus.loading,
  });

  CategoryEditState copyWith({
    int? id,
    String? name,
    int? iconCode,
    List<Category>? categoryList,
    List<Subcategory>? subcategoryList,
    TransactionType? type,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
    CategoryEditStatus? catStatus,
  }) {
    return CategoryEditState(
      id: id ?? this.id,
      name: name ?? this.name,
      iconCode: iconCode ?? this.iconCode,
      categoryList: categoryList ?? this.categoryList,
      subcategoryList: subcategoryList ?? this.subcategoryList,
      type: type ?? this.type,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
      catStatus: catStatus ?? this.catStatus,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        iconCode,
        categoryList,
        subcategoryList,
        type,
        status,
        isValid,
        errorMessage,
        catStatus
      ];
}
