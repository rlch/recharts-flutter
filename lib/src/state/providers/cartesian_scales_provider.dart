import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/scale/band_scale.dart';
import '../../core/scale/linear_scale.dart';
import '../../core/scale/point_scale.dart';
import '../../core/scale/scale.dart';
import '../../core/types/axis_types.dart';
import '../../core/types/chart_data.dart';
import '../../cartesian/axis/x_axis.dart';
import '../../cartesian/axis/y_axis.dart';
import '../models/chart_layout.dart';
import '../models/cartesian_scales.dart';

class CartesianScalesParams {
  final ChartDataSet data;
  final ChartLayout layout;
  final List<XAxis> xAxes;
  final List<YAxis> yAxes;
  final List<String> yDataKeys;

  const CartesianScalesParams({
    required this.data,
    required this.layout,
    required this.xAxes,
    required this.yAxes,
    required this.yDataKeys,
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
  );
});

CartesianScales buildCartesianScales({
  required ChartDataSet data,
  required ChartLayout layout,
  required List<XAxis> xAxes,
  required List<YAxis> yAxes,
  required List<String> yDataKeys,
}) {
  final xAxis = xAxes.isNotEmpty ? xAxes.first : const XAxis();
  final yAxis = yAxes.isNotEmpty ? yAxes.first : const YAxis();

  final xScale = _buildXScale(
    data: data,
    xAxis: xAxis,
    plotLeft: layout.plotLeft,
    plotRight: layout.plotRight,
  );

  final yScale = _buildYScale(
    data: data,
    yAxis: yAxis,
    plotTop: layout.plotTop,
    plotBottom: layout.plotBottom,
    yDataKeys: yDataKeys,
  );

  final xScales = <String, Scale<dynamic, double>>{};
  final yScales = <String, Scale<dynamic, double>>{};

  for (final axis in xAxes) {
    xScales[axis.id] = _buildXScale(
      data: data,
      xAxis: axis,
      plotLeft: layout.plotLeft,
      plotRight: layout.plotRight,
    );
  }

  for (final axis in yAxes) {
    yScales[axis.id] = _buildYScale(
      data: data,
      yAxis: axis,
      plotTop: layout.plotTop,
      plotBottom: layout.plotBottom,
      yDataKeys: yDataKeys,
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

  final extent = dataKey != null ? data.getExtent(dataKey) : null;
  final domainMin = (xAxis.domain?.firstOrNull as num?)?.toDouble() ??
      extent?.$1 ??
      0;
  final domainMax = (xAxis.domain?.lastOrNull as num?)?.toDouble() ??
      extent?.$2 ??
      1;

  return LinearScale(
    domain: [domainMin, domainMax],
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
}) {
  double? minValue;
  double? maxValue;

  for (final key in yDataKeys) {
    final extent = data.getExtent(key);
    if (extent != null) {
      minValue =
          minValue == null ? extent.$1 : math.min(minValue, extent.$1);
      maxValue =
          maxValue == null ? extent.$2 : math.max(maxValue, extent.$2);
    }
  }

  if (yAxis.dataKey != null) {
    final extent = data.getExtent(yAxis.dataKey!);
    if (extent != null) {
      minValue =
          minValue == null ? extent.$1 : math.min(minValue, extent.$1);
      maxValue =
          maxValue == null ? extent.$2 : math.max(maxValue, extent.$2);
    }
  }

  final domainMin = (yAxis.domain?.firstOrNull as num?)?.toDouble() ??
      minValue ??
      0;
  final domainMax = (yAxis.domain?.lastOrNull as num?)?.toDouble() ??
      maxValue ??
      1;

  final adjustedMin = domainMin > 0 ? 0.0 : domainMin;

  return LinearScale(
    domain: [adjustedMin, domainMax],
    range: yAxis.reversed ? [plotTop, plotBottom] : [plotBottom, plotTop],
    nice: true,
  );
}
