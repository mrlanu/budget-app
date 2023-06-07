import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budget_app/shared/models/budget.dart';
import 'package:budget_app/shared/models/summary_by.dart';
import 'package:equatable/equatable.dart';

import '../../shared/repositories/shared_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final SharedRepository _sharedRepository;
  final String budgetId;

  HomeCubit(
      {required SharedRepository sharedRepository, required this.budgetId})
      : this._sharedRepository = sharedRepository,
        super(HomeState(selectedDate: DateTime.now()));

  Future<void> init() async {
    emit(state.copyWith(status: HomeStatus.loading));
    final data = await _fetchHomePageData();
    emit(state.copyWith(status: HomeStatus.success,
      sectionSummary: data['sections'],
      summaryList: data['summaryList'],));
  }

  Future<void> setTab(int tabIndex) async {
    emit(state.copyWith(status: HomeStatus.loading));
    final data = await _fetchHomePageData(section: HomeTab.values[tabIndex].name);
    emit(state.copyWith(
        status: HomeStatus.success,
        sectionSummary: data['sections'],
        summaryList: data['summaryList'],
        tab: HomeTab.values[tabIndex]));
  }

  Future<void> changeDate(DateTime dateTime) async {
    emit(state.copyWith(status: HomeStatus.loading));
    final data = await _fetchHomePageData(dateTime: dateTime);
    emit(state.copyWith(
        status: HomeStatus.success,
        sectionSummary: data['sections'],
        summaryList: data['summaryList'],
        selectedDate: dateTime));
  }

  Future<Map<String, dynamic>> _fetchHomePageData(
      {DateTime? dateTime, String? section}) async {
    try {
      final sections =
          await _fetchAllSections(budgetId, dateTime ?? state.selectedDate!);
      final summaryList = await _fetchSummaryList(
          budgetId: budgetId,
          section: section ?? state.tab.name,
          dateTime: dateTime ?? state.selectedDate!);
      return {'sections': sections, 'summaryList': summaryList};
    } catch (e) {
      emit(state.copyWith(
          status: HomeStatus.failure, errorMessage: e.toString()));
      return {};
    }
  }

  Future<Map<String, double>> _fetchAllSections(
      String budgetId, DateTime dateTime) async {
    return await _sharedRepository.fetchAllSections(budgetId, dateTime);
  }

  Future<List<SummaryBy>> _fetchSummaryList(
      {required String budgetId,
      required String section,
      required DateTime dateTime}) async {
    return await _sharedRepository.fetchSummaryList(
        budgetId: budgetId, section: section, dateTime: dateTime);
  }
}
