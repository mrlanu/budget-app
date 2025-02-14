import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:budget_app/categories/repository/category_repository.dart';
import 'package:budget_app/database/database.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'subcategory_edit_event.dart';
part 'subcategory_edit_state.dart';

class SubcategoryEditBloc
    extends Bloc<SubcategoryEditEvent, SubcategoryEditState> {
  final CategoryRepository _categoryRepository;
  late final StreamSubscription<List<Subcategory>> _subcategoriesSubscription;

  SubcategoryEditBloc({required CategoryRepository categoryRepository})
      : _categoryRepository = categoryRepository,
        super(SubcategoryEditState()) {
    on<SubcategoryEditEvent>(_onEvent, transformer: sequential());
    _subcategoriesSubscription = _categoryRepository.subcategories.listen((subcategories) {
      add(SubcategoriesChanged(subcategories: subcategories));
    });
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

  Future<void> _onFormLoaded(
      SubcategoryEditFormLoaded event, Emitter<SubcategoryEditState> emit) async {
    if (event.subcategory != null) {
      Subcategory subcategory = event.subcategory!;
      emit(state.copyWith(
          category: event.category,
          id: subcategory.id,
          name: subcategory.name,
          isValid: true));
    } else {
      emit(state.copyWith(
          category: event.category, catStatus: SubcategoryEditStatus.success));
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

  Future<void> _onFormSubmitted(
      SubcategoryFormSubmitted event, Emitter<SubcategoryEditState> emit) async {
    /*emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final isIdExist = state.id != null;
    final subcategory = Subcategory(
      id: isIdExist ? state.id! : Uuid().v4(),
      name: state.name!,
    );
    isIdExist
        ? _budgetRepository.updateSubcategory(state.category!, subcategory)
        : _budgetRepository.createSubcategory(state.category!, subcategory);*/
  }

  @override
  Future<void> close() {
    _subcategoriesSubscription.cancel();
    return super.close();
  }
}
