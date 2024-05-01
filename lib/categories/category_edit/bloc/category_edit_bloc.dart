import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:budget_app/transaction/repository/budget_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:isar/isar.dart';

import '../../../subcategories/models/subcategory.dart';
import '../../../transaction/models/transaction_type.dart';
import '../../models/category.dart';

part 'category_edit_event.dart';
part 'category_edit_state.dart';

class CategoryEditBloc extends Bloc<CategoryEditEvent, CategoryEditState> {
  final BudgetRepository _transactionsRepository;

  CategoryEditBloc({required BudgetRepository transactionsRepository})
      : _transactionsRepository = transactionsRepository,
        super(CategoryEditState()) {
    on<CategoryEditEvent>(_onEvent, transformer: sequential());
  }

  Future<void> _onEvent(
      CategoryEditEvent event, Emitter<CategoryEditState> emit) async {
    return switch (event) {
      final CategoryCategoriesChanged e => _onCategoriesChanged(e, emit),
      final CategoryEditFormLoaded e => _onFormLoaded(e, emit),
      final CategoryNameChanged e => _onNameChanged(e, emit),
      final CategoryIconChanged e => _onIconChanged(e, emit),
      final CategoryFormSubmitted e => _onFormSubmitted(e, emit),
    };
  }

  Future<void> _onFormLoaded(
      CategoryEditFormLoaded event, Emitter<CategoryEditState> emit) async {
    emit(state.copyWith(catStatus: CategoryEditStatus.loading));
    if (event.categoryId != null) {
      final category =
          await _transactionsRepository.fetchCategoryById(event.categoryId!);
      emit(state.copyWith(
          id: category!.id,
          name: category.name,
          iconCode: category.iconCode,
          subcategoryList: [],
          type: category.type,
          isValid: true,
          catStatus: CategoryEditStatus.success));
    } else {
      emit(state.copyWith(
          type: event.type, catStatus: CategoryEditStatus.success));
    }
  }

  void _onNameChanged(
      CategoryNameChanged event, Emitter<CategoryEditState> emit) {
    emit(
      state.copyWith(name: event.name),
    );
  }

  void _onCategoriesChanged(
      CategoryCategoriesChanged event, Emitter<CategoryEditState> emit) {
    emit(state.copyWith(categoryList: event.categories));
  }

  void _onIconChanged(
      CategoryIconChanged event, Emitter<CategoryEditState> emit) {
    emit(state.copyWith(iconCode: event.code));
  }

  Future<void> _onFormSubmitted(
      CategoryFormSubmitted event, Emitter<CategoryEditState> emit) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final category = Category(
        id: state.id?? Isar.autoIncrement,
        name: state.name!,
        iconCode: state.iconCode,
        subcategoryList: state.subcategoryList,
        type: state.type);
    _transactionsRepository.saveCategory(category);
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
