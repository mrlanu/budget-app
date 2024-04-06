part of 'subcategory_edit_bloc.dart';

sealed class SubcategoryEditEvent extends Equatable {
  const SubcategoryEditEvent();
}

final class SubcategoryEditFormLoaded extends SubcategoryEditEvent {
  final Category category;
  final Subcategory? subcategory;
  SubcategoryEditFormLoaded({required this.category, this.subcategory});
  @override
  List<Object?> get props => [subcategory];
}

final class SubcategoryNameChanged extends SubcategoryEditEvent {
  final String name;

  SubcategoryNameChanged({required this.name});

  @override
  List<Object?> get props => [name];
}


final class SubcategoryBudgetChanged extends SubcategoryEditEvent {
  final Budget budget;
  const SubcategoryBudgetChanged({required this.budget});
  @override
  List<Object?> get props => [budget];
}


final class SubcategoryFormSubmitted extends SubcategoryEditEvent {
  const SubcategoryFormSubmitted();
  @override
  List<Object?> get props => [];
}
