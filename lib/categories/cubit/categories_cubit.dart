import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budget_app/transaction/repository/transactions_repository.dart';
import 'package:equatable/equatable.dart';

import '../../transaction/models/transaction_type.dart';
import '../models/category.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  late final TransactionsRepository _transactionsRepository;
  late final StreamSubscription<List<Category>> _categoriesSubscription;

  CategoriesCubit(
      {required TransactionsRepository transactionsRepository,
      required TransactionType transactionType})
      : _transactionsRepository = transactionsRepository,
        super(CategoriesState(transactionType: transactionType)) {
    _categoriesSubscription =
        _transactionsRepository.categories.listen((categories) {
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
      //await _categoriesRepository.deleteCategory(category: category);
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
