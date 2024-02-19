import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budget_app/app/repository/budget_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../../budgets/budgets.dart';

part 'subcategories_state.dart';

class SubcategoriesCubit extends Cubit<SubcategoriesState> {
  final BudgetRepository _budgetRepository;
  late final StreamSubscription<Budget> _budgetSubscription;

  SubcategoriesCubit(
      {required BudgetRepository budgetRepository, required Category category})
      : _budgetRepository = budgetRepository,
        super(SubcategoriesState(category: category)) {
    _budgetSubscription = _budgetRepository.budget.listen((budget) {
      _onBudgetChanged(budget);
    });
  }

  Future<void> onInit({required Category category}) async {
    emit(state.copyWith(
      status: SubcategoriesStatus.success,
      category: category, subcategories: category.subcategoryList
    ));
  }

  void _onBudgetChanged(Budget budget) {
    emit(state.copyWith(
        subcategories: _budgetRepository
            .getCategoryById(state.category!.id)
            .subcategoryList));
  }

  void onNameChanged(String name) {
    emit(state.copyWith(name: name));
  }

  void onNewSubcategory() {
    emit(state.resetSubcategory());
  }

  void onSubcategoryEdit(Subcategory subcategory) {
    emit(state.copyWith(editSubcategory: subcategory));
  }

  Future<void> onSubmit() async {

    if (state.editSubcategory == null) {
      final subcategory = Subcategory(
        id: Uuid().v4(),
        name: state.name!,
      );
      _budgetRepository.createSubcategory(state.category!, subcategory);
    } else {
      final subcategory = state.editSubcategory!.copyWith(name: state.name);
      _budgetRepository.updateSubcategory(state.category!, subcategory);
    }
  }

  Future<void> onSubcategoryDeleted(Subcategory subcategory) async {
    emit(state.copyWith(status: SubcategoriesStatus.loading));
    try {
      //await _subcategoriesRepository.delete(subcategory: subcategory);
    } catch (e) {
      emit(state.copyWith(
          status: SubcategoriesStatus.failure, errorMessage: 'Unknown error'));
    }
  }

  @override
  Future<void> close() {
    _budgetSubscription.cancel();
    return super.close();
  }
}
