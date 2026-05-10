import 'package:qruto_budget/categories/repository/category_repository.dart';
import 'package:qruto_budget/charts/cubit/chart_cubit.dart';
import 'package:qruto_budget/charts/repository/chart_repository.dart';
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
                style: TextStyle(fontSize: 30.sp))),
        body: SafeArea(
          bottom: true,
          child: BlocBuilder<ChartCubit, ChartState>(
            builder: (context, state) {
              return Center(
                  child: state.status == ChartStatus.loading
                      ? CircularProgressIndicator()
                      : Column(
                          children: [
                            AspectRatio(
                              aspectRatio: 1.25 / 1,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 12),
                                child: TrendIncomeExpenseChart(
                                  monthlyData: state.data,
                                ),
                              ),
                            ),
                            IncludeCurrentMonthSwitch(),
                            //Divider(color: BudgetColors.teal900, indent: 20, endIndent: 20,),
                            Expanded(child: TrendTable())
                          ],
                        ));
            },
          ),
        ),
      ),
    );
  }
}
