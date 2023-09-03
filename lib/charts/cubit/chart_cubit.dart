import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:budget_app/categories/models/category.dart';
import 'package:budget_app/categories/repository/categories_repository.dart';
import 'package:budget_app/charts/models/year_month_sum.dart';
import 'package:budget_app/charts/repository/chart_repository.dart';
import 'package:budget_app/transactions/models/transaction_type.dart';
import 'package:equatable/equatable.dart';

part 'chart_state.dart';

class ChartCubit extends Cubit<ChartState> {
  final CategoriesRepository _categoriesRepository;
  final ChartRepository _chartRepository;

  ChartCubit(
      {required ChartRepository chartRepository,
      required CategoriesRepository categoriesRepository})
      : _chartRepository = chartRepository,
        _categoriesRepository = categoriesRepository,
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
    final categories = await _categoriesRepository.getCategories().first;
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
        category: category != null ? category : filteredCategories[0]));
  }

  void changeCategoryType({required String categoryType}) {
    emit(state.copyWith(categoryType: categoryType));
    fetchCategoryChart();
  }
}
