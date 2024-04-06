import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../budgets/budgets.dart';
import '../../budgets/repository/budget_repository.dart';
import '../../categories/models/category.dart';
import '../models/subcategory.dart';

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
        subcategories: budget
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
