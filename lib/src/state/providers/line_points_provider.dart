import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/scale/scale.dart';
import '../../core/types/chart_data.dart';
import '../../cartesian/series/line_series.dart';
import '../models/computed_data.dart';

class LinePointsParams {
  final ChartDataSet data;
  final LineSeries series;
  final Scale<dynamic, double> xScale;
  final Scale<dynamic, double> yScale;
  final String? xDataKey;
  final String? yDataKey;
  final bool verticalLayout;

  const LinePointsParams({
    required this.data,
    required this.series,
    required this.xScale,
    required this.yScale,
    this.xDataKey,
    this.yDataKey,
    this.verticalLayout = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LinePointsParams &&
          data == other.data &&
          series.dataKey == other.series.dataKey &&
          xDataKey == other.xDataKey &&
          yDataKey == other.yDataKey &&
          verticalLayout == other.verticalLayout;

  @override
  int get hashCode =>
      Object.hash(data, series.dataKey, xDataKey, yDataKey, verticalLayout);
}

final linePointsProvider = Provider.family<List<LinePoint>, LinePointsParams>((
  ref,
  params,
) {
  return computeLinePoints(
    data: params.data,
    series: params.series,
    xScale: params.xScale,
    yScale: params.yScale,
    xDataKey: params.xDataKey,
    yDataKey: params.yDataKey,
    verticalLayout: params.verticalLayout,
  );
});

List<LinePoint> computeLinePoints({
  required ChartDataSet data,
  required LineSeries series,
  required Scale<dynamic, double> xScale,
  required Scale<dynamic, double> yScale,
  String? xDataKey,
  String? yDataKey,
  bool verticalLayout = false,
}) {
  final points = <LinePoint>[];
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

      if (numValue == null) {
        points.add(
          LinePoint(
            index: i,
            x: double.nan,
            y: y,
            value: rawValue,
            isNull: true,
          ),
        );
      } else {
        points.add(
          LinePoint(
            index: i,
            x: xScale(numValue),
            y: y,
            value: numValue,
            isNull: false,
          ),
        );
      }

      continue;
    }

    final xValue = xDataKey != null ? point[xDataKey] : i;
    final x = xScale(xValue) + xOffset;

    if (numValue == null) {
      points.add(
        LinePoint(index: i, x: x, y: double.nan, value: rawValue, isNull: true),
      );
    } else {
      points.add(
        LinePoint(
          index: i,
          x: x,
          y: yScale(numValue),
          value: numValue,
          isNull: false,
        ),
      );
    }
  }

  return points;
}
