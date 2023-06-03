import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budget_app/transactions/models/transaction_type.dart';
import 'package:equatable/equatable.dart';

import '../models/category.dart';
import '../repository/categories_repository.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final CategoriesRepository _categoriesRepository;
  late final StreamSubscription<List<Category>> _categoriesSubscription;

  CategoriesCubit(
      {required CategoriesRepository categoriesRepository,
      required TransactionType transactionType})
      : _categoriesRepository = categoriesRepository,
        super(CategoriesState(transactionType: transactionType)){
    _categoriesSubscription =
        _categoriesRepository.getCategories().listen((categories) {
          _onCategoriesChanged(categories);
        });
  }

  Future<void> onInit({required String budgetId}) async {
    final categories = await _categoriesRepository.fetchCategories(
        budgetId: budgetId, transactionType: state.transactionType);
    emit(state.copyWith(
        status: CategoriesStatus.success, categories: categories));
  }

  void _onCategoriesChanged(List<Category> categories){
    emit(state.copyWith(categories: categories));
  }

  void onNameChanged(String name) {
    emit(state.copyWith(name: name));
  }

  void onNewCategory() {
    emit(state.resetCategory());
  }

  void onCategoryEdit(Category category) {
    emit(state.copyWith(editCategory: category));
  }

  void onSubmit(String budgetId) {
    var category;
    if (state.editCategory == null) {
      category = Category(name: state.name!, budgetId: budgetId, transactionType: state.transactionType);
    } else {
      category = state.editCategory!.copyWith(name: state.name);
    }
    _categoriesRepository.saveCategory(category: category);
  }

  void onCategoryDeleted(Category category){
    _categoriesRepository.deleteCategory(category: category);
  }

  @override
  Future<void> close() {
    _categoriesSubscription.cancel();
    return super.close();
  }
}
