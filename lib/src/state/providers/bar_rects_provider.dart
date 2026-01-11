import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/scale/scale.dart';
import '../../core/types/chart_data.dart';
import '../../cartesian/series/bar_series.dart';
import '../models/computed_data.dart';

class BarRectsParams {
  final ChartDataSet data;
  final BarSeries series;
  final Scale<dynamic, double> xScale;
  final Scale<dynamic, double> yScale;
  final String? xDataKey;
  final double baseY;
  final int barIndex;
  final int totalBars;

  const BarRectsParams({
    required this.data,
    required this.series,
    required this.xScale,
    required this.yScale,
    this.xDataKey,
    required this.baseY,
    this.barIndex = 0,
    this.totalBars = 1,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BarRectsParams &&
          data == other.data &&
          series.dataKey == other.series.dataKey &&
          xDataKey == other.xDataKey &&
          baseY == other.baseY &&
          barIndex == other.barIndex &&
          totalBars == other.totalBars;

  @override
  int get hashCode => Object.hash(
        data,
        series.dataKey,
        xDataKey,
        baseY,
        barIndex,
        totalBars,
      );
}

final barRectsProvider =
    Provider.family<List<BarRect>, BarRectsParams>((ref, params) {
  return computeBarRects(
    data: params.data,
    series: params.series,
    xScale: params.xScale,
    yScale: params.yScale,
    xDataKey: params.xDataKey,
    baseY: params.baseY,
    barIndex: params.barIndex,
    totalBars: params.totalBars,
  );
});

List<BarRect> computeBarRects({
  required ChartDataSet data,
  required BarSeries series,
  required Scale<dynamic, double> xScale,
  required Scale<dynamic, double> yScale,
  String? xDataKey,
  required double baseY,
  int barIndex = 0,
  int totalBars = 1,
}) {
  final rects = <BarRect>[];
  final bandwidth = xScale.bandwidth ?? 20;
  
  final barGap = 4.0;
  final totalGaps = (totalBars - 1) * barGap;
  final availableWidth = bandwidth - totalGaps;
  final barWidth = series.barSize ?? (availableWidth / totalBars);
  
  final totalBarsWidth = barWidth * totalBars + totalGaps;
  final startOffset = (bandwidth - totalBarsWidth) / 2;
  final barOffset = startOffset + barIndex * (barWidth + barGap);

  for (int i = 0; i < data.length; i++) {
    final point = data[i];
    final numValue = point.getNumericValue(series.dataKey);

    if (numValue == null) continue;

    final xValue = xDataKey != null ? point[xDataKey] : i;
    final x = xScale(xValue) + barOffset;
    final y = yScale(numValue);

    final top = y < baseY ? y : baseY;
    final height = (y - baseY).abs();

    rects.add(BarRect(
      index: i,
      rect: Rect.fromLTWH(x, top, barWidth, height),
      value: numValue,
      dataKey: series.dataKey,
    ));
  }

  return rects;
}
