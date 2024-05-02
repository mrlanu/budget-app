import 'package:budget_app/charts/cubit/chart_cubit.dart';
import 'package:budget_app/constants/constants.dart';
import 'package:chart/chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../charts.dart';

class TrendChartPage extends StatefulWidget {
  const TrendChartPage({super.key});

  @override
  State<TrendChartPage> createState() => _TrendChartPageState();
}

class _TrendChartPageState extends State<TrendChartPage> {

  @override
  void initState() {
    super.initState();
    context.read<ChartCubit>().fetchTrendChart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trend for last 12 months'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            context.pop();
          },
        ),
      ),
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
    );
  }
}

class TrendChartDesktopView extends StatelessWidget {
  const TrendChartDesktopView({super.key});

  @override
  Widget build(BuildContext context) {
    return TrendChartDesktopViewBody();
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
