import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:budget_app/budgets/budgets.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:uuid/uuid.dart';

import '../../../budgets/repository/budget_repository.dart';
import '../../../categories/models/category.dart';
import '../../models/subcategory.dart';

part 'subcategory_edit_event.dart';
part 'subcategory_edit_state.dart';

class SubcategoryEditBloc
    extends Bloc<SubcategoryEditEvent, SubcategoryEditState> {
  final BudgetRepository _budgetRepository;
  late final StreamSubscription<Budget> _budgetSubscription;

  SubcategoryEditBloc({required BudgetRepository budgetRepository})
      : _budgetRepository = budgetRepository,
        super(SubcategoryEditState()) {
    on<SubcategoryEditEvent>(_onEvent, transformer: sequential());
    _budgetSubscription = _budgetRepository.budget.listen((budget) {
      add(SubcategoryBudgetChanged(budget: budget));
    });
  }

  Future<void> _onEvent(
      SubcategoryEditEvent event, Emitter<SubcategoryEditState> emit) async {
    return switch (event) {
      final SubcategoryBudgetChanged e => _onBudgetChanged(e, emit),
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

  void _onBudgetChanged(
      SubcategoryBudgetChanged event, Emitter<SubcategoryEditState> emit) {
    emit(state.copyWith(budget: event.budget));
  }

  Future<void> _onFormSubmitted(
      SubcategoryFormSubmitted event, Emitter<SubcategoryEditState> emit) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final isIdExist = state.id != null;
    final subcategory = Subcategory(
      id: isIdExist ? state.id! : Uuid().v4(),
      name: state.name!,
    );
    isIdExist
        ? _budgetRepository.updateSubcategory(state.category!, subcategory)
        : _budgetRepository.createSubcategory(state.category!, subcategory);
  }

  @override
  Future<void> close() {
    _budgetSubscription.cancel();
    return super.close();
  }
}
