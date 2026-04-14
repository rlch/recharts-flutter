import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/scale/scale.dart';
import '../../core/types/chart_data.dart';
import '../../core/types/series_types.dart';
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

Map<String, List<AreaPoint>> computeStackedAreaPointsMap({
  required ChartDataSet data,
  required List<AreaSeries> areaSeries,
  required Scale<dynamic, double> xScale,
  required Scale<dynamic, double> yScale,
  String? xDataKey,
  String? yDataKey,
  double? baseX,
  double? baseY,
  bool verticalLayout = false,
  StackOffsetType stackOffset = StackOffsetType.none,
}) {
  if (areaSeries.isEmpty) {
    return <String, List<AreaPoint>>{};
  }

  final pointsMap = <String, List<AreaPoint>>{};

  if (verticalLayout) {
    for (final series in areaSeries) {
      pointsMap[series.dataKey] = computeAreaPoints(
        data: data,
        series: series,
        xScale: xScale,
        yScale: yScale,
        xDataKey: xDataKey,
        yDataKey: yDataKey,
        baseX: baseX,
        baseY: baseY,
        verticalLayout: verticalLayout,
      );
    }
    return pointsMap;
  }

  final stackGroups = <String, List<AreaSeries>>{};
  for (final series in areaSeries) {
    final stackKey = series.stackId ?? '__unstacked__${series.dataKey}';
    stackGroups.putIfAbsent(stackKey, () => <AreaSeries>[]).add(series);
  }

  final expandedStack = stackOffset == StackOffsetType.expand;

  for (final entry in stackGroups.entries) {
    final stackSeries = entry.value;
    final cumulative = List<double>.filled(data.length, 0);
    final totals = List<double>.filled(data.length, 0);

    if (expandedStack) {
      for (int i = 0; i < data.length; i++) {
        double sum = 0;
        for (final series in stackSeries) {
          final value = data[i].getNumericValue(series.dataKey);
          if (value != null && !value.isNaN) {
            sum += value;
          }
        }
        totals[i] = sum;
      }
    }

    for (final series in stackSeries) {
      final points = <AreaPoint>[];
      for (int i = 0; i < data.length; i++) {
        final rawValue = data[i][series.dataKey];
        final value = data[i].getNumericValue(series.dataKey);
        final xValue = xDataKey != null ? data[i][xDataKey] : i;
        final x = xScale(xValue) + (xScale.bandwidth ?? 0) / 2;

        if (value == null || value.isNaN) {
          points.add(
            AreaPoint(
              index: i,
              x: x,
              y: double.nan,
              baseY: baseY ?? yScale(0),
              value: rawValue,
              isNull: true,
            ),
          );
          continue;
        }

        final total = totals[i];
        final normalizedValue = expandedStack
            ? (total > 0 ? value / total : 0)
            : value;
        final stackBaseValue = cumulative[i];
        final stackTopValue = stackBaseValue + normalizedValue;
        cumulative[i] = stackTopValue;

        points.add(
          AreaPoint(
            index: i,
            x: x,
            y: yScale(stackTopValue),
            baseY: yScale(stackBaseValue),
            value: value,
            isNull: false,
          ),
        );
      }

      pointsMap[series.dataKey] = points;
    }
  }

  return pointsMap;
}
