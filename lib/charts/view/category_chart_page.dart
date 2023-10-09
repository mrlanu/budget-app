import 'package:budget_app/app/repository/budget_repository.dart';
import 'package:budget_app/charts/cubit/chart_cubit.dart';
import 'package:budget_app/charts/repository/chart_repository.dart';
import 'package:budget_app/charts/view/category_table.dart';
import 'package:budget_app/constants/constants.dart';
import 'package:chart/chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../budgets/models/category.dart';
import '../charts.dart';

class CategoryChartPage extends StatelessWidget {
  const CategoryChartPage({super.key});

  static Route<void> route() {
    final _repo = ChartRepositoryImpl();
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => ChartCubit(
            chartRepository: _repo,
        budgetRepository: context.read<BudgetRepository>())
          ..fetchCategoryChart(),
        child: CategoryChartPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartCubit, ChartState>(
      builder: (context, state) => Scaffold(
          appBar: AppBar(
              title: Text(state.category?.name ?? ''),
              actions: [CategoryTypeSelectButton()]),
          body: Center(
              child: state.status == ChartStatus.loading
                  ? CircularProgressIndicator()
                  : Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 1.3 / 1,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 30, horizontal: 8),
                            child: BlocBuilder<ChartCubit, ChartState>(
                              builder: (context, state) {
                                return BarChart(
                                  dataPoints: state.dataPoints,
                                  labels: state.titles,
                                  isGrouped: false,
                                  firstColor: state.categoryType == 'Expenses'
                                      ? Colors.red
                                      : Colors.green,
                                );
                              },
                            ),
                          ),
                        ),
                        CategoryInput(),
                        Expanded(child: CategoryTable())
                      ],
                    ))),
    );
  }
}

class TrendChartDesktopView extends StatelessWidget {
  const TrendChartDesktopView({super.key});

  @override
  Widget build(BuildContext context) {
    final _repo = ChartRepositoryImpl();
    return BlocProvider(
        create: (context) => ChartCubit(
            chartRepository: _repo,
            budgetRepository: context.read<BudgetRepository>())
          ..fetchTrendChart(),
        child: TrendChartDesktopViewBody());
  }
}

class TrendChartDesktopViewBody extends StatelessWidget {
  const TrendChartDesktopViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartCubit, ChartState>(
      builder: (context, state) {
        return Center(
            child: state.status == ChartStatus.loading
                ? CircularProgressIndicator()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocBuilder<ChartCubit, ChartState>(
                        builder: (context, state) {
                          return Container(
                            width: w * 0.35,
                            height: h * 0.55,
                            child: BarChart(
                              dataPoints: state.dataPointsGrouped,
                              labels: state.titles,
                              isGrouped: true,
                            ),
                          );
                        },
                      ),
                      SizedBox(width: w * 0.01),
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Container(
                            width: w * 0.35,
                            height: h * 0.6,
                            child: TrendTable()),
                      )
                    ],
                  ));
      },
    );
  }
}

class CategoryInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartCubit, ChartState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField<Category>(
              items: state.categories.map((Category category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category.name),
                );
              }).toList(),
              onChanged: (newValue) {
                context.read<ChartCubit>().changeCategory(category: newValue!);
                //setState(() => selectedValue = newValue);
              },
              value: state.categories.contains(state.category)
                  ? state.category
                  : null,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Category',
                //errorText: errorSnapshot.data == 0 ? Localization.of(context).categoryEmpty : null),
              )),
        );
      },
    );
  }
}
