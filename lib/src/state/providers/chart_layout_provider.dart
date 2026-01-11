import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/chart_layout.dart';

class ChartLayoutParams {
  final double width;
  final double height;
  final ChartMargin? margin;

  const ChartLayoutParams({
    required this.width,
    required this.height,
    this.margin,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChartLayoutParams &&
          width == other.width &&
          height == other.height &&
          margin?.top == other.margin?.top &&
          margin?.right == other.margin?.right &&
          margin?.bottom == other.margin?.bottom &&
          margin?.left == other.margin?.left;

  @override
  int get hashCode => Object.hash(
        width,
        height,
        margin?.top,
        margin?.right,
        margin?.bottom,
        margin?.left,
      );
}

final chartLayoutProvider =
    Provider.family<ChartLayout, ChartLayoutParams>((ref, params) {
  return ChartLayout.compute(
    width: params.width,
    height: params.height,
    margin: params.margin,
  );
});

ChartLayout computeChartLayout({
  required Size size,
  ChartMargin? margin,
}) {
  return ChartLayout.compute(
    width: size.width,
    height: size.height,
    margin: margin,
  );
}
