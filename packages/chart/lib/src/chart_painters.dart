import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'chart_geometry.dart';
import 'chart_models.dart';

/// Background panel, grid, and axis labels.
class GridPainter extends CustomPainter {
  GridPainter({
    required this.layout,
    required this.labels,
    required this.axisLabelColor,
    required this.gridLineColor,
    required this.isGrouped,
    required this.theme,
  });

  final ChartLayout layout;
  final List<String> labels;
  final Color axisLabelColor;
  final Color gridLineColor;
  final bool isGrouped;
  final ThemeData theme;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = layout.chartRect;
    if (chart.width <= 0 || chart.height <= 0) return;

    _drawPanelBackground(canvas, chart);

    final gridStrong = gridLineColor.withValues(alpha: 0.55);
    final gridSoft = gridLineColor.withValues(alpha: 0.22);

    const divisions = 4;
    for (var i = 0; i <= divisions; i++) {
      final t = i / divisions;
      final y = chart.top + chart.height * (1 - t);
      final paint = Paint()
        ..color = i == 0 ? gridStrong : gridSoft
        ..strokeWidth = i == 0 ? 1.2 : 1;
      canvas.drawLine(
        Offset(chart.left, y),
        Offset(chart.right, y),
        paint,
      );
    }

    final axisStyle = TextStyle(
      color: axisLabelColor,
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
    );

    for (var i = 0; i <= divisions; i++) {
      final t = i / divisions;
      final value = layout.maxDataValue * t;
      final y = chart.top + chart.height * (1 - t) - 4;
      _paintText(
        canvas,
        Offset(4, y),
        _formatAxisValue(value),
        axisStyle,
        maxWidth: chart.left - 8,
      );
    }

    final labelStyle = TextStyle(
      color: axisLabelColor,
      fontSize: 10.5,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
    );

    _paintXLabels(canvas, chart, labelStyle);
  }

  void _drawPanelBackground(Canvas canvas, Rect chart) {
    final r = 14.0;
    final rr = RRect.fromRectAndRadius(chart, Radius.circular(r));

    final bg = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          theme.colorScheme.surfaceContainerLow.withValues(alpha: 0.22),
        ],
      ).createShader(chart);
    canvas.drawRRect(rr, bg);

    final border = Paint()
      ..color = theme.colorScheme.outline.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRRect(rr, border);
  }

  void _paintXLabels(Canvas canvas, Rect chart, TextStyle style) {
    final barCount = layout.barLefts.length;
    if (labels.isEmpty || barCount == 0) return;

    if (isGrouped && labels.length * 2 == barCount) {
      for (var i = 0; i < labels.length; i++) {
        final x1 = layout.barLefts[i * 2];
        final x2 = layout.barLefts[i * 2 + 1];
        final cx = (x1 + x2 + layout.barWidth) / 2;
        _paintTextCentered(
          canvas,
          Offset(cx, chart.bottom + 5),
          labels[i],
          style,
          chart,
        );
      }
    } else if (labels.length == barCount) {
      for (var i = 0; i < barCount; i++) {
        final cx = layout.barLefts[i] + layout.barWidth / 2;
        _paintTextCentered(
          canvas,
          Offset(cx, chart.bottom + 5),
          labels[i],
          style,
          chart,
        );
      }
    } else {
      final n = math.min(labels.length, barCount);
      for (var i = 0; i < n; i++) {
        final cx = layout.barLefts[i] + layout.barWidth / 2;
        _paintTextCentered(
          canvas,
          Offset(cx, chart.bottom + 5),
          labels[i],
          style,
          chart,
        );
      }
    }
  }

  void _paintTextCentered(
    Canvas canvas,
    Offset anchor,
    String text,
    TextStyle style,
    Rect chart,
  ) {
    final span = TextSpan(text: text, style: style);
    final tp = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: 80);

    var dx = anchor.dx - tp.width / 2;
    dx = dx.clamp(chart.left, chart.right - tp.width);
    tp.paint(canvas, Offset(dx, anchor.dy));
  }

  void _paintText(
    Canvas canvas,
    Offset offset,
    String text,
    TextStyle style, {
    required double maxWidth,
  }) {
    final span = TextSpan(text: text, style: style);
    final tp = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: maxWidth);
    tp.paint(canvas, offset);
  }

  static String _formatAxisValue(double v) {
    if (v >= 1e6) return '${(v / 1e6).toStringAsFixed(1)}M';
    if (v >= 1e3) return '${(v / 1e3).toStringAsFixed(1)}k';
    if (v >= 100) return v.toStringAsFixed(0);
    if (v >= 10) return v.toStringAsFixed(1);
    return v.toStringAsFixed(2);
  }

  @override
  bool shouldRepaint(covariant GridPainter oldDelegate) {
    return oldDelegate.layout != layout ||
        oldDelegate.axisLabelColor != axisLabelColor ||
        oldDelegate.gridLineColor != gridLineColor ||
        oldDelegate.isGrouped != isGrouped ||
        oldDelegate.theme != theme ||
        !_listEquals(oldDelegate.labels, labels);
  }

  static bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// Foreground bars (gradient, shadow, rounded tops), averages, tooltips.
class BarChartPainter extends CustomPainter {
  BarChartPainter(
    this.animation, {
    required this.layout,
    required this.isGrouped,
    required this.tappedIndex,
    required this.formatValue,
    required this.theme,
    this.averageLabelStyle,
  }) : super(repaint: animation);

  final Animation<BarChartModel> animation;
  final ChartLayout layout;
  final bool isGrouped;
  final int tappedIndex;
  final String Function(double value) formatValue;
  final ThemeData theme;
  final TextStyle? averageLabelStyle;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = animation.value;
    final area = layout.chartRect;
    if (area.height <= 0 || chart.bars.isEmpty) return;

    var tappedBarX = 0.0;
    for (var i = 0; i < chart.bars.length; i++) {
      final bar = chart.bars[i];
      final x = i < layout.barLefts.length ? layout.barLefts[i] : 0.0;
      final h = bar.height.clamp(0.0, area.height);
      if (i == tappedIndex) {
        tappedBarX = x;
      }
      _drawBar(
        canvas: canvas,
        x: x,
        bottom: area.bottom,
        width: layout.barWidth,
        height: h,
        color: bar.color,
        elevation: i == tappedIndex ? 5.0 : 2.5,
        emphasize: i == tappedIndex,
      );
    }

    if (isGrouped) {
      _drawDoubleAverage(chart, canvas, area);
    } else {
      _drawSingleAverage(chart, canvas, area);
    }

    if (tappedIndex >= 0 && tappedIndex < chart.bars.length) {
      _drawTooltip(
        size,
        chart.bars[tappedIndex],
        chart.dataPoints[tappedIndex],
        tappedBarX,
        canvas,
        area,
      );
    }
  }

  void _drawBar({
    required Canvas canvas,
    required double x,
    required double bottom,
    required double width,
    required double height,
    required Color color,
    required double elevation,
    required bool emphasize,
  }) {
    if (height <= 0.5) return;

    var topRadius = math.min(11.0, width * 0.42);
    if (height < topRadius * 2) {
      topRadius = height * 0.45;
    }

    final rect = Rect.fromLTWH(x, bottom - height, width, height);
    final rrect = RRect.fromRectAndCorners(
      rect,
      topLeft: Radius.circular(topRadius),
      topRight: Radius.circular(topRadius),
    );

    final path = Path()..addRRect(rrect);
    final shadowColor = Colors.black.withValues(alpha: emphasize ? 0.35 : 0.22);
    canvas.drawShadow(path, shadowColor, emphasize ? elevation : elevation * 0.85, false);

    final topC = Color.lerp(color, Colors.white, 0.22)!;
    final midC = color;
    final botC = Color.lerp(color, Colors.black, emphasize ? 0.18 : 0.12)!;

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [topC, midC, botC],
        stops: const [0.0, 0.45, 1.0],
      ).createShader(rect);
    canvas.drawRRect(rrect, paint);

    final gloss = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: 0.28),
          Colors.white.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(x, bottom - height, width, height * 0.42));
    canvas.save();
    canvas.clipRRect(rrect);
    canvas.drawRect(
      Rect.fromLTWH(x, bottom - height, width, height * 0.38),
      gloss,
    );
    canvas.restore();
  }

  void _drawTooltip(
    Size size,
    BarModel bar,
    double labelValue,
    double tappedBarX,
    Canvas canvas,
    Rect area,
  ) {
    final txt = formatValue(labelValue);
    final style = averageLabelStyle ??
        theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ) ??
        TextStyle(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        );

    final span = TextSpan(text: txt, style: style);
    final tp = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 200);

    final pad = 10.0;
    final boxW = tp.width + pad * 2;
    final boxH = tp.height + pad * 2;

    var labelX = tappedBarX + layout.barWidth / 2 - boxW / 2;
    labelX = labelX.clamp(4.0, size.width - boxW - 4);

    final rawY = area.bottom - bar.height - boxH - 8;
    final labelY = rawY.clamp(area.top, area.bottom - boxH);

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(labelX, labelY, boxW, boxH),
      const Radius.circular(10),
    );

    final bgPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          theme.colorScheme.surfaceContainerHigh.withValues(alpha: 0.95),
          theme.colorScheme.surfaceContainer.withValues(alpha: 0.9),
        ],
      ).createShader(Rect.fromLTWH(labelX, labelY, boxW, boxH));
    canvas.drawRRect(rrect, bgPaint);

    canvas.drawRRect(
      rrect,
      Paint()
        ..color = theme.colorScheme.primary.withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    canvas.drawRRect(
      rrect,
      Paint()
        ..color = theme.colorScheme.outline.withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    tp.paint(canvas, Offset(labelX + pad, labelY + pad));
  }

  void _drawSingleAverage(BarChartModel chart, Canvas canvas, Rect area) {
    final active = chart.bars.where((b) => b.height > 0).toList();
    if (active.isEmpty) return;

    final sumScaled = active.map((e) => e.height).reduce((a, b) => a + b);
    final sumRaw = chart.dataPoints
        .where((d) => d > 0)
        .fold<double>(0, (a, b) => a + b);
    final countRaw = chart.dataPoints
        .where((d) => d > 0)
        .length
        .clamp(1, chart.dataPoints.length);

    final averageScaled = sumScaled / active.length;
    final average = sumRaw / countRaw;

    final y = area.bottom - averageScaled;

    final linePaint = Paint()
      ..color = theme.colorScheme.primary.withValues(alpha: 0.78)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;
    _drawHorizontalDashedLine(
      canvas,
      area.left,
      area.right,
      y,
      linePaint,
      dashLength: 7,
      gapLength: 5,
    );

    final labelText = formatValue(average);
    final style = averageLabelStyle ??
        theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onPrimary,
          fontSize: 11,
        ) ??
        TextStyle(
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onPrimary,
          fontSize: 11,
        );

    final span = TextSpan(text: labelText, style: style);
    final tp = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 160);

    final bx = (area.left + 8).clamp(4.0, area.right - tp.width - 20);
    final by = (y - tp.height - 12).clamp(area.top, area.bottom - tp.height);

    final badge = RRect.fromRectAndRadius(
      Rect.fromLTWH(bx, by, tp.width + 14, tp.height + 8),
      const Radius.circular(8),
    );
    final badgePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          theme.colorScheme.primary,
          theme.colorScheme.primary.withValues(alpha: 0.82),
        ],
      ).createShader(Rect.fromLTWH(bx, by, tp.width + 14, tp.height + 8));
    canvas.drawRRect(badge, badgePaint);
    canvas.drawRRect(
      badge,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    tp.paint(canvas, Offset(bx + 7, by + 4));
  }

  void _drawDoubleAverage(BarChartModel chart, Canvas canvas, Rect area) {
    final expensesBars = <BarModel>[];
    final expensesData = <double>[];
    final incomesBars = <BarModel>[];
    final incomesData = <double>[];

    for (var i = 0; i < chart.bars.length; i++) {
      if (i.isEven) {
        expensesBars.add(chart.bars[i]);
        expensesData.add(chart.dataPoints[i]);
      } else {
        incomesBars.add(chart.bars[i]);
        incomesData.add(chart.dataPoints[i]);
      }
    }

    double avgScaled(List<BarModel> bars) {
      final nz = bars.where((b) => b.height > 0).toList();
      if (nz.isEmpty) return 0;
      return nz.map((e) => e.height).reduce((a, b) => a + b) / nz.length;
    }

    double avgRaw(List<double> data) {
      final nz = data.where((d) => d > 0).toList();
      if (nz.isEmpty) return 0;
      return nz.reduce((a, b) => a + b) / nz.length;
    }

    final ei = avgScaled(expensesBars);
    final ii = avgScaled(incomesBars);
    final er = avgRaw(expensesData);
    final ir = avgRaw(incomesData);

    if (ei > 0) {
      final y = area.bottom - ei;
      _drawDashedHLine(canvas, area, y, theme.colorScheme.error.withValues(alpha: 0.85));
      _paintAvgBadge(
        canvas,
        area,
        y,
        formatValue(er),
        theme.colorScheme.errorContainer,
        theme.colorScheme.onErrorContainer,
      );
    }

    if (ii > 0) {
      final y = area.bottom - ii;
      _drawDashedHLine(canvas, area, y, theme.colorScheme.tertiary.withValues(alpha: 0.9));
      _paintAvgBadge(
        canvas,
        area,
        y,
        formatValue(ir),
        theme.colorScheme.tertiaryContainer,
        theme.colorScheme.onTertiaryContainer,
        xOffset: 96,
      );
    }
  }

  void _drawDashedHLine(Canvas canvas, Rect area, double y, Color color) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke;
    _drawHorizontalDashedLine(
      canvas,
      area.left,
      area.right,
      y,
      p,
      dashLength: 7,
      gapLength: 5,
    );
  }

  void _drawHorizontalDashedLine(
    Canvas canvas,
    double left,
    double right,
    double y,
    Paint paint, {
    required double dashLength,
    required double gapLength,
  }) {
    var x = left;
    while (x < right) {
      final x2 = math.min(x + dashLength, right);
      canvas.drawLine(Offset(x, y), Offset(x2, y), paint);
      x = x2 + gapLength;
    }
  }

  void _paintAvgBadge(
    Canvas canvas,
    Rect area,
    double lineY,
    String text,
    Color bg,
    Color fg, {
    double xOffset = 8,
  }) {
    final style = TextStyle(
      color: fg,
      fontSize: 11,
      fontWeight: FontWeight.w700,
    );
    final span = TextSpan(text: text, style: style);
    final tp = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 140);

    final bx = (area.left + xOffset).clamp(4.0, area.right - tp.width - 16);
    final by = (lineY - tp.height - 11).clamp(area.top, area.bottom - tp.height);

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(bx, by, tp.width + 12, tp.height + 8),
      const Radius.circular(8),
    );
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Color.lerp(bg, Colors.white, 0.08)!,
          bg,
        ],
      ).createShader(Rect.fromLTWH(bx, by, tp.width + 12, tp.height + 8));
    canvas.drawRRect(rrect, paint);
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = fg.withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    tp.paint(canvas, Offset(bx + 6, by + 4));
  }

  @override
  bool shouldRepaint(covariant BarChartPainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.layout != layout ||
        oldDelegate.tappedIndex != tappedIndex ||
        oldDelegate.isGrouped != isGrouped ||
        oldDelegate.theme != theme;
  }
}
