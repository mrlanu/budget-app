import 'package:budget_app/categories/repository/category_repository.dart';
import 'package:budget_app/charts/cubit/chart_cubit.dart';
import 'package:budget_app/charts/repository/chart_repository.dart';
import 'package:budget_app/constants/constants.dart';
import 'package:chart/chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../charts.dart';

class TrendChartPage extends StatelessWidget {
  TrendChartPage({super.key,});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChartCubit(
          chartRepository: context.read<ChartRepository>(),
          categoryRepository: context.read<CategoryRepository>())
        ..fetchTrendChart(),
      child: Scaffold(
        appBar: AppBar(title: Text('Trend for last 12 months')),
        body: BlocBuilder<ChartCubit, ChartState>(
          builder: (context, state) {
            return Center(
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
                                    dataPoints: state.dataPointsGrouped,
                                    labels: state.titles,
                                    isGrouped: true,
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          //Divider(color: BudgetColors.teal900, indent: 20, endIndent: 20,),
                          Expanded(child: TrendTable())
                        ],
                      ));
          },
        ),
      ),
    );
  }
}

class TrendChartDesktopView extends StatelessWidget {
  const TrendChartDesktopView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ChartCubit(
            chartRepository: context.read<ChartRepository>(),
            categoryRepository: context.read<CategoryRepository>())
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
