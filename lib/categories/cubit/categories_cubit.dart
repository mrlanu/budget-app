import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budget_app/colors.dart';
import 'package:budget_app/constants/api.dart';
import 'package:budget_app/transactions/models/transaction_type.dart';
import 'package:equatable/equatable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
        super(CategoriesState(transactionType: transactionType)) {
    _categoriesSubscription =
        _categoriesRepository.getCategories().listen((categories) {
      _onCategoriesChanged(categories);
    });
  }

  void _onCategoriesChanged(List<Category> categories) {
    final catByType = categories
        .where((element) => element.transactionType == state.transactionType)
        .toList();
    emit(state.copyWith(
        status: CategoriesStatus.success, categories: catByType));
  }

  void onNameChanged(String name) {
    emit(state.copyWith(name: name));
  }

  void onIconCodeChanged(int code) {
    print('Family: ${FontAwesomeIcons.code.fontFamily}');
    print('CODE: ${FontAwesomeIcons.code.codePoint}');
    emit(state.copyWith(iconCode: code));
  }

  void onNewCategory() {
    emit(state.resetCategory());
  }

  void onCategoryEdit(Category category) {
    emit(state.copyWith(
        editCategory: category,
        name: category.name,
        iconCode: category.iconCode));
  }

  Future<void> onSubmit() async {
    var category;
    if (state.editCategory == null) {
      category = Category(
          name: state.name!,
          iconCode: state.iconCode,
          budgetId: await getBudgetId(),
          transactionType: state.transactionType);
    } else {
      category = state.editCategory!
          .copyWith(name: state.name, iconCode: state.iconCode);
    }
    _categoriesRepository.saveCategory(category: category);
    emit(state.copyWith(status: CategoriesStatus.loading));
  }

  Future<void> onCategoryDeleted(Category category) async {
    emit(state.copyWith(status: CategoriesStatus.loading));
    try {
      await _categoriesRepository.deleteCategory(category: category);
    } on CategoryFailure catch (e) {
      emit(state.copyWith(
          status: CategoriesStatus.failure, errorMessage: e.message));
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
