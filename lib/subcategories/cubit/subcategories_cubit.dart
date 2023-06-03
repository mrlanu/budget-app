import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../categories/models/category.dart';
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

  Future<void> onInit(
      {required String budgetId, required Category category}) async {
    final subcategories = await _subcategoriesRepository.fetchSubcategories(
        budgetId: budgetId, categoryId: category.id!);
    emit(state.copyWith(
        status: SubcategoriesStatus.success, subcategories: subcategories));
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

  void onSubmit(String budgetId) {
    var subcategory;
    if (state.editSubcategory == null) {
      subcategory = Subcategory(
          name: state.name!,
          categoryId: state.category!.id!,
          budgetId: budgetId);
    } else {
      subcategory = state.editSubcategory!.copyWith(name: state.name);
    }
    _subcategoriesRepository.saveSubcategory(
        subcategory: subcategory, budgetId: budgetId);
  }

  void onSubcategoryDeleted(Subcategory subcategory) {
    _subcategoriesRepository.delete(subcategory: subcategory);
  }

  @override
  Future<void> close() {
    _subcategoriesSubscription.cancel();
    return super.close();
  }
}
