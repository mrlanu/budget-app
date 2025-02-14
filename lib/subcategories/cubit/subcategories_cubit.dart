import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budget_app/categories/repository/category_repository.dart';
import 'package:budget_app/database/database.dart';
import 'package:equatable/equatable.dart';

part 'subcategories_state.dart';

class SubcategoriesCubit extends Cubit<SubcategoriesState> {
  final CategoryRepository _categoryRepository;
  late final StreamSubscription<List<Subcategory>> _subcategoriesSubscription;

  SubcategoriesCubit(
      {required CategoryRepository categoryRepository, required Category category})
      : _categoryRepository = categoryRepository,
        super(SubcategoriesState(category: category)) {
    _subcategoriesSubscription = _categoryRepository.subcategories.listen((subcategories) {
      _onSubcategoriesChanged(subcategories);
    });
  }

  Future<void> onInit({required Category category}) async {
    emit(state.copyWith(
      status: SubcategoriesStatus.success,
      category: category, subcategories: []
    ));
  }

  void _onSubcategoriesChanged(List<Subcategory> subcategories) {
    emit(state.copyWith(
        subcategories: subcategories));
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
