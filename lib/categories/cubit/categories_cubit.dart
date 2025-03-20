import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:qruto_budget/categories/repository/category_repository.dart';
import 'package:qruto_budget/database/database.dart';
import 'package:equatable/equatable.dart';

import '../../transaction/models/transaction_type.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  late final CategoryRepository _categoryRepository;
  late final StreamSubscription<List<Category>> _categoriesSubscription;

  CategoriesCubit(
      {required CategoryRepository categoryRepository,
      required TransactionType transactionType})
      : _categoryRepository = categoryRepository,
        super(CategoriesState(transactionType: transactionType)) {
    _categoriesSubscription =
        _categoryRepository.categories.listen((categories) {
      _onCategoriesChanged(categories);
    });
  }

  void _onCategoriesChanged(List<Category> categories) {
    emit(state.copyWith(
        status: CategoriesStatus.success, categories: categories));
  }

  Future<void> onCategoryDeleted(Category category) async {
    emit(state.copyWith(status: CategoriesStatus.loading));
    try {
      await _categoryRepository.deleteCategory(category.id);
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
