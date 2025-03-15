part of 'subcategory_edit_bloc.dart';

sealed class SubcategoryEditEvent extends Equatable {
  const SubcategoryEditEvent();
}

final class SubcategoryEditFormLoaded extends SubcategoryEditEvent {
  final int categoryId;
  final int? subcategoryId;
  SubcategoryEditFormLoaded({required this.categoryId, this.subcategoryId});
  @override
  List<Object?> get props => [subcategoryId, categoryId];
}

final class SubcategoryNameChanged extends SubcategoryEditEvent {
  final String name;

  SubcategoryNameChanged({required this.name});

  @override
  List<Object?> get props => [name];
}


final class SubcategoriesChanged extends SubcategoryEditEvent {
  final List<Subcategory> subcategories;
  const SubcategoriesChanged({required this.subcategories});
  @override
  List<Object?> get props => [subcategories];
}


final class SubcategoryFormSubmitted extends SubcategoryEditEvent {
  const SubcategoryFormSubmitted();
  @override
  List<Object?> get props => [];
}
