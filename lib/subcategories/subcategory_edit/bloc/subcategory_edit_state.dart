part of 'subcategory_edit_bloc.dart';

enum SubcategoryEditStatus { loading, success, failure }

class SubcategoryEditState extends Equatable {
  final int? id;
  final List<Subcategory> subcategories;
  final Category? category;
  final String? name;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;
  final SubcategoryEditStatus catStatus;

  const SubcategoryEditState({
    this.id,
    this.name,
    this.subcategories = const [],
    this.category,
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage,
    this.catStatus = SubcategoryEditStatus.loading,
  });

  SubcategoryEditState copyWith({
    int? id,
    String? name,
    List<Subcategory>? subcategories,
    Category? category,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
    SubcategoryEditStatus? catStatus,
  }) {
    return SubcategoryEditState(
      id: id ?? this.id,
      name: name ?? this.name,
      subcategories: subcategories ?? this.subcategories,
      category: category ?? this.category,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
      catStatus: catStatus ?? this.catStatus,
    );
  }

  @override
  List<Object?> get props =>
      [id, name, subcategories, category, status, isValid, errorMessage, catStatus];
}
