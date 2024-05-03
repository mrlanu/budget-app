import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budget_app/transaction/repository/budget_repository.dart';
import 'package:equatable/equatable.dart';

import '../../categories/models/category.dart';
import '../models/subcategory.dart';

part 'subcategories_state.dart';

class SubcategoriesCubit extends Cubit<SubcategoriesState> {
  final BudgetRepository _budgetRepository;
  late final StreamSubscription<Category?> _categorySubscription;

  SubcategoriesCubit(
      {required BudgetRepository budgetRepository,
      required int categoryId})
      : _budgetRepository = budgetRepository,
        super(SubcategoriesState()) {
    _categorySubscription = _budgetRepository
        .watchCategoryById(categoryId)
        .listen((category) {
      _onCategoryChanged(category!);
    });
  }

  void _onCategoryChanged(Category category) {
    emit(state.copyWith(
        category: category, subcategories: category.subcategoryList));
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
    _categorySubscription.cancel();
    return super.close();
  }
}
