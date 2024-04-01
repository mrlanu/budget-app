import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budget_app/app/repository/budget_repository.dart';
import 'package:budget_app/budgets/budgets.dart';
import 'package:equatable/equatable.dart';

import '../../transaction/models/transaction_type.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  late final BudgetRepository _budgetRepository;
  late final StreamSubscription<Budget> _budgetSubscription;

  CategoriesCubit(
      {required BudgetRepository budgetRepository,
      required TransactionType transactionType})
      : _budgetRepository = budgetRepository,
        super(CategoriesState(transactionType: transactionType)) {
    _budgetSubscription = _budgetRepository.budget.listen((budget) {
      _onBudgetChanged(budget);
    });
  }

  void _onBudgetChanged(Budget budget) {
    emit(state.copyWith(
        status: CategoriesStatus.success,
        categories:
            _budgetRepository.getCategoriesByType(state.transactionType)));
  }

  Future<void> onCategoryDeleted(Category category) async {
    emit(state.copyWith(status: CategoriesStatus.loading));
    try {
      //await _categoriesRepository.deleteCategory(category: category);
    } catch (e) {
      emit(state.copyWith(
          status: CategoriesStatus.failure, errorMessage: 'Unknown error'));
    }
  }

  @override
  Future<void> close() {
    _budgetSubscription.cancel();
    return super.close();
  }
}
