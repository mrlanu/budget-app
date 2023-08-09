import 'package:budget_app/charts/cubit/chart_cubit.dart';
import 'package:budget_app/charts/repository/chart_repository.dart';
import 'package:budget_app/colors.dart';
import 'package:budget_app/constants/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../charts.dart';

class ChartPage extends StatelessWidget {
  const ChartPage({super.key});

  static Route<void> route() {
    final _repo = ChartRepositoryImpl();
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => ChartCubit(chartRepository: _repo)..fetchChart(),
        child: ChartPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Trend for last 12 months')),
      body: BlocBuilder<ChartCubit, ChartState>(
        builder: (context, state) {
          return Center(
              child: state.status == ChartStatus.loading
                  ? CircularProgressIndicator()
                  : Column(
                      children: [
                        TrendChart(),
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
    final _repo = ChartRepositoryImpl();
    return BlocProvider(
        create: (context) => ChartCubit(chartRepository: _repo)..fetchChart(),
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
                      Container(
                          width: w * 0.35,
                          height: h * 0.6,
                          child: TrendChart()),
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

class TrendChart extends StatelessWidget {
  TrendChart({super.key});

  final Color leftBarColor = BudgetColors.teal600;
  final Color rightBarColor = BudgetColors.red800;
  final double width = 10;

  @override
  Widget build(BuildContext context) {
    final chartCubit = context.read<ChartCubit>();
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocBuilder<ChartCubit, ChartState>(
          builder: (context, state) {
            final showingBarGroups = _buildBarChartGroups(
                data: state.data, touchedIndex: state.touchedIndex);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: BarChart(
                    BarChartData(
                      maxY: state.maxValue,
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          fitInsideHorizontally: true,
                          fitInsideVertically: true,
                          tooltipBgColor: Colors.lightBlueAccent,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                                '${group.barRods[0].toY.toStringAsFixed(2)} / ${group.barRods[1].toY.toStringAsFixed(2)}',
                                TextStyle(color: Colors.black));
                          },
                        ),
                        touchCallback: (FlTouchEvent event, response) {
                          if (!event.isInterestedForInteractions ||
                              response == null ||
                              response.spot == null) {
                            chartCubit.changeTouchedIndex(-1);
                            return;
                          }
                          chartCubit.changeTouchedIndex(
                              response.spot!.touchedBarGroupIndex);
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final titles = state.titles;
                              final Widget text = Text(
                                titles[value.toInt()],
                                style: const TextStyle(
                                  color: Color(0xff7589a2),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              );

                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                angle: 0,
                                space: 16, //margin top
                                child: text,
                              );
                            },
                            reservedSize: 42,
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: state.maxValue > 10000 ? 35 : 30,
                            interval: 1,
                            getTitlesWidget: (value, meta) =>
                                _getLeftTitlesWidget(value, meta, state),
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      barGroups: showingBarGroups,
                      gridData: const FlGridData(show: true),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _getLeftTitlesWidget(double value, TitleMeta meta, ChartState state) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 0) {
      text = '0';
    } else if (value == (state.maxValue / 4).round()) {
      text = '${(state.maxValue / 4 / 1000).toStringAsFixed(1)}K';
    } else if (value == (state.maxValue / 2).round()) {
      text = '${(state.maxValue / 2 / 1000).toStringAsFixed(1)}K';
    } else if (value == (state.maxValue / 4 * 3).round()) {
      text = '${(state.maxValue / 4 * 3 / 1000).toStringAsFixed(1)}K';
    } else if (value == state.maxValue) {
      text = '${(state.maxValue / 1000).toStringAsFixed(1)}K';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  List<BarChartGroupData> _buildBarChartGroups(
      {required List<YearMonthSum> data, required int touchedIndex}) {
    return data
        .asMap()
        .entries
        .map((entry) => _makeGroupData(entry.key, entry.value.incomeSum,
            entry.value.expenseSum, touchedIndex))
        .toList();
  }

  BarChartGroupData _makeGroupData(
      int x, double y1, double y2, int touchedIndex) {
    final isTouched = touchedIndex == x;
    return BarChartGroupData(
      showingTooltipIndicators: isTouched ? [0] : [],
      barsSpace: 1,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: leftBarColor,
          width: width,
        ),
        BarChartRodData(
          toY: y2,
          color: rightBarColor,
          width: width,
        ),
      ],
    );
  }
}
