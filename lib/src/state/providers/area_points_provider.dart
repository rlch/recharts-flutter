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
  final String? yDataKey;
  final double? baseX;
  final double? baseY;
  final bool verticalLayout;

  const AreaPointsParams({
    required this.data,
    required this.series,
    required this.xScale,
    required this.yScale,
    this.xDataKey,
    this.yDataKey,
    this.baseX,
    this.baseY,
    this.verticalLayout = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AreaPointsParams &&
          data == other.data &&
          series.dataKey == other.series.dataKey &&
          xDataKey == other.xDataKey &&
          yDataKey == other.yDataKey &&
          baseX == other.baseX &&
          baseY == other.baseY &&
          verticalLayout == other.verticalLayout;

  @override
  int get hashCode => Object.hash(
    data,
    series.dataKey,
    xDataKey,
    yDataKey,
    baseX,
    baseY,
    verticalLayout,
  );
}

final areaPointsProvider = Provider.family<List<AreaPoint>, AreaPointsParams>((
  ref,
  params,
) {
  return computeAreaPoints(
    data: params.data,
    series: params.series,
    xScale: params.xScale,
    yScale: params.yScale,
    xDataKey: params.xDataKey,
    yDataKey: params.yDataKey,
    baseX: params.baseX,
    baseY: params.baseY,
    verticalLayout: params.verticalLayout,
  );
});

List<AreaPoint> computeAreaPoints({
  required ChartDataSet data,
  required AreaSeries series,
  required Scale<dynamic, double> xScale,
  required Scale<dynamic, double> yScale,
  String? xDataKey,
  String? yDataKey,
  double? baseX,
  double? baseY,
  bool verticalLayout = false,
}) {
  final points = <AreaPoint>[];
  final bandwidth = xScale.bandwidth ?? 0;
  final xOffset = bandwidth / 2;
  final yBandwidth = yScale.bandwidth ?? 0;
  final yOffset = yBandwidth / 2;

  for (int i = 0; i < data.length; i++) {
    final point = data[i];
    final rawValue = point[series.dataKey];
    final numValue = point.getNumericValue(series.dataKey);

    if (verticalLayout) {
      final yValue = yDataKey != null ? point[yDataKey] : i;
      final y = yScale(yValue) + yOffset;
      final resolvedBaseX = baseX ?? xScale(0);

      if (numValue == null) {
        points.add(
          AreaPoint(
            index: i,
            x: double.nan,
            y: y,
            baseX: resolvedBaseX,
            baseY: y,
            value: rawValue,
            isNull: true,
          ),
        );
      } else {
        points.add(
          AreaPoint(
            index: i,
            x: xScale(numValue),
            y: y,
            baseX: resolvedBaseX,
            baseY: y,
            value: numValue,
            isNull: false,
          ),
        );
      }

      continue;
    }

    final xValue = xDataKey != null ? point[xDataKey] : i;
    final x = xScale(xValue) + xOffset;
    final resolvedBaseY = baseY ?? yScale(0);

    if (numValue == null) {
      points.add(
        AreaPoint(
          index: i,
          x: x,
          y: double.nan,
          baseY: resolvedBaseY,
          value: rawValue,
          isNull: true,
        ),
      );
    } else {
      points.add(
        AreaPoint(
          index: i,
          x: x,
          y: yScale(numValue),
          baseY: resolvedBaseY,
          value: numValue,
          isNull: false,
        ),
      );
    }
  }

  return points;
}
