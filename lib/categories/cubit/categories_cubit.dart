import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budget_app/transaction/repository/budget_repository.dart';
import 'package:equatable/equatable.dart';

import '../../transaction/models/transaction_type.dart';
import '../models/category.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  late final BudgetRepository _budgetRepository;
  late final StreamSubscription<List<Category>> _categoriesSubscription;

  CategoriesCubit(
      {required BudgetRepository budgetRepository,
      required TransactionType transactionType})
      : _budgetRepository = budgetRepository,
        super(CategoriesState(transactionType: transactionType)) {
    _categoriesSubscription =
        _budgetRepository.categories.listen((categories) {
      _onCategoriesChanged(categories);
    });
  }

  void _onCategoriesChanged(List<Category> categories) {
    emit(state.copyWith(
        status: CategoriesStatus.success,
        categories:
            categories.where((c) => c.type == state.transactionType).toList()));
  }

  Future<void> onCategoryDeleted(Category category) async {
    emit(state.copyWith(status: CategoriesStatus.loading));
    try {
      //await _bu.deleteCategory(category: category);
    } catch (e) {
      emit(state.copyWith(
          status: CategoriesStatus.failure, errorMessage: 'Unknown error'));
    }
  }

  @override
  Future<void> close() {
    _categoriesSubscription.cancel();
    return super.close();
  }
}
