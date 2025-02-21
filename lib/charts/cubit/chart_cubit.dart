import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:budget_app/categories/repository/category_repository.dart';
import 'package:budget_app/charts/models/year_month_sum.dart';
import 'package:budget_app/charts/repository/chart_repository.dart';
import 'package:equatable/equatable.dart';

import '../../database/database.dart';
import '../../transaction/models/transaction_type.dart';

part 'chart_state.dart';

class ChartCubit extends Cubit<ChartState> {
  final ChartRepository _chartRepository;
  final CategoryRepository _categoryRepository;

  ChartCubit({required ChartRepository chartRepository,
    required CategoryRepository categoryRepository})
      : _chartRepository = chartRepository,
        _categoryRepository = categoryRepository,
        super(ChartState());

  Future<void> changeCategory({required Category category}) async {
    final subcategories =
    await _categoryRepository.fetchSubcategoriesByCategoryId(category.id);
    emit(state.copyWith(
      category: category,
      subcategories: subcategories,
      subcategory: () => null,
    ));
    fetchCategoryChart(category);
  }

  Future<void> fetchTrendChart() async {
    emit(state.copyWith(status: ChartStatus.loading));
    final chartData = await _chartRepository.fetchTrendChartData();
    emit(state.copyWith(status: ChartStatus.success, data: chartData));
  }

  Future<void> fetchCategoryChart([Category? category]) async {
    final categories = await _categoryRepository.getAllCategories();
    final filteredCategories = categories
        .where((cat) =>
    cat.type ==
        (state.categoryType == 'Expenses'
            ? TransactionType.EXPENSE
            : TransactionType.INCOME))
        .toList();
    final subcategories = await _categoryRepository
        .fetchSubcategoriesByCategoryId(
      category != null ? category.id : filteredCategories[0].id,);
    final chartData = await _chartRepository
        .fetchCategoryChartData(category?.id ?? filteredCategories[0].id);
    emit(state.copyWith(
      status: ChartStatus.success,
      data: chartData,
      categories: filteredCategories,
      category: category != null ? category : filteredCategories[0],
      subcategories: subcategories,
      subcategory: () => null,
    ));
  }

  Future<void> fetchSubcategoryChart(Subcategory subcategory) async {
    final chartData =
    await _chartRepository.fetchSubcategoryChartData(subcategory.id);
    emit(state.copyWith(
        status: ChartStatus.success,
        data: chartData,
        subcategory: () => subcategory));
  }

  void changeCategoryType({required String categoryType}) {
    emit(state.copyWith(categoryType: categoryType));
    fetchCategoryChart();
  }
}
