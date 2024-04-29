import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budget_app/transaction/repository/transactions_repository.dart';
import 'package:equatable/equatable.dart';

import '../../categories/models/category.dart';
import '../models/subcategory.dart';

part 'subcategories_state.dart';

class SubcategoriesCubit extends Cubit<SubcategoriesState> {
  final TransactionsRepository _transactionsRepository;
  late final StreamSubscription<List<Subcategory>> _subcategoriesSubscription;

  SubcategoriesCubit(
      {required TransactionsRepository transactionsRepository, required Category category})
      : _transactionsRepository = transactionsRepository,
        super(SubcategoriesState(category: category)) {
    _subcategoriesSubscription = _transactionsRepository.subcategories.listen((subcategories) {
      _onSubcategoriesChanged(subcategories);
    });
  }

  Future<void> onInit({required Category category}) async {
    emit(state.copyWith(
      status: SubcategoriesStatus.success,
      category: category, subcategories: category.subcategoryList.toList()
    ));
  }

  void _onSubcategoriesChanged(List<Subcategory> subcategories) {
    emit(state.copyWith(
        subcategories: []));
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
    _subcategoriesSubscription.cancel();
    return super.close();
  }
}
