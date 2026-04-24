import 'dart:ui';

import 'package:flutter/material.dart';

class BarModel {
  const BarModel({required this.height, required this.color});

  final double height;
  final Color color;

  factory BarModel.empty() =>
      const BarModel(height: 0, color: Colors.transparent);

  static BarModel lerp({
    required BarModel begin,
    required BarModel end,
    required double t,
  }) {
    return BarModel(
      height: lerpDouble(begin.height, end.height, t)!,
      color: Color.lerp(begin.color, end.color, t)!,
    );
  }
}

class BarChartModel {
  const BarChartModel({
    this.bars = const [],
    this.dataPoints = const [],
  });

  final List<BarModel> bars;
  final List<double> dataPoints;

  factory BarChartModel.empty({
    required int amount,
    required bool isGrouped,
    required Color firstColor,
    required Color secondColor,
  }) {
    return BarChartModel(
      dataPoints: List<double>.filled(amount, 0),
      bars: List.generate(
        amount,
        (index) => BarModel(
          height: 0,
          color: isGrouped
              ? (index.isEven ? secondColor : firstColor)
              : firstColor,
        ),
      ),
    );
  }

  factory BarChartModel.fromArray({
    required List<double> scaledData,
    required List<double> dataPoints,
    required bool isGrouped,
    required Color firstColor,
    required Color secondColor,
  }) {
    return BarChartModel(
      dataPoints: dataPoints,
      bars: List.generate(
        scaledData.length,
        (index) => BarModel(
          height: scaledData[index],
          color: isGrouped
              ? (index.isEven ? secondColor : firstColor)
              : firstColor,
        ),
      ),
    );
  }

  static BarChartModel lerp(BarChartModel begin, BarChartModel end, double t) {
    final n = end.bars.length;
    return BarChartModel(
      dataPoints: end.dataPoints,
      bars: List.generate(
        n,
        (i) => BarModel.lerp(
          begin: i < begin.bars.length ? begin.bars[i] : BarModel.empty(),
          end: end.bars[i],
          t: t,
        ),
      ),
    );
  }
}

class BarChartTween extends Tween<BarChartModel> {
  BarChartTween(BarChartModel begin, BarChartModel end)
      : super(begin: begin, end: end);

  @override
  BarChartModel lerp(double t) => BarChartModel.lerp(begin!, end!, t);
}
