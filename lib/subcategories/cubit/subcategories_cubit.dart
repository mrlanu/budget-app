import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budget_app/constants/api.dart';
import 'package:equatable/equatable.dart';

import '../../categories/models/category.dart';
import '../../categories/repository/categories_repository.dart';
import '../../shared/models/subcategory.dart';
import '../repository/subcategories_repository.dart';

part 'subcategories_state.dart';

class SubcategoriesCubit extends Cubit<SubcategoriesState> {
  final SubcategoriesRepository _subcategoriesRepository;
  late final StreamSubscription<List<Subcategory>> _subcategoriesSubscription;

  SubcategoriesCubit(
      {required SubcategoriesRepository subcategoriesRepository,
      required Category category})
      : _subcategoriesRepository = subcategoriesRepository,
        super(SubcategoriesState(category: category)) {
    _subcategoriesSubscription =
        _subcategoriesRepository.getSubcategories().listen((subcategories) {
      _onSubcategoriesChanged(subcategories);
    });
  }

  Future<void> onInit({required Category category}) async {
    final subcategories =
        await _subcategoriesRepository.getSubcategories().first;
    final filteredSubcategories =
        subcategories.where((sC) => sC.categoryId == category.id).toList();
    emit(state.copyWith(
        status: SubcategoriesStatus.success,
        category: category,
        subcategories: filteredSubcategories));
  }

  void _onSubcategoriesChanged(List<Subcategory> subcategories) {
    final filteredSubcategories = subcategories
        .where((sC) => sC.categoryId == state.category!.id)
        .toList();
    emit(state.copyWith(subcategories: filteredSubcategories));
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
    var subcategory;
    if (state.editSubcategory == null) {
      subcategory = Subcategory(
          name: state.name!,
          categoryId: state.category!.id!,
          budgetId: await getBudgetId());
    } else {
      subcategory = state.editSubcategory!.copyWith(name: state.name);
    }
    _subcategoriesRepository.saveSubcategory(subcategory: subcategory);
  }

  Future<void> onSubcategoryDeleted(Subcategory subcategory) async {
    emit(state.copyWith(status: SubcategoriesStatus.loading));
    try {
      await _subcategoriesRepository.delete(subcategory: subcategory);
    } on CategoryFailure catch (e) {
      emit(state.copyWith(
          status: SubcategoriesStatus.failure, errorMessage: e.message));
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
