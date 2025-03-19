import 'package:budget_app/categories/repository/category_repository.dart';
import 'package:budget_app/charts/cubit/chart_cubit.dart';
import 'package:budget_app/charts/repository/chart_repository.dart';
import 'package:chart/chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../charts.dart';

class TrendChartPage extends StatelessWidget {
  TrendChartPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChartCubit(
          chartRepository: context.read<ChartRepository>(),
          categoryRepository: context.read<CategoryRepository>())
        ..fetchTrendChart(),
      child: Scaffold(
        appBar: AppBar(
            title: Text('Trend for last 12 months',
                style: TextStyle(fontSize: 32.sp))),
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
