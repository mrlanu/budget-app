import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';

/// Shared layout for bar placement, scaling, and hit-testing.
class ChartLayout {
  ChartLayout({
    required this.chartRect,
    required this.barWidth,
    required this.barLefts,
    required this.maxDataValue,
  });

  final Rect chartRect;
  final double barWidth;
  final List<double> barLefts;
  final double maxDataValue;

  static const double leftAxisWidth = 44;
  static const double rightPadding = 8;
  static const double topPadding = 4;
  static const double bottomAxisHeight = 24;

  static ChartLayout compute({
    required Size size,
    required List<double> dataPoints,
    required bool isGrouped,
  }) {
    final n = dataPoints.length;
    if (n == 0) {
      return ChartLayout(
        chartRect: Rect.fromLTWH(
          leftAxisWidth,
          topPadding,
          math.max(0, size.width - leftAxisWidth - rightPadding),
          math.max(0, size.height - topPadding - bottomAxisHeight),
        ),
        barWidth: 0,
        barLefts: const [],
        maxDataValue: 1,
      );
    }

    final maxVal = dataPoints.reduce(math.max);
    final safeMax = maxVal <= 0 ? 1.0 : maxVal;

    final plotW = size.width - leftAxisWidth - rightPadding;
    final plotH = size.height - topPadding - bottomAxisHeight;
    final left = leftAxisWidth;
    final top = topPadding;

    final chartRect = Rect.fromLTWH(left, top, plotW, plotH);

    final barLefts = <double>[];
    double barW = 0;

    if (isGrouped) {
      final pairs = n ~/ 2;
      if (pairs == 0) {
        return ChartLayout(
          chartRect: chartRect,
          barWidth: 0,
          barLefts: const [],
          maxDataValue: safeMax,
        );
      }
      final groupW = plotW / pairs;
      const pairFill = 0.86;
      final pairInnerW = groupW * pairFill;
      barW = pairInnerW * 0.38;
      final gap = pairInnerW * 0.12;

      for (var g = 0; g < pairs; g++) {
        final gx = left + g * groupW + (groupW - pairInnerW) / 2;
        barLefts.add(gx);
        barLefts.add(gx + barW + gap);
      }
    } else {
      final slotW = plotW / n;
      barW = slotW * 0.55;
      for (var i = 0; i < n; i++) {
        barLefts.add(left + i * slotW + (slotW - barW) / 2);
      }
    }

    return ChartLayout(
      chartRect: chartRect,
      barWidth: barW,
      barLefts: barLefts,
      maxDataValue: safeMax,
    );
  }

  /// Scale raw [value] to bar height in logical pixels within [chartRect].
  double scaleHeight(double value) {
    if (chartRect.height <= 0) return 0;
    return (value / maxDataValue) * chartRect.height;
  }

  int? hitTestBar(double dx) {
    for (var i = 0; i < barLefts.length; i++) {
      if (dx >= barLefts[i] && dx <= barLefts[i] + barWidth) {
        return i;
      }
    }
    return null;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChartLayout &&
        chartRect == other.chartRect &&
        barWidth == other.barWidth &&
        maxDataValue == other.maxDataValue &&
        listEquals(barLefts, other.barLefts);
  }

  @override
  int get hashCode => Object.hash(
        chartRect,
        barWidth,
        maxDataValue,
        Object.hashAll(barLefts),
      );
}
