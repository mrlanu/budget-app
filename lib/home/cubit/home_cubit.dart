import 'package:bloc/bloc.dart';
import 'package:budget_app/shared/models/budget.dart';
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
      final budget = await fetchBudget();
      final sections = await fetchAllSections(budget.id);
      fetchAllCategories(budgetId: budget.id, section: 'EXPENSES');
      emit(state.copyWith(
          status: HomeStatus.success,
          budget: budget,
          sectionSummary: sections));
    } catch (e) {
      emit(state.copyWith(
          status: HomeStatus.failure,
          errorMessage: 'Fetching budget error. ${e.toString()}'));
    }
  }

  Future<Budget> fetchBudget() async {
    return await _sharedRepository.fetchBudget();
  }

  Future<Map<String, double>> fetchAllSections(String budgetId) async {
      return await _sharedRepository.fetchAllSections(budgetId);
  }

  Future<void> fetchAllCategories(
      {required String budgetId, required String section}) async {
    try {
      emit(state.copyWith(status: HomeStatus.loading));
      final categories = await _sharedRepository.fetchSummaryByCategory(
          budgetId: budgetId, section: section);
      emit(state.copyWith(
          status: HomeStatus.success, categorySummaryList: categories));
    } catch (e) {
      emit(state.copyWith(
          status: HomeStatus.failure, errorMessage: e.toString()));
    }
  }
}
