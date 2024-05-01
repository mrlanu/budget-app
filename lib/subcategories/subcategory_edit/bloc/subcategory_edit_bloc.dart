import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:budget_app/transaction/repository/budget_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../../categories/models/category.dart';
import '../../models/subcategory.dart';

part 'subcategory_edit_event.dart';
part 'subcategory_edit_state.dart';

class SubcategoryEditBloc
    extends Bloc<SubcategoryEditEvent, SubcategoryEditState> {
  final BudgetRepository _transactionsRepository;

  SubcategoryEditBloc(
      {required int categoryId,
      required BudgetRepository transactionsRepository})
      : _transactionsRepository = transactionsRepository,
        super(SubcategoryEditState()) {
    on<SubcategoryEditEvent>(_onEvent, transformer: sequential());
  }

  Future<void> _onEvent(
      SubcategoryEditEvent event, Emitter<SubcategoryEditState> emit) async {
    return switch (event) {
      final SubcategoryEditFormLoaded e => _onFormLoaded(e, emit),
      final SubcategoryNameChanged e => _onNameChanged(e, emit),
      final SubcategoryFormSubmitted e => _onFormSubmitted(e, emit),
    };
  }

  Future<void> _onFormLoaded(SubcategoryEditFormLoaded event,
      Emitter<SubcategoryEditState> emit) async {
    final category =
    await _transactionsRepository.fetchCategoryById(event.categoryId);
    if (event.subcategoryName != null) {
      final index = category!.subcategoryList
          .indexWhere((s) => s.name == event.subcategoryName);
      emit(state.copyWith(
          category: category,
          position: index,
          name: category.subcategoryList[index].name,
          isValid: true));
    } else {
      emit(state.copyWith(
          category: category, catStatus: SubcategoryEditStatus.success));
    }
  }

  void _onNameChanged(
      SubcategoryNameChanged event, Emitter<SubcategoryEditState> emit) {
    emit(state.copyWith(name: event.name));
  }

  Future<void> _onFormSubmitted(SubcategoryFormSubmitted event,
      Emitter<SubcategoryEditState> emit) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final subcategory = Subcategory(
      name: state.name!,
    );
    final subcategories = [...state.category!.subcategoryList];
    state.position != null
        ? subcategories[state.position!] = subcategory
        : subcategories.add(subcategory);
    _transactionsRepository
        .saveCategory(state.category!.copyWith(subcategoryList: subcategories));
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
