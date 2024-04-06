import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:budget_app/budgets/budgets.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:uuid/uuid.dart';

import '../../../budgets/repository/budget_repository.dart';
import '../../../subcategories/models/subcategory.dart';
import '../../../transaction/models/transaction_type.dart';
import '../../models/category.dart';

part 'category_edit_event.dart';
part 'category_edit_state.dart';

class CategoryEditBloc extends Bloc<CategoryEditEvent, CategoryEditState> {
  final BudgetRepository _budgetRepository;
  late final StreamSubscription<Budget> _budgetSubscription;

  CategoryEditBloc({required BudgetRepository budgetRepository})
      : _budgetRepository = budgetRepository,
        super(CategoryEditState()) {
    on<CategoryEditEvent>(_onEvent, transformer: sequential());
    _budgetSubscription = _budgetRepository.budget.listen((budget) {
      add(CategoryBudgetChanged(budget: budget));
    });
  }

  Future<void> _onEvent(
      CategoryEditEvent event, Emitter<CategoryEditState> emit) async {
    return switch (event) {
      final CategoryBudgetChanged e => _onBudgetChanged(e, emit),
      final CategoryEditFormLoaded e => _onFormLoaded(e, emit),
      final CategoryNameChanged e => _onNameChanged(e, emit),
      final CategoryIconChanged e => _onIconChanged(e, emit),
      final CategoryFormSubmitted e => _onFormSubmitted(e, emit),
    };
  }

  Future<void> _onFormLoaded(
      CategoryEditFormLoaded event, Emitter<CategoryEditState> emit) async {
    emit(state.copyWith(catStatus: CategoryEditStatus.loading));
    if (event.category != null) {
      Category category = event.category!;
      emit(state.copyWith(
          id: category.id,
          name: category.name,
          iconCode: category.iconCode,
          subcategoryList: category.subcategoryList,
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

  void _onBudgetChanged(
      CategoryBudgetChanged event, Emitter<CategoryEditState> emit) {
    emit(state.copyWith(budget: event.budget));
  }

  void _onIconChanged(
      CategoryIconChanged event, Emitter<CategoryEditState> emit) {
    emit(state.copyWith(iconCode: event.code));
  }

  Future<void> _onFormSubmitted(
      CategoryFormSubmitted event, Emitter<CategoryEditState> emit) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final isIdExist = state.id != null;
    final category = Category(
        id: isIdExist ? state.id! : Uuid().v4(),
        name: state.name!,
        iconCode: state.iconCode,
        subcategoryList: state.subcategoryList,
        type: state.type);
    isIdExist
        ? _budgetRepository.updateCategory(category)
        : _budgetRepository.createCategory(category);
  }

  @override
  Future<void> close() {
    _budgetSubscription.cancel();
    return super.close();
  }
}
