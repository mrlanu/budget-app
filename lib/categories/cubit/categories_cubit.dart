import 'package:bloc/bloc.dart';
import 'package:budget_app/categories/models/category_summary.dart';
import 'package:budget_app/shared/repositories/shared_repository.dart';
import 'package:equatable/equatable.dart';

import '../../shared/shared.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {

  final SharedRepository _sharedRepository;

  CategoriesCubit(SharedRepository sharedRepository) :
        this._sharedRepository = sharedRepository,
        super(CategoriesState());

  Future<void> fetchAllCategories(String section) async {
    try {
      final categories = await _sharedRepository.fetchSummaryByCategory(section);
      emit(state.copyWith(
          status: DataStatus.success, categorySummaryList: categories));
    } catch (e) {
      emit(
          state.copyWith(status: DataStatus.error, errorMessage: e.toString()));
    }
  }

}
