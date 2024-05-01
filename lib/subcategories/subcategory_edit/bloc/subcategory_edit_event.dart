part of 'subcategory_edit_bloc.dart';

sealed class SubcategoryEditEvent extends Equatable {
  const SubcategoryEditEvent();
}

final class SubcategoryEditFormLoaded extends SubcategoryEditEvent {
  final int categoryId;
  final String? subcategoryName;
  SubcategoryEditFormLoaded({required this.categoryId, this.subcategoryName});
  @override
  List<Object?> get props => [categoryId, subcategoryName];
}

final class SubcategoryNameChanged extends SubcategoryEditEvent {
  final String name;

  SubcategoryNameChanged({required this.name});

  @override
  List<Object?> get props => [name];
}

final class SubcategoryFormSubmitted extends SubcategoryEditEvent {
  const SubcategoryFormSubmitted();
  @override
  List<Object?> get props => [];
}
