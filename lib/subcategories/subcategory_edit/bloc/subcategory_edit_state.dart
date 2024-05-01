part of 'subcategory_edit_bloc.dart';

enum SubcategoryEditStatus { loading, success, failure }

class SubcategoryEditState extends Equatable {
  final int? position;
  final Category? category;
  final String? name;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;
  final SubcategoryEditStatus catStatus;

  const SubcategoryEditState({
    this.position,
    this.name,
    this.category,
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage,
    this.catStatus = SubcategoryEditStatus.loading,
  });

  SubcategoryEditState copyWith({
    int? position,
    String? name,
    Category? category,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
    SubcategoryEditStatus? catStatus,
  }) {
    return SubcategoryEditState(
      position: position ?? this.position,
      name: name ?? this.name,
      category: category ?? this.category,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
      catStatus: catStatus ?? this.catStatus,
    );
  }

  @override
  List<Object?> get props =>
      [position, name, category, status, isValid, errorMessage, catStatus];
}
