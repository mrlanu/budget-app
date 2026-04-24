import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'chart_geometry.dart';
import 'chart_models.dart';
import 'chart_painters.dart';

/// Animated bar chart with optional grouped (two-tone) bars, grid, and tap
/// tooltips.
///
/// For [isGrouped] == true, [dataPoints] should contain an even number of
/// values (e.g. expense then income per period). [labels] may list one label
/// per period (length == dataPoints.length / 2) or one per bar
/// (length == dataPoints.length).
class BarChart extends StatelessWidget {
  const BarChart({
    super.key,
    required this.dataPoints,
    required this.labels,
    required this.isGrouped,
    this.firstColor = Colors.green,
    this.secondColor = Colors.red,
    this.valueFormatter,
  });

  final List<double> dataPoints;
  final List<String> labels;
  final bool isGrouped;
  final Color firstColor;
  final Color secondColor;

  /// Formats values in the tap tooltip and average badges. Defaults to
  /// `"$ "` + two decimal places.
  final String Function(double value)? valueFormatter;

  @override
  Widget build(BuildContext context) {
    if (dataPoints.isEmpty) {
      return Center(
        child: Text(
          'No data',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
        ),
      );
    }

    assert(
      !isGrouped || dataPoints.length.isEven,
      'Grouped bar chart expects an even number of data points '
      '(e.g. expense + income per month).',
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 1 || constraints.maxHeight < 1) {
          return const SizedBox.shrink();
        }
        return _BarChart(
          dataPoints: dataPoints,
          labels: labels,
          isGrouped: isGrouped,
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          firstColor: firstColor,
          secondColor: secondColor,
          valueFormatter: valueFormatter ?? _defaultFormat,
        );
      },
    );
  }

  static String _defaultFormat(double v) => '\$ ${v.toStringAsFixed(2)}';
}

class _BarChart extends StatefulWidget {
  const _BarChart({
    required this.dataPoints,
    required this.labels,
    required this.width,
    required this.height,
    required this.isGrouped,
    required this.firstColor,
    required this.secondColor,
    required this.valueFormatter,
  });

  final List<double> dataPoints;
  final List<String> labels;
  final double width;
  final double height;
  final bool isGrouped;
  final Color firstColor;
  final Color secondColor;
  final String Function(double value) valueFormatter;

  @override
  State<_BarChart> createState() => _BarChartState();
}

class _BarChartState extends State<_BarChart> with TickerProviderStateMixin {
  late AnimationController _controller;
  late BarChartTween _tween;
  late List<double> _dataPoints;
  late List<String> _labels;
  late bool _isGrouped;
  int _tappedIndex = -1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _dataPoints = List<double>.from(widget.dataPoints);
    _labels = List<String>.from(widget.labels);
    _isGrouped = widget.isGrouped;
    _tween = _buildTween();
    _controller.forward();
  }

  BarChartTween _buildTween() {
    final size = Size(widget.width, widget.height);
    final layout = ChartLayout.compute(
      size: size,
      dataPoints: _dataPoints,
      isGrouped: _isGrouped,
    );
    final maxH = layout.chartRect.height;
    final denom = layout.maxDataValue <= 0 ? 1.0 : layout.maxDataValue;

    return BarChartTween(
      BarChartModel.empty(
        amount: _dataPoints.length,
        isGrouped: _isGrouped,
        firstColor: widget.firstColor,
        secondColor: widget.secondColor,
      ),
      BarChartModel.fromArray(
        dataPoints: _dataPoints,
        scaledData: _dataPoints.map((e) => (e / denom) * maxH).toList(),
        isGrouped: _isGrouped,
        firstColor: widget.firstColor,
        secondColor: widget.secondColor,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant _BarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(widget.dataPoints, oldWidget.dataPoints) ||
        !listEquals(widget.labels, oldWidget.labels) ||
        widget.isGrouped != oldWidget.isGrouped ||
        widget.firstColor != oldWidget.firstColor ||
        widget.secondColor != oldWidget.secondColor ||
        widget.width != oldWidget.width ||
        widget.height != oldWidget.height) {
      setState(() {
        _tappedIndex = -1;
        _dataPoints = List<double>.from(widget.dataPoints);
        _labels = List<String>.from(widget.labels);
        _isGrouped = widget.isGrouped;
        _tween = BarChartTween(
          _tween.evaluate(_controller),
          _buildTween().end!,
        );
        _controller.forward(from: 0);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details, ChartLayout layout) {
    final idx = layout.hitTestBar(details.localPosition.dx);
    setState(() {
      _tappedIndex = idx ?? -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = Size(widget.width, widget.height);
    final layout = ChartLayout.compute(
      size: size,
      dataPoints: _dataPoints,
      isGrouped: _isGrouped,
    );

    final gridLine =
        theme.dividerColor.withValues(alpha: isDark ? 0.35 : 0.5);
    final axisColor = theme.colorScheme.onSurface.withValues(alpha: 0.65);

    final curved = _tween.animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    return RepaintBoundary(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (d) => _onTapDown(d, layout),
        child: CustomPaint(
          size: size,
          painter: GridPainter(
            layout: layout,
            labels: _labels,
            axisLabelColor: axisColor,
            gridLineColor: gridLine,
            isGrouped: _isGrouped,
            theme: theme,
          ),
          foregroundPainter: BarChartPainter(
            curved,
            layout: layout,
            isGrouped: _isGrouped,
            tappedIndex: _tappedIndex,
            formatValue: widget.valueFormatter,
            theme: theme,
          ),
        ),
      ),
    );
  }
}
