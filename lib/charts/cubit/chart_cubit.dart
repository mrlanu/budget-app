import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:budget_app/app/repository/budget_repository.dart';
import 'package:budget_app/charts/models/year_month_sum.dart';
import 'package:budget_app/charts/repository/chart_repository.dart';
import 'package:equatable/equatable.dart';

import '../../budgets/models/category.dart';

part 'chart_state.dart';

class ChartCubit extends Cubit<ChartState> {
  final ChartRepository _chartRepository;
  late final BudgetRepository _budgetRepository;

  ChartCubit(
      {required ChartRepository chartRepository,
      required BudgetRepository budgetRepository})
      : _chartRepository = chartRepository,
        _budgetRepository = budgetRepository,
        super(ChartState());

  Future<void> changeCategory({required Category category}) async {
    fetchCategoryChart(category);
  }

  Future<void> fetchTrendChart() async {
    emit(state.copyWith(status: ChartStatus.loading));
    final chartData = await _chartRepository.fetchTrendChartData();
    emit(state.copyWith(status: ChartStatus.success, data: chartData));
  }

  Future<void> fetchCategoryChart([Category? category]) async {
    /*final categories = await _categoriesRepository.getCategories().first;
    final filteredCategories = categories
        .where((element) =>
            element.transactionType ==
            (state.categoryType == 'Expenses'
                ? TransactionType.EXPENSE
                : TransactionType.INCOME))
        .toList();
    final chartData = await _chartRepository
        .fetchCategoryChartData(category?.id ?? filteredCategories[0].id!);
    emit(state.copyWith(
        status: ChartStatus.success,
        data: chartData,
        categories: filteredCategories,
        category: category != null ? category : filteredCategories[0]));*/
  }

  void changeCategoryType({required String categoryType}) {
    emit(state.copyWith(categoryType: categoryType));
    fetchCategoryChart();
  }
}
