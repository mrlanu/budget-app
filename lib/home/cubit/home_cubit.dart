import 'package:bloc/bloc.dart';
import 'package:budget_app/shared/models/budget.dart';
import 'package:budget_app/shared/models/summary_by.dart';
import 'package:equatable/equatable.dart';

import '../../shared/models/section.dart';
import '../../shared/repositories/shared_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final SharedRepository _sharedRepository;
  final String budgetId;

  HomeCubit({required SharedRepository sharedRepository, required this.budgetId})
      : this._sharedRepository = sharedRepository,
        super(HomeState(selectedDate: DateTime.now()));

  Future<void> init() async {
    try {
      emit(state.copyWith(status: HomeStatus.loading));
      await fetchHomePageData(
          budgetId: budgetId,
          section: Section.EXPENSES.name,
          dateTime: DateTime.now());
      emit(state.copyWith(status: HomeStatus.success,));
    } catch (e) {
      emit(state.copyWith(
          status: HomeStatus.failure,
          errorMessage: 'Fetching budget error. ${e.toString()}'));
    }
  }

  void setTab(int tabIndex) {
    emit(state.copyWith(tab: HomeTab.values[tabIndex]));
    fetchHomePageData(
        budgetId: budgetId,
        section: state.tab.name,
        dateTime: state.selectedDate ?? DateTime.now());
  }

  void dateChanged(DateTime dateTime) {
    fetchHomePageData(
        budgetId: budgetId,
        section: state.tab.name,
        dateTime: dateTime);
  }


  Future<void> fetchHomePageData({required String budgetId,
    required String section,
    required DateTime dateTime}) async {
    try {
      emit(state.copyWith(status: HomeStatus.loading));
      final sections = await _fetchAllSections(budgetId, dateTime);
      final summaryList = await _fetchSummaryList(
          budgetId: budgetId, section: section, dateTime: dateTime);
      emit(state.copyWith(
          status: HomeStatus.success,
          sectionSummary: sections,
          summaryList: summaryList,
          selectedDate: dateTime));
    } catch (e) {
      emit(state.copyWith(
          status: HomeStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<Map<String, double>> _fetchAllSections(String budgetId,
      DateTime dateTime) async {
    return await _sharedRepository.fetchAllSections(budgetId, dateTime);
  }

  Future<List<SummaryBy>> _fetchSummaryList({required String budgetId,
    required String section,
    required DateTime dateTime}) async {
    return await _sharedRepository.fetchSummaryList(
        budgetId: budgetId, section: section, dateTime: dateTime);
  }
}
