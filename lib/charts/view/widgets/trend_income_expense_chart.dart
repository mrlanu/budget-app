import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qruto_budget/charts/models/year_month_sum.dart';

import 'package:chart/chart.dart' as budget_chart;

double _niceMaxYAxis(double raw) {
  if (raw <= 0) return 100;
  final headroom = raw * 1.12;
  final exp = (math.log(headroom) / math.ln10).floor();
  final pow10 = math.pow(10.0, exp).toDouble();
  final frac = headroom / pow10;
  double nice;
  if (frac <= 1) {
    nice = 1;
  } else if (frac <= 2) {
    nice = 2;
  } else if (frac <= 5) {
    nice = 5;
  } else {
    nice = 10;
  }
  return nice * pow10;
}

/// Line + area (income vs expenses) or grouped bars, similar to modern finance dashboards.
class TrendIncomeExpenseChart extends StatefulWidget {
  const TrendIncomeExpenseChart({
    super.key,
    required this.monthlyData,
  });

  final List<YearMonthSum> monthlyData;

  @override
  State<TrendIncomeExpenseChart> createState() => _TrendIncomeExpenseChartState();
}

enum _TrendViz { line, bar }

class _TrendIncomeExpenseChartState extends State<TrendIncomeExpenseChart> {
  _TrendViz _mode = _TrendViz.line;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final data = widget.monthlyData;
    if (data.isEmpty) {
      return const Center(child: Text('No data'));
    }

    final incomeColor = const Color(0xFF4ECDC4);
    final expenseColor = const Color(0xFFFF7A6A);
    final panelBg = isDark
        ? const Color(0xFF1A2230)
        : scheme.surfaceContainerHighest.withValues(alpha: 0.55);
    final muted = isDark
        ? Colors.white.withValues(alpha: 0.55)
        : scheme.onSurface.withValues(alpha: 0.55);
    final gridColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : scheme.outline.withValues(alpha: 0.18);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: panelBg,
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : scheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Income & expense trend',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                        color: isDark ? Colors.white : scheme.onSurface,
                      ),
                ),
              ),
              SegmentedButton<_TrendViz>(
                style: ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return scheme.primary;
                    }
                    return isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : scheme.surfaceContainerHigh;
                  }),
                  foregroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return scheme.onPrimary;
                    }
                    return muted;
                  }),
                ),
                segments: const [
                  ButtonSegment(
                    value: _TrendViz.line,
                    label: Text('Line'),
                    icon: Icon(Icons.show_chart, size: 16),
                  ),
                  ButtonSegment(
                    value: _TrendViz.bar,
                    label: Text('Bars'),
                    icon: Icon(Icons.bar_chart, size: 16),
                  ),
                ],
                selected: {_mode},
                onSelectionChanged: (s) {
                  if (s.isNotEmpty) setState(() => _mode = s.first);
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendDot(color: incomeColor, label: 'Income'),
              const SizedBox(width: 20),
              _LegendDot(color: expenseColor, label: 'Expenses'),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _mode == _TrendViz.line
                ? _LineAreaChart(
                    data: data,
                    incomeColor: incomeColor,
                    expenseColor: expenseColor,
                    gridColor: gridColor,
                    labelColor: muted,
                    isDark: isDark,
                  )
                : budget_chart.BarChart(
                    dataPoints: _groupedDoubles(data),
                    labels: data.map((e) => e.date.month.toString()).toList(),
                    isGrouped: true,
                    firstColor: incomeColor,
                    secondColor: expenseColor,
                  ),
          ),
        ],
      ),
    );
  }

  List<double> _groupedDoubles(List<YearMonthSum> rows) {
    final out = <double>[];
    for (final e in rows) {
      out.add(e.expenseSum);
      out.add(e.incomeSum);
    }
    return out;
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.75);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.45),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withValues(alpha: 0.8)
                    : muted,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}

class _LineAreaChart extends StatelessWidget {
  const _LineAreaChart({
    required this.data,
    required this.incomeColor,
    required this.expenseColor,
    required this.gridColor,
    required this.labelColor,
    required this.isDark,
  });

  final List<YearMonthSum> data;
  final Color incomeColor;
  final Color expenseColor;
  final Color gridColor;
  final Color labelColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final n = data.length;
    final incomeSpots = <FlSpot>[];
    final expenseSpots = <FlSpot>[];
    for (var i = 0; i < n; i++) {
      incomeSpots.add(FlSpot(i.toDouble(), data[i].incomeSum));
      expenseSpots.add(FlSpot(i.toDouble(), data[i].expenseSum));
    }

    final maxYRaw = data
        .map((e) => math.max(e.incomeSum, e.expenseSum))
        .reduce(math.max);
    final maxY = _niceMaxYAxis(maxYRaw);
    final yInterval = maxY / 5;
    final dateFmt = DateFormat('dd.MM');

    final lineIncome = LineChartBarData(
      spots: incomeSpots,
      isCurved: false,
      color: incomeColor,
      barWidth: 2.8,
      isStrokeCapRound: true,
      isStrokeJoinRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
          radius: 4.2,
          color: incomeColor,
          strokeWidth: 2,
          strokeColor: isDark ? const Color(0xFF1A2230) : Colors.white,
        ),
      ),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [
            incomeColor.withValues(alpha: 0.42),
            incomeColor.withValues(alpha: 0.0),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );

    final lineExpense = LineChartBarData(
      spots: expenseSpots,
      isCurved: false,
      color: expenseColor,
      barWidth: 2.8,
      isStrokeCapRound: true,
      isStrokeJoinRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
          radius: 4.2,
          color: expenseColor,
          strokeWidth: 2,
          strokeColor: isDark ? const Color(0xFF1A2230) : Colors.white,
        ),
      ),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [
            expenseColor.withValues(alpha: 0.38),
            expenseColor.withValues(alpha: 0.0),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: n <= 1 ? 1 : (n - 1).toDouble(),
        minY: 0,
        maxY: maxY,
        clipData: const FlClipData.all(),
        backgroundColor: Colors.transparent,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: yInterval,
          getDrawingHorizontalLine: (_) => FlLine(
            color: gridColor,
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false, reservedSize: 0),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false, reservedSize: 0),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: yInterval,
              getTitlesWidget: (value, meta) {
                if (value < 0 || value > maxY * 1.001) {
                  return const SizedBox.shrink();
                }
                return SideTitleWidget(
                  meta: meta,
                  space: 4,
                  child: Text(
                    _formatAxisNumber(value),
                    style: TextStyle(
                      color: labelColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 34,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final i = value.round();
                if (i < 0 || i >= n) return const SizedBox.shrink();
                return SideTitleWidget(
                  meta: meta,
                  space: 2,
                  angle: -math.pi / 4,
                  child: Text(
                    dateFmt.format(data[i].date),
                    style: TextStyle(
                      color: labelColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        lineBarsData: [lineExpense, lineIncome],
        lineTouchData: LineTouchData(
          enabled: true,
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipBorderRadius: BorderRadius.circular(10),
            maxContentWidth: 200,
            getTooltipColor: (_) => isDark
                ? const Color(0xFF2A3142)
                : Colors.white.withValues(alpha: 0.95),
            getTooltipItems: (touched) {
              return touched.map((t) {
                final i = t.x.round().clamp(0, n - 1);
                final isIncome = t.barIndex == 1;
                final v = isIncome ? data[i].incomeSum : data[i].expenseSum;
                final label = isIncome ? 'Income' : 'Expenses';
                return LineTooltipItem(
                  '$label\n${dateFmt.format(data[i].date)}: ${_money(v)}',
                  TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
    );
  }

  static String _formatAxisNumber(double v) {
    if (v >= 1e6) return '${(v / 1e6).toStringAsFixed(1)}M';
    if (v >= 1e3) return '${(v / 1e3).toStringAsFixed(0)}k';
    if (v == v.roundToDouble()) return v.round().toString();
    return v.toStringAsFixed(0);
  }

  static String _money(double v) => '\$${v.toStringAsFixed(0)}';
}
