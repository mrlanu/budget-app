import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class BarChart extends StatelessWidget {
  final List<double> dataPoints;
  final List<String> labels;
  final bool isGrouped;
  final Color firstColor;
  final Color secondColor;

  const BarChart(
      {super.key,
      required this.dataPoints,
      required this.labels,
      required this.isGrouped,
      this.firstColor = Colors.green,
      this.secondColor = Colors.red});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return _BarChart(
        dataPoints: dataPoints,
        labels: labels,
        isGrouped: isGrouped,
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        firstColor: firstColor,
        secondColor: secondColor,
      );
    });
  }
}

class _BarChart extends StatefulWidget {
  final List<double> dataPoints;
  final List<String> labels;
  final double width;
  final double height;
  final bool isGrouped;
  final Color firstColor;
  final Color secondColor;

  const _BarChart(
      {required this.dataPoints,
      required this.labels,
      required this.width,
      required this.height,
      required this.isGrouped,
      required this.firstColor,
      required this.secondColor});

  @override
  _BarChartState createState() => _BarChartState();
}

class _BarChartState extends State<_BarChart> with TickerProviderStateMixin {
  late AnimationController controller;
  late BarChartTween tween;
  late List<double> _dataPoints;

  late (double, double) average;

  late List<String> _labels;
  late bool _isGrouped;
  late double maxBarHeight;
  int _tappedIndex = -1;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _dataPoints = widget.dataPoints;
    _labels = widget.labels;
    _isGrouped = widget.isGrouped;
    maxBarHeight = _dataPoints.reduce(max) == 0 ? 1 : _dataPoints.reduce(max);
    final multiplier = widget.height / maxBarHeight;
    tween = BarChartTween(
        BarChartModel.empty(
            amount: _dataPoints.length,
            isGrouped: _isGrouped,
            firstColor: widget.firstColor,
            secondColor: widget.secondColor),
        BarChartModel.fromArray(
            dataPoints: _dataPoints,
            scaledData: _dataPoints.map((e) => e * multiplier).toList(),
            isGrouped: _isGrouped,
            firstColor: widget.firstColor,
            secondColor: widget.secondColor));
    controller.forward();
  }

  void animateTappedBar(int index) {
    setState(() {
      _tappedIndex = index;
    });
  }

  @override
  void didUpdateWidget(covariant _BarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dataPoints != oldWidget.dataPoints) {
      updateData(widget.dataPoints);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void updateData(List<double> newData) {
    var maxBar = newData.reduce(max);
    if (maxBar == 0) {
      maxBar = 1.0;
    }
    final multiplier = widget.height / maxBar;
    setState(() {
      _tappedIndex = -1;
      _dataPoints = newData;
      maxBarHeight = maxBar;
      tween = BarChartTween(
          tween.evaluate(controller),
          BarChartModel.fromArray(
              dataPoints: newData,
              scaledData: _dataPoints.map((e) => e * multiplier).toList(),
              isGrouped: _isGrouped,
              firstColor: widget.firstColor,
              secondColor: widget.secondColor));
      controller.forward(from: 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isThemeDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onPanDown: (details) {
        final barWidth = (widget.width - 40) / _dataPoints.length;
        final index = ((details.localPosition.dx - 40) / barWidth).floor();
        if (index >= 0 && index < _dataPoints.length) {
          animateTappedBar(index);
        } else {
          animateTappedBar(-1);
        }
      },
      child: CustomPaint(
        size: Size(widget.width, widget.height),
        painter: GridPainter(
            maxHeight: maxBarHeight,
            labels: _labels,
            labelsColor: isThemeDark
                ? Color(0xFFB2DFDB)
                : Colors.black.withOpacity(0.5)),
        foregroundPainter: BarChartPainter(tween.animate(controller),
            isGrouped: _isGrouped,
            tappedIndex: _tappedIndex,
            maxWidth: widget.width),
      ),
    );
  }
}

class BarModel {
  final double height;
  final Color color;

  BarModel({required this.height, required this.color});

  factory BarModel.empty() => BarModel(height: 0.0, color: Colors.transparent);

  static BarModel lerp(
      {required BarModel begin, required BarModel end, required double t}) {
    return BarModel(
        height: lerpDouble(begin.height, end.height, t)!,
        color: Color.lerp(begin.color, end.color, t)!);
  }

  BarModel copyWith({double? height, Color? color}) {
    return BarModel(height: height ?? this.height, color: color ?? this.color);
  }
}

class BarChartModel {
  final List<BarModel> bars;
  final List<double> dataPoints;

  BarChartModel({this.bars = const [], this.dataPoints = const []}) {}

  factory BarChartModel.empty(
      {required int amount,
      required bool isGrouped,
      required Color firstColor,
      required Color secondColor}) {
    return BarChartModel(
      dataPoints: List.filled(amount, 0.0),
        bars: List.generate(
            amount,
            (index) => BarModel(
                height: 0.0,
                color: isGrouped
                    ? index % 2 == 0
                        ? secondColor
                        : firstColor
                    : firstColor)));
  }

  factory BarChartModel.fromArray(
      {required List<double> scaledData,
      required List<double> dataPoints,
      required bool isGrouped,
      required Color firstColor,
      required Color secondColor}) {
    return BarChartModel(
        dataPoints: dataPoints,
        bars: List.generate(
            scaledData.length,
            (index) => BarModel(
                height: scaledData[index],
                color: isGrouped
                    ? index % 2 == 0
                        ? secondColor
                        : firstColor
                    : firstColor)));
  }

  static BarChartModel lerp(BarChartModel begin, BarChartModel end, double t) {
    return BarChartModel(
        dataPoints: end.dataPoints,
        bars: List.generate(
            begin.bars.length,
            (i) =>
                BarModel.lerp(begin: begin.bars[i], end: end.bars[i], t: t)));
  }
}

class BarChartTween extends Tween<BarChartModel> {
  BarChartTween(BarChartModel begin, BarChartModel end)
      : super(begin: begin, end: end);

  @override
  BarChartModel lerp(double t) => BarChartModel.lerp(begin!, end!, t);
}

class BarChartPainter extends CustomPainter {
  late final barDistance;
  late final barWidth;

  final Animation<BarChartModel> animation;
  final int tappedIndex;
  final bool isGrouped;

  BarChartPainter(Animation<BarChartModel> animation,
      {required this.isGrouped,
      this.tappedIndex = -1,
      required double maxWidth})
      : animation = animation,
        barDistance = isGrouped ? maxWidth / 31 : maxWidth / 20,
        barWidth = isGrouped ? maxWidth / 34 : maxWidth / 20,
        super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final chart = animation.value;
    var offsetX = 35.0;
    var tappedBarX = 0.0;

    for (var i = 0; i < chart.bars.length; i++) {
      final bar = chart.bars[i];
      _drawBar(bar, offsetX, Paint()..color = bar.color, canvas, size);
      if (i == tappedIndex) {
        tappedBarX = offsetX;
      }
      isGrouped
          ? offsetX += (barDistance + barWidth / 3 * (i % 2))
          : offsetX += barDistance * 1.5;
    }
    isGrouped
        ? _drawDoubleAverage(chart, canvas, size)
        : _drawSingleAverage(chart, canvas, size);
    if (tappedIndex >= 0) {
      _drawLabel(chart.bars[tappedIndex], chart.dataPoints[tappedIndex],
          tappedBarX, canvas, size);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  void _drawBar(BarModel bar, double x, Paint paint, Canvas canvas, Size size) {
    canvas.drawRect(
        Rect.fromLTWH(x, size.height - bar.height, barWidth, bar.height),
        paint);
  }

  void _drawText(Offset position, double width, TextStyle style, String text,
      Canvas canvas) {
    final textSpan = TextSpan(text: text, style: style);
    final textPainter =
        TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    textPainter.layout(minWidth: 0, maxWidth: width);
    textPainter.paint(canvas, position);
  }

  void _drawLabel(BarModel bar, double labelValue, double tappedBarX,
      Canvas canvas, Size size) {
    final txt = '\$ ${labelValue.toStringAsFixed(2)}';
    double labelX = 0.0;
    double labelY = 0.0;
    if (tappedBarX - (9.0 * txt.length / 2) < 0) {
      labelX = 0.0;
    } else if (tappedBarX - (9.0 * txt.length / 2) > 0 &&
        tappedBarX + (9.0 * txt.length / 2) < size.width) {
      labelX = tappedBarX - (9.0 * txt.length / 2);
    } else {
      labelX = size.width - (9.0 * txt.length);
    }
    if ((size.height - bar.height - 35) < 0) {
      labelY = 0.0;
    } else {
      labelY = (size.height - bar.height - 35);
    }
    var labelStyle = TextStyle(
      color: Colors.black,
      fontSize: 15,
      fontWeight: FontWeight.bold,
    );
    final border = Paint()
      ..color = Colors.black38
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final paintBorder = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(labelX, labelY, 9.0 * txt.length, 28),
      Radius.circular(5),
    );
    _drawBar(bar, tappedBarX, border, canvas, size);
    canvas.drawRRect(rect, paint);
    canvas.drawRRect(rect, paintBorder);
    _drawText(Offset(labelX + 5, labelY + 5), 150, labelStyle, txt, canvas);
  }

  void _drawSingleAverage(BarChartModel chart, Canvas canvas, Size size) {
    int count = chart.bars.where((bar) => bar.height > 0).length;
    if (count == 0) return;
    double averageScaled =
        chart.bars.map((e) => e.height).reduce((a, b) => a + b) / count;
    double average = chart.dataPoints.reduce((a, b) => a + b) / count;
    final labelText = '\$ ${average.toStringAsFixed(1)}';
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    var labelStyle = TextStyle(
      color: Colors.black,
      fontSize: 15,
      fontWeight: FontWeight.bold,
    );
    final paintBack = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final paintBorder = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
          45, size.height - averageScaled - 13, 9.0 * labelText.length, 24),
      Radius.circular(5),
    );

    canvas.drawLine(Offset(35, size.height - averageScaled),
        Offset(size.width, size.height - averageScaled), paint);
    canvas.drawRRect(rect, paintBack);
    canvas.drawRRect(rect, paintBorder);
    _drawText(Offset(50, size.height - averageScaled - 10), 150, labelStyle,
        labelText, canvas);
  }

  void _drawDoubleAverage(BarChartModel chart, Canvas canvas, Size size) {
    Map<String, List<BarModel>> splitBarsMap = {'incomes': [], 'expenses': []};
    Map<String, List<double>> splitDataPointsMap = {
      'incomes': [],
      'expenses': []
    };

    for (int i = 0; i < chart.bars.length; i++) {
      if (i % 2 == 0) {
        splitBarsMap['expenses']!.add(chart.bars[i]);
        splitDataPointsMap['expenses']!.add(chart.dataPoints[i]);
      } else {
        splitBarsMap['incomes']!.add(chart.bars[i]);
        splitDataPointsMap['incomes']!.add(chart.dataPoints[i]);
      }
    }
    int countIncomes =
        splitBarsMap['incomes']!.where((bar) => bar.height > 0).length;
    int countExpenses =
        splitBarsMap['expenses']!.where((bar) => bar.height > 0).length;
    if (countIncomes == 0) countIncomes = 1;
    if (countExpenses == 0) countExpenses = 1;
    double averageScaledIncomes =
        splitBarsMap['incomes']!.map((e) => e.height).reduce((a, b) => a + b) /
            countIncomes;
    double averageScaledExpenses =
        splitBarsMap['expenses']!.map((e) => e.height).reduce((a, b) => a + b) /
            countExpenses;
    double averageIncomes =
        splitDataPointsMap['incomes']!.reduce((a, b) => a + b) / countIncomes;
    double averageExpenses =
        splitDataPointsMap['expenses']!.reduce((a, b) => a + b) / countExpenses;

    final labelTextIncomes = '\$ ${averageIncomes.toStringAsFixed(1)}';
    final labelTextExpenses = '\$ ${averageExpenses.toStringAsFixed(1)}';
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    var labelStyle = TextStyle(
      color: Colors.black,
      fontSize: 15,
      fontWeight: FontWeight.bold,
    );
    final paintBackIncomes = Paint()
      ..color = Colors.lightGreen
      ..style = PaintingStyle.fill;
    final paintBackExpenses = Paint()
      ..color = Colors.redAccent
      ..style = PaintingStyle.fill;
    final paintBorder = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final rectIncomes = RRect.fromRectAndRadius(
      Rect.fromLTWH(45, size.height - averageScaledIncomes - 13,
          9.0 * labelTextIncomes.length, 24),
      Radius.circular(5),
    );

    final rectExpenses = RRect.fromRectAndRadius(
      Rect.fromLTWH(
          55 + 9.0 * labelTextIncomes.length,
          size.height - averageScaledExpenses - 13,
          9.0 * labelTextExpenses.length,
          24),
      Radius.circular(5),
    );

    canvas.drawLine(Offset(35, size.height - averageScaledIncomes),
        Offset(size.width, size.height - averageScaledIncomes), paint);
    canvas.drawLine(Offset(35, size.height - averageScaledExpenses),
        Offset(size.width, size.height - averageScaledExpenses), paint);
    canvas.drawRRect(rectIncomes, paintBorder);
    canvas.drawRRect(rectIncomes, paintBackIncomes);
    canvas.drawRRect(rectExpenses, paintBorder);
    canvas.drawRRect(rectExpenses, paintBackExpenses);
    _drawText(Offset(50, size.height - averageScaledIncomes - 10), 150,
        labelStyle, labelTextIncomes, canvas);
    _drawText(
        Offset(60 + 9.0 * labelTextIncomes.length,
            size.height - averageScaledExpenses - 10),
        150,
        labelStyle,
        labelTextExpenses,
        canvas);
  }
}

class GridPainter extends CustomPainter {
  final double maxHeight;
  final List<String> labels;
  final Color labelsColor;

  GridPainter(
      {required this.maxHeight,
      required this.labels,
      required this.labelsColor});

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final double stepX = width / 13; // Adjust the step as needed
    final double stepY = height / 13; // Adjust the step as needed

    final Paint gridPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    for (double x = 35; x <= width; x += stepX) {
      canvas.drawLine(Offset(x, 0), Offset(x, height), gridPaint);
    }

    for (double y = 1; y <= height; y += stepY) {
      canvas.drawLine(Offset(35, y), Offset(width, y), gridPaint);
    }

    drawText(Canvas canvas, Offset position, double width, TextStyle style,
        String text) {
      final textSpan = TextSpan(text: text, style: style);
      final textPainter =
          TextPainter(text: textSpan, textDirection: TextDirection.ltr);
      textPainter.layout(minWidth: 0, maxWidth: width);
      textPainter.paint(canvas, position);
    }

    void drawLabels(Canvas canvas, Rect rect, TextStyle labelStyle) {
      var colW = size.width / 13.5;
      // draw x Label
      var x = rect.left + 37;
      for (var i = 0; i < 12; i++) {
        drawText(canvas, Offset(x, height + 5), 20, labelStyle, labels[i]);
        x += colW;
      }

      //draw y Label
      drawText(canvas, rect.bottomLeft + Offset(0, -15), 40, labelStyle,
          '0.0K'); // print min value
      drawText(canvas, rect.topLeft + Offset(0, size.height / 4 * 3 - 10), 40,
          labelStyle, '${(maxHeight / 4 / 1000).toStringAsFixed(1)}K');
      drawText(canvas, rect.topLeft + Offset(0, size.height / 2 - 10), 40,
          labelStyle, '${(maxHeight / 2 / 1000).toStringAsFixed(1)}K');
      drawText(canvas, rect.topLeft + Offset(0, size.height / 4 - 10), 40,
          labelStyle, '${(maxHeight / 4 / 1000 * 3).toStringAsFixed(1)}K');
      drawText(canvas, rect.topLeft + Offset(0, 0 - 10), 40, labelStyle,
          '${(maxHeight / 1000).toStringAsFixed(1)}K'); // print max value
    }

    var labelStyle = TextStyle(
      color: labelsColor,
      fontSize: 15,
      fontWeight: FontWeight.bold,
    );

    drawLabels(
        canvas, Rect.fromLTWH(0, 0, size.width, size.height), labelStyle);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
