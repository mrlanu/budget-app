import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../categories/models/category_summary.dart';
import '../../shared/repositories/shared_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {

  final SharedRepository _sharedRepository;

  HomeCubit(SharedRepository sharedRepository) :
  this._sharedRepository = sharedRepository,
  super(HomeState());

  void setTab(int tabIndex) => emit(state.copyWith(tab: HomeTab.values[tabIndex]));

  void setDate(DateTime dateTime) => emit(state.copyWith(selectedDate: dateTime));

  Future<void> fetchAllSections() async {
    try {
      final sections = await _sharedRepository.fetchAllSections();
      _sharedRepository.fetchBudget();
      emit(state.copyWith(
          status: HomeStatus.success, sectionSummary: sections));
    } catch (e) {
      emit(
          state.copyWith(status: HomeStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> fetchAllCategories(String section) async {
    try {
      emit(state.copyWith(status: HomeStatus.loading));
      final categories = await _sharedRepository.fetchSummaryByCategory(section);
      emit(state.copyWith(
          status: HomeStatus.success, categorySummaryList: categories));
    } catch (e) {
      emit(
          state.copyWith(status: HomeStatus.failure, errorMessage: e.toString()));
    }
  }
}
