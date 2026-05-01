import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qruto_budget/charts/models/net_worth_month_point.dart';

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

double _niceMinYAxis(double raw) {
  if (raw >= 0) return -100;
  return -_niceMaxYAxis(-raw);
}

/// Opening net worth per month — same panel treatment as [TrendIncomeExpenseChart].
class NetWorthChartPanel extends StatefulWidget {
  const NetWorthChartPanel({
    super.key,
    required this.points,
  });

  final List<NetWorthMonthPoint> points;

  @override
  State<NetWorthChartPanel> createState() => _NetWorthChartPanelState();
}

enum _NetWorthViz { line, bar }

class _NetWorthChartPanelState extends State<NetWorthChartPanel> {
  _NetWorthViz _mode = _NetWorthViz.line;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final data = widget.points;
    if (data.isEmpty) {
      return const Center(child: Text('No data'));
    }

    final lineColor = const Color(0xFF4ECDC4);
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
                  'Net worth (month open)',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                        color: isDark ? Colors.white : scheme.onSurface,
                      ),
                ),
              ),
              SegmentedButton<_NetWorthViz>(
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
                    value: _NetWorthViz.line,
                    label: Text('Line'),
                    icon: Icon(Icons.show_chart, size: 16),
                  ),
                  ButtonSegment(
                    value: _NetWorthViz.bar,
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
              _LegendDot(color: lineColor, label: 'Net worth'),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _mode == _NetWorthViz.line
                ? _NetWorthLineChart(
                    data: data,
                    lineColor: lineColor,
                    gridColor: gridColor,
                    labelColor: muted,
                    isDark: isDark,
                  )
                : _NetWorthBarChart(
                    data: data,
                    barColor: lineColor,
                    gridColor: gridColor,
                    labelColor: muted,
                    isDark: isDark,
                  ),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final muted =
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.75);
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

({double minY, double maxY, double interval}) _axisBounds(List<double> ys) {
  final minV = ys.reduce(math.min);
  final maxV = ys.reduce(math.max);
  if ((maxV - minV).abs() < 1e-9) {
    final pad = math.max(1.0, maxV.abs() * 0.12 + 10);
    final minY = maxV - pad;
    final maxY = maxV + pad;
    final interval = (maxY - minY) / 5;
    return (minY: minY, maxY: maxY, interval: interval);
  }
  final crossesZero = minV < 0 && maxV > 0;
  double minY;
  double maxY;
  if (!crossesZero) {
    if (maxV <= 0) {
      maxY = 0;
      minY = _niceMinYAxis(minV);
    } else {
      minY = 0;
      maxY = _niceMaxYAxis(maxV);
    }
  } else {
    minY = _niceMinYAxis(minV);
    maxY = _niceMaxYAxis(maxV);
  }
  var span = maxY - minY;
  if (span < 1e-9) {
    span = 1;
    minY -= 0.5;
    maxY += 0.5;
  }
  final interval = span / 5;
  return (minY: minY, maxY: maxY, interval: interval);
}

class _NetWorthLineChart extends StatelessWidget {
  const _NetWorthLineChart({
    required this.data,
    required this.lineColor,
    required this.gridColor,
    required this.labelColor,
    required this.isDark,
  });

  final List<NetWorthMonthPoint> data;
  final Color lineColor;
  final Color gridColor;
  final Color labelColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final n = data.length;
    final spots = <FlSpot>[
      for (var i = 0; i < n; i++)
        FlSpot(i.toDouble(), data[i].totalBalance),
    ];
    final ys = data.map((e) => e.totalBalance).toList();
    final bounds = _axisBounds(ys);
    final minY = bounds.minY;
    final maxY = bounds.maxY;
    final yInterval = bounds.interval;
    final dateFmt = DateFormat('dd.MM');

    final line = LineChartBarData(
      spots: spots,
      isCurved: false,
      color: lineColor,
      barWidth: 2.8,
      isStrokeCapRound: true,
      isStrokeJoinRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
          radius: 4.2,
          color: lineColor,
          strokeWidth: 2,
          strokeColor: isDark ? const Color(0xFF1A2230) : Colors.white,
        ),
      ),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [
            lineColor.withValues(alpha: 0.42),
            lineColor.withValues(alpha: 0.0),
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
        minY: minY,
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
              reservedSize: 44,
              interval: yInterval,
              getTitlesWidget: (value, meta) {
                if (value < minY - yInterval * 0.01 ||
                    value > maxY + yInterval * 0.01) {
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
                    dateFmt.format(data[i].monthStart),
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
        lineBarsData: [line],
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: 0,
              color: gridColor.withValues(alpha: isDark ? 0.35 : 0.55),
              strokeWidth: 1,
            ),
          ],
        ),
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
                final v = data[i].totalBalance;
                return LineTooltipItem(
                  'Net worth\n${dateFmt.format(data[i].monthStart)}: ${_money(v)}',
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
    final av = v.abs();
    final sign = v < 0 ? '-' : '';
    if (av >= 1e6) return '$sign${(av / 1e6).toStringAsFixed(1)}M';
    if (av >= 1e3) return '$sign${(av / 1e3).toStringAsFixed(0)}k';
    if (v == v.roundToDouble()) return '$sign${av.round()}';
    return '$sign${av.toStringAsFixed(0)}';
  }

  static String _money(double v) => '\$${v.toStringAsFixed(2)}';
}

class _NetWorthBarChart extends StatelessWidget {
  const _NetWorthBarChart({
    required this.data,
    required this.barColor,
    required this.gridColor,
    required this.labelColor,
    required this.isDark,
  });

  final List<NetWorthMonthPoint> data;
  final Color barColor;
  final Color gridColor;
  final Color labelColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final n = data.length;
    final ys = data.map((e) => e.totalBalance).toList();
    final bounds = _axisBounds(ys);
    final minY = bounds.minY;
    final maxY = bounds.maxY;
    final yInterval = bounds.interval;
    final dateFmt = DateFormat('dd.MM');

    return BarChart(
      BarChartData(
        maxY: maxY,
        minY: minY,
        alignment: BarChartAlignment.spaceAround,
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
              reservedSize: 44,
              interval: yInterval,
              getTitlesWidget: (value, meta) {
                if (value < minY - yInterval * 0.01 ||
                    value > maxY + yInterval * 0.01) {
                  return const SizedBox.shrink();
                }
                return SideTitleWidget(
                  meta: meta,
                  space: 4,
                  child: Text(
                    _NetWorthLineChart._formatAxisNumber(value),
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
                    dateFmt.format(data[i].monthStart),
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
        barGroups: [
          for (var i = 0; i < n; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  fromY: math.min(0, data[i].totalBalance),
                  toY: math.max(0, data[i].totalBalance),
                  color: barColor,
                  width: 12,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
        ],
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: 0,
              color: gridColor.withValues(alpha: isDark ? 0.35 : 0.55),
              strokeWidth: 1,
            ),
          ],
        ),
        barTouchData: BarTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBorderRadius: BorderRadius.circular(10),
            maxContentWidth: 200,
            getTooltipColor: (_) => isDark
                ? const Color(0xFF2A3142)
                : Colors.white.withValues(alpha: 0.95),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final i = groupIndex.clamp(0, n - 1);
              final v = data[i].totalBalance;
              return BarTooltipItem(
                'Net worth\n${dateFmt.format(data[i].monthStart)}: ${_NetWorthLineChart._money(v)}',
                TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              );
            },
          ),
        ),
      ),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
    );
  }
}
