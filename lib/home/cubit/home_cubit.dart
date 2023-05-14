import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../categories/models/category_summary.dart';
import '../../shared/repositories/shared_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final SharedRepository _sharedRepository;

  HomeCubit(SharedRepository sharedRepository)
      : this._sharedRepository = sharedRepository,
        super(HomeState(selectedDate: DateTime.now()));

  void setTab(int tabIndex) =>
      emit(state.copyWith(tab: HomeTab.values[tabIndex]));

  void setDate(DateTime dateTime) =>
      emit(state.copyWith(selectedDate: dateTime));

  Future<void> init() async {
    try {
      emit(state.copyWith(status: HomeStatus.loading));
      //Budget will be stored in sharedRepository
      await fetchBudget();
      await fetchAllSections();
      await fetchAllCategories(HomeTab.expenses.name);
      emit(state.copyWith(status: HomeStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: HomeStatus.failure,
          errorMessage: 'Fetching budget error. ${e.toString()}'));
    }
  }


  Future<void> fetchBudget() async {
    try {
      emit(state.copyWith(status: HomeStatus.loading));
      await _sharedRepository.fetchBudget();
      await fetchAllSections();
      emit(state.copyWith(status: HomeStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: HomeStatus.failure,
          errorMessage: 'Fetching budget error. ${e.toString()}'));
    }
  }

  Future<void> fetchAllSections() async {
    try {
      emit(state.copyWith(status: HomeStatus.loading));
      final sections = await _sharedRepository.fetchAllSections();
      emit(
          state.copyWith(status: HomeStatus.success, sectionSummary: sections));
    } catch (e) {
      emit(state.copyWith(
          status: HomeStatus.failure,
          errorMessage: 'Fetching sections error. ${e.toString()}'));
    }
  }

  Future<void> fetchAllCategories(String section) async {
    try {
      emit(state.copyWith(status: HomeStatus.loading));
      final categories =
          await _sharedRepository.fetchSummaryByCategory(section);
      emit(state.copyWith(
          status: HomeStatus.success, categorySummaryList: categories));
    } catch (e) {
      emit(state.copyWith(
          status: HomeStatus.failure,
          errorMessage: 'Fetching categories error. ${e.toString()}'));
    }
  }
}
