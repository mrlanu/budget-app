part of 'category_edit_bloc.dart';

sealed class CategoryEditEvent extends Equatable {
  const CategoryEditEvent();
}

final class CategoryEditFormLoaded extends CategoryEditEvent {
  final Category? category;
  final TransactionType type;
  CategoryEditFormLoaded({this.category, required this.type});
  @override
  List<Object?> get props => [category, type];
}

final class CategoryNameChanged extends CategoryEditEvent {
  final String name;

  CategoryNameChanged({required this.name});

  @override
  List<Object?> get props => [name];
}


final class CategoryIconChanged extends CategoryEditEvent {
  final int code;

  CategoryIconChanged({required this.code});

  @override
  List<Object?> get props => [code];
}


final class CategoryBudgetChanged extends CategoryEditEvent {
  final Budget budget;
  const CategoryBudgetChanged({required this.budget});
  @override
  List<Object?> get props => [budget];
}


final class CategoryFormSubmitted extends CategoryEditEvent {
  const CategoryFormSubmitted();
  @override
  List<Object?> get props => [];
}
