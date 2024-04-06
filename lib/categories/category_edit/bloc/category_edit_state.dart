part of 'category_edit_bloc.dart';

enum CategoryEditStatus { loading, success, failure }

class CategoryEditState extends Equatable {
  final String? id;
  final Budget? budget;
  final String? name;
  final int iconCode;
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
    this.subcategoryList = const [],
    this.type = TransactionType.EXPENSE,
    this.budget,
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage,
    this.catStatus = CategoryEditStatus.loading,
  });

  CategoryEditState copyWith({
    String? id,
    String? name,
    int? iconCode,
    List<Subcategory>? subcategoryList,
    TransactionType? type,
    Budget? budget,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
    CategoryEditStatus? catStatus,
  }) {
    return CategoryEditState(
      id: id ?? this.id,
      name: name ?? this.name,
      iconCode: iconCode ?? this.iconCode,
      subcategoryList: subcategoryList ?? this.subcategoryList,
      type: type ?? this.type,
      budget: budget ?? this.budget,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
      catStatus: catStatus ?? this.catStatus,
    );
  }

  @override
  List<Object?> get props => [
        budget,
        id,
        name,
        iconCode,
        subcategoryList,
        type,
        status,
        isValid,
        errorMessage,
        catStatus
      ];
}
