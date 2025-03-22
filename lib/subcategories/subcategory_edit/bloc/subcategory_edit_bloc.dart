import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:qruto_budget/categories/repository/category_repository.dart';
import 'package:qruto_budget/database/database.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'subcategory_edit_event.dart';
part 'subcategory_edit_state.dart';

class SubcategoryEditBloc
    extends Bloc<SubcategoryEditEvent, SubcategoryEditState> {
  final CategoryRepository _categoryRepository;

  SubcategoryEditBloc({required CategoryRepository categoryRepository})
      : _categoryRepository = categoryRepository,
        super(SubcategoryEditState()) {
    on<SubcategoryEditEvent>(_onEvent, transformer: sequential());
  }

  Future<void> _onEvent(
      SubcategoryEditEvent event, Emitter<SubcategoryEditState> emit) async {
    return switch (event) {
      final SubcategoriesChanged e => _onSubcategoriesChanged(e, emit),
      final SubcategoryEditFormLoaded e => _onFormLoaded(e, emit),
      final SubcategoryNameChanged e => _onNameChanged(e, emit),
      final SubcategoryFormSubmitted e => _onFormSubmitted(e, emit),
    };
  }

  Future<void> _onFormLoaded(SubcategoryEditFormLoaded event,
      Emitter<SubcategoryEditState> emit) async {
    if (event.subcategoryId != null) {
      Subcategory subcategory =
          await _categoryRepository.getSubcategoryById(event.subcategoryId!);
      Category category =
          await _categoryRepository.getCategoryById(subcategory.categoryId);
      emit(state.copyWith(
          category: category,
          id: subcategory.id,
          name: subcategory.name,
          isValid: true));
    } else {
      Category category =
          await _categoryRepository.getCategoryById(event.categoryId);
      emit(state.copyWith(
          category: category, catStatus: SubcategoryEditStatus.success));
    }
  }

  void _onNameChanged(
      SubcategoryNameChanged event, Emitter<SubcategoryEditState> emit) {
    emit(state.copyWith(name: event.name));
  }

  void _onSubcategoriesChanged(
      SubcategoriesChanged event, Emitter<SubcategoryEditState> emit) {
    emit(state.copyWith(subcategories: event.subcategories));
  }

  Future<void> _onFormSubmitted(SubcategoryFormSubmitted event,
      Emitter<SubcategoryEditState> emit) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final isIdExist = state.id != null;
    isIdExist
        ? _categoryRepository.updateSubcategory(
            categoryId: state.category!.id, name: state.name!, id: state.id!)
        : _categoryRepository.insertSubcategory(
            name: state.name!, categoryId: state.category!.id);
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
