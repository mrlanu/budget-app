import 'package:bloc/bloc.dart';
import 'package:budget_app/shared/models/budget.dart';
import 'package:equatable/equatable.dart';

import '../../shared/models/category_summary.dart';
import '../../shared/models/section.dart';
import '../../shared/models/section_category_summary.dart';
import '../../shared/repositories/shared_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final SharedRepository _sharedRepository;

  HomeCubit(SharedRepository sharedRepository)
      : this._sharedRepository = sharedRepository,
        super(HomeState(selectedDate: DateTime.now()));

  Future<void> init() async {
    try {
      emit(state.copyWith(status: HomeStatus.loading));
      final budget = await fetchBudget();
      await fetchSectionCategorySummary(
          budgetId: budget.id,
          section: Section.EXPENSES.name,
          dateTime: DateTime.now());
      emit(state.copyWith(
        status: HomeStatus.success,
        budget: budget,
      ));
    } catch (e) {
      emit(state.copyWith(
          status: HomeStatus.failure,
          errorMessage: 'Fetching budget error. ${e.toString()}'));
    }
  }

  void setTab(int tabIndex) {
    emit(state.copyWith(tab: HomeTab.values[tabIndex]));
    fetchSectionCategorySummary(
        budgetId: state.budget!.id,
        section: state.tab.name,
        dateTime: state.selectedDate ?? DateTime.now());
  }

  void dateChanged(DateTime dateTime) {
    fetchSectionCategorySummary(
        budgetId: state.budget!.id,
        section: state.tab.name,
        dateTime: dateTime);
  }

  Future<Budget> fetchBudget() async {
    return await _sharedRepository.fetchBudget();
  }

  Future<void> fetchSectionCategorySummary(
      {required String budgetId,
      required String section,
      required DateTime dateTime}) async {
    try {
      emit(state.copyWith(status: HomeStatus.loading));
      final result = await _sharedRepository.fetchSectionCategorySummary(
          budgetId, section, dateTime);
      emit(state.copyWith(
          status: HomeStatus.success, sectionCategorySummary: result, selectedDate: dateTime));
    } catch (e) {
      emit(state.copyWith(
          status: HomeStatus.failure, errorMessage: e.toString()));
    }
  }
}
