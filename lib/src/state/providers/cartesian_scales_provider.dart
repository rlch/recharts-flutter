import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/scale/band_scale.dart';
import '../../core/scale/linear_scale.dart';
import '../../core/scale/point_scale.dart';
import '../../core/scale/scale.dart';
import '../../core/types/axis_types.dart';
import '../../core/types/chart_data.dart';
import '../../core/types/series_types.dart';
import '../../cartesian/axis/x_axis.dart';
import '../../cartesian/axis/y_axis.dart';
import '../../cartesian/series/area_series.dart';
import '../models/chart_layout.dart';
import '../models/cartesian_scales.dart';

class CartesianScalesParams {
  final ChartDataSet data;
  final ChartLayout layout;
  final List<XAxis> xAxes;
  final List<YAxis> yAxes;
  final List<String> yDataKeys;
  final List<AreaSeries> areaSeries;
  final StackOffsetType stackOffset;

  const CartesianScalesParams({
    required this.data,
    required this.layout,
    required this.xAxes,
    required this.yAxes,
    required this.yDataKeys,
    this.areaSeries = const [],
    this.stackOffset = StackOffsetType.none,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartesianScalesParams &&
          data == other.data &&
          layout == other.layout &&
          xAxes.length == other.xAxes.length &&
          yAxes.length == other.yAxes.length;

  @override
  int get hashCode => Object.hash(data, layout, xAxes.length, yAxes.length);
}

final cartesianScalesProvider =
    Provider.family<CartesianScales, CartesianScalesParams>((ref, params) {
      return buildCartesianScales(
        data: params.data,
        layout: params.layout,
        xAxes: params.xAxes,
        yAxes: params.yAxes,
        yDataKeys: params.yDataKeys,
        areaSeries: params.areaSeries,
        stackOffset: params.stackOffset,
      );
    });

CartesianScales buildCartesianScales({
  required ChartDataSet data,
  required ChartLayout layout,
  required List<XAxis> xAxes,
  required List<YAxis> yAxes,
  required List<String> yDataKeys,
  List<AreaSeries> areaSeries = const [],
  StackOffsetType stackOffset = StackOffsetType.none,
}) {
  final xAxis = xAxes.isNotEmpty ? xAxes.first : const XAxis();
  final yAxis = yAxes.isNotEmpty ? yAxes.first : const YAxis();

  final xScale = _buildXScale(
    data: data,
    xAxis: xAxis,
    plotLeft: layout.plotLeft,
    plotRight: layout.plotRight,
    yDataKeys: yDataKeys,
  );

  final yScale = _buildYScale(
    data: data,
    yAxis: yAxis,
    plotTop: layout.plotTop,
    plotBottom: layout.plotBottom,
    yDataKeys: yDataKeys,
    areaSeries: areaSeries,
    stackOffset: stackOffset,
  );

  final xScales = <String, Scale<dynamic, double>>{};
  final yScales = <String, Scale<dynamic, double>>{};

  for (final axis in xAxes) {
    xScales[axis.id] = _buildXScale(
      data: data,
      xAxis: axis,
      plotLeft: layout.plotLeft,
      plotRight: layout.plotRight,
      yDataKeys: yDataKeys,
    );
  }

  for (final axis in yAxes) {
    yScales[axis.id] = _buildYScale(
      data: data,
      yAxis: axis,
      plotTop: layout.plotTop,
      plotBottom: layout.plotBottom,
      yDataKeys: yDataKeys,
      areaSeries: areaSeries,
      stackOffset: stackOffset,
    );
  }

  return CartesianScales(
    xScale: xScale,
    yScale: yScale,
    xScales: xScales,
    yScales: yScales,
  );
}

Scale<dynamic, double> _buildXScale({
  required ChartDataSet data,
  required XAxis xAxis,
  required double plotLeft,
  required double plotRight,
  required List<String> yDataKeys,
}) {
  final dataKey = xAxis.dataKey;
  final isCategory =
      xAxis.type == ScaleType.category || xAxis.type == ScaleType.band;
  final isPoint = xAxis.type == ScaleType.point;

  if (isCategory || isPoint) {
    final domain = dataKey != null
        ? data.getUniqueValues<dynamic>(dataKey)
        : List.generate(data.length, (i) => i);

    if (isPoint) {
      return PointScale(
        domain: domain,
        range: xAxis.reversed ? [plotRight, plotLeft] : [plotLeft, plotRight],
      );
    }

    return BandScale(
      domain: domain,
      range: xAxis.reversed ? [plotRight, plotLeft] : [plotLeft, plotRight],
      paddingInner: 0.1,
      paddingOuter: 0.1,
    );
  }

  double? minValue;
  double? maxValue;

  if (dataKey != null) {
    final extent = data.getExtent(dataKey);
    if (extent != null) {
      minValue = extent.$1;
      maxValue = extent.$2;
    }
  } else {
    for (final key in yDataKeys) {
      final extent = data.getExtent(key);
      if (extent == null) continue;
      minValue = minValue == null ? extent.$1 : math.min(minValue, extent.$1);
      maxValue = maxValue == null ? extent.$2 : math.max(maxValue, extent.$2);
    }
  }

  final domainMin =
      (xAxis.domain?.firstOrNull as num?)?.toDouble() ?? minValue ?? 0;
  final domainMax =
      (xAxis.domain?.lastOrNull as num?)?.toDouble() ?? maxValue ?? 1;
  final adjustedMin = (dataKey == null && domainMin > 0) ? 0.0 : domainMin;

  return LinearScale(
    domain: [adjustedMin, domainMax],
    range: xAxis.reversed ? [plotRight, plotLeft] : [plotLeft, plotRight],
    nice: true,
  );
}

Scale<dynamic, double> _buildYScale({
  required ChartDataSet data,
  required YAxis yAxis,
  required double plotTop,
  required double plotBottom,
  required List<String> yDataKeys,
  required List<AreaSeries> areaSeries,
  required StackOffsetType stackOffset,
}) {
  final isCategory =
      yAxis.type == ScaleType.category || yAxis.type == ScaleType.band;
  final isPoint = yAxis.type == ScaleType.point;

  if (isCategory || isPoint) {
    final domain = yAxis.dataKey != null
        ? data.getUniqueValues<dynamic>(yAxis.dataKey!)
        : List.generate(data.length, (i) => i);

    final range = yAxis.reversed
        ? [plotBottom, plotTop]
        : [plotTop, plotBottom];

    if (isPoint) {
      return PointScale(domain: domain, range: range);
    }

    return BandScale(
      domain: domain,
      range: range,
      paddingInner: 0.1,
      paddingOuter: 0.1,
    );
  }

  double? minValue;
  double? maxValue;

  for (final key in yDataKeys) {
    final extent = data.getExtent(key);
    if (extent != null) {
      minValue = minValue == null ? extent.$1 : math.min(minValue, extent.$1);
      maxValue = maxValue == null ? extent.$2 : math.max(maxValue, extent.$2);
    }
  }

  if (yAxis.dataKey != null) {
    final extent = data.getExtent(yAxis.dataKey!);
    if (extent != null) {
      minValue = minValue == null ? extent.$1 : math.min(minValue, extent.$1);
      maxValue = maxValue == null ? extent.$2 : math.max(maxValue, extent.$2);
    }
  }

  final stackedExtent = _computeStackedAreaExtent(
    data: data,
    areaSeries: areaSeries,
    stackOffset: stackOffset,
  );
  if (stackedExtent != null) {
    minValue = minValue == null
        ? stackedExtent.$1
        : math.min(minValue, stackedExtent.$1);
    maxValue = maxValue == null
        ? stackedExtent.$2
        : math.max(maxValue, stackedExtent.$2);
  }

  if (stackOffset == StackOffsetType.expand && areaSeries.isNotEmpty) {
    minValue = 0;
    maxValue = 1;
  }

  final domainMin =
      (yAxis.domain?.firstOrNull as num?)?.toDouble() ?? minValue ?? 0;
  final domainMax =
      (yAxis.domain?.lastOrNull as num?)?.toDouble() ?? maxValue ?? 1;

  final adjustedMin = domainMin > 0 ? 0.0 : domainMin;

  return LinearScale(
    domain: [adjustedMin, domainMax],
    range: yAxis.reversed ? [plotTop, plotBottom] : [plotBottom, plotTop],
    nice: stackOffset != StackOffsetType.expand,
  );
}

(double, double)? _computeStackedAreaExtent({
  required ChartDataSet data,
  required List<AreaSeries> areaSeries,
  required StackOffsetType stackOffset,
}) {
  if (areaSeries.isEmpty) return null;

  if (stackOffset == StackOffsetType.expand) {
    return (0, 1);
  }

  final stackGroups = <String, List<AreaSeries>>{};
  for (final series in areaSeries) {
    final stackKey = series.stackId ?? '__unstacked__${series.dataKey}';
    stackGroups.putIfAbsent(stackKey, () => <AreaSeries>[]).add(series);
  }

  double minExtent = 0;
  double maxExtent = 0;
  var hasValue = false;

  for (final stackSeries in stackGroups.values) {
    for (int index = 0; index < data.length; index++) {
      double positiveSum = 0;
      double negativeSum = 0;
      var pointHasValue = false;

      for (final series in stackSeries) {
        final value = data[index].getNumericValue(series.dataKey);
        if (value == null || value.isNaN) continue;

        pointHasValue = true;
        if (value >= 0) {
          positiveSum += value;
        } else {
          negativeSum += value;
        }
      }

      if (!pointHasValue) continue;

      hasValue = true;
      minExtent = math.min(minExtent, negativeSum);
      maxExtent = math.max(maxExtent, positiveSum);
    }
  }

  if (!hasValue) return null;
  return (minExtent, maxExtent);
}
