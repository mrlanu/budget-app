import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budget_app/categories/repository/category_repository.dart';
import 'package:budget_app/database/database.dart';
import 'package:equatable/equatable.dart';

part 'subcategories_state.dart';

class SubcategoriesCubit extends Cubit<SubcategoriesState> {
  final CategoryRepository _categoryRepository;
  late final StreamSubscription<List<Subcategory>> _subcategoriesSubscription;

  SubcategoriesCubit({required CategoryRepository categoryRepository})
      : _categoryRepository = categoryRepository,
        super(SubcategoriesState()) {
    _subcategoriesSubscription =
        _categoryRepository.subcategories.listen((subcategories) {
      _onSubcategoriesChanged(subcategories);
    });
  }

  Future<void> onInit({required int categoryId}) async {
    final category = await _categoryRepository.getCategoryById(categoryId);
    final subcategories =
        await _categoryRepository.fetchSubcategoriesByCategoryId(categoryId);
    emit(state.copyWith(
        status: SubcategoriesStatus.success,
        category: category,
        subcategories: subcategories));
  }

  void _onSubcategoriesChanged(List<Subcategory> subcategories) {
    emit(state.copyWith(subcategories: subcategories));
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

  Future<void> onSubcategoryDeleted(int subcategoryId) async {
    try {
      await _categoryRepository.deleteSubcategory(subcategoryId);
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
