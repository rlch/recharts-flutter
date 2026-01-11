import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/scale/scale.dart';
import '../../core/types/chart_data.dart';
import '../../cartesian/series/area_series.dart';
import '../models/computed_data.dart';

class AreaPointsParams {
  final ChartDataSet data;
  final AreaSeries series;
  final Scale<dynamic, double> xScale;
  final Scale<dynamic, double> yScale;
  final String? xDataKey;
  final double baseY;

  const AreaPointsParams({
    required this.data,
    required this.series,
    required this.xScale,
    required this.yScale,
    this.xDataKey,
    required this.baseY,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AreaPointsParams &&
          data == other.data &&
          series.dataKey == other.series.dataKey &&
          xDataKey == other.xDataKey &&
          baseY == other.baseY;

  @override
  int get hashCode => Object.hash(data, series.dataKey, xDataKey, baseY);
}

final areaPointsProvider =
    Provider.family<List<AreaPoint>, AreaPointsParams>((ref, params) {
  return computeAreaPoints(
    data: params.data,
    series: params.series,
    xScale: params.xScale,
    yScale: params.yScale,
    xDataKey: params.xDataKey,
    baseY: params.baseY,
  );
});

List<AreaPoint> computeAreaPoints({
  required ChartDataSet data,
  required AreaSeries series,
  required Scale<dynamic, double> xScale,
  required Scale<dynamic, double> yScale,
  String? xDataKey,
  required double baseY,
}) {
  final points = <AreaPoint>[];
  final bandwidth = xScale.bandwidth ?? 0;
  final xOffset = bandwidth / 2;

  for (int i = 0; i < data.length; i++) {
    final point = data[i];
    final rawValue = point[series.dataKey];
    final numValue = point.getNumericValue(series.dataKey);

    final xValue = xDataKey != null ? point[xDataKey] : i;
    final x = xScale(xValue) + xOffset;

    if (numValue == null) {
      points.add(AreaPoint(
        index: i,
        x: x,
        y: double.nan,
        baseY: baseY,
        value: rawValue,
        isNull: true,
      ));
    } else {
      points.add(AreaPoint(
        index: i,
        x: x,
        y: yScale(numValue),
        baseY: baseY,
        value: numValue,
        isNull: false,
      ));
    }
  }

  return points;
}
