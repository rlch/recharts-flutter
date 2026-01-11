import '../../core/types/chart_data.dart';
import '../../polar/polar_layout.dart';
import '../../polar/series/pie_series.dart';
import '../../polar/series/radial_bar_series.dart';
import '../../polar/series/radar_series.dart';
import '../models/polar_data.dart';
import '../../core/utils/polar_utils.dart';

List<SectorGeometry> computePieSectors({
  required ChartDataSet data,
  required PieSeries series,
  required PolarLayout layout,
}) {
  final values = <double>[];
  for (int i = 0; i < data.length; i++) {
    final value = data[i].getNumericValue(series.dataKey) ?? 0;
    values.add(value.abs());
  }

  final total = values.fold<double>(0, (sum, v) => sum + v);
  if (total == 0) return [];

  final sectors = <SectorGeometry>[];
  final angleRange = series.endAngle - series.startAngle;
  var currentAngle = series.startAngle;

  final colors = series.colors ?? defaultPieColors;
  final innerR = series.innerRadius < 1
      ? layout.outerRadius * series.innerRadius
      : series.innerRadius;
  final outerR = series.outerRadius < 1
      ? layout.outerRadius * series.outerRadius
      : series.outerRadius;

  for (int i = 0; i < values.length; i++) {
    final value = values[i];
    final percent = value / total;
    final angleSpan = percent * angleRange;
    final startAngle = currentAngle + series.paddingAngle / 2;
    final endAngle = currentAngle + angleSpan - series.paddingAngle / 2;

    final name = series.nameKey != null
        ? data[i].getStringValue(series.nameKey!)
        : 'Slice $i';

    sectors.add(SectorGeometry(
      index: i,
      cx: layout.cx,
      cy: layout.cy,
      innerRadius: innerR,
      outerRadius: outerR,
      startAngle: startAngle,
      endAngle: endAngle,
      value: value,
      percent: percent,
      name: name,
      color: colors[i % colors.length],
    ));

    currentAngle += angleSpan;
  }

  return sectors;
}

List<RadialBarGeometry> computeRadialBars({
  required ChartDataSet data,
  required RadialBarSeries series,
  required PolarLayout layout,
}) {
  final values = <double>[];
  double maxValue = 0;

  for (int i = 0; i < data.length; i++) {
    final value = data[i].getNumericValue(series.dataKey) ?? 0;
    values.add(value.abs());
    if (value.abs() > maxValue) maxValue = value.abs();
  }

  if (maxValue == 0) return [];

  final bars = <RadialBarGeometry>[];
  final colors = series.colors ?? defaultRadialBarColors;

  final innerR = series.innerRadius < 1
      ? layout.outerRadius * series.innerRadius
      : series.innerRadius;
  final outerR = series.outerRadius < 1
      ? layout.outerRadius * series.outerRadius
      : series.outerRadius;

  final radiusSpan = outerR - innerR;
  final barSize = series.barSize ??
      (data.isEmpty ? radiusSpan : radiusSpan / data.length * 0.8);

  final angleRange = (series.endAngle - series.startAngle).abs();

  for (int i = 0; i < values.length; i++) {
    final value = values[i];
    final percent = value / maxValue;
    final barInnerRadius = innerR + (radiusSpan / data.length) * i;
    final barOuterRadius = barInnerRadius + barSize;

    final angleSpan = percent * angleRange;
    final endAngle = series.startAngle > series.endAngle
        ? series.startAngle - angleSpan
        : series.startAngle + angleSpan;

    final name = series.nameKey != null
        ? data[i].getStringValue(series.nameKey!)
        : 'Bar $i';

    bars.add(RadialBarGeometry(
      index: i,
      cx: layout.cx,
      cy: layout.cy,
      innerRadius: barInnerRadius,
      outerRadius: barOuterRadius,
      startAngle: series.startAngle,
      endAngle: endAngle,
      value: value,
      maxValue: maxValue,
      name: name,
      color: colors[i % colors.length],
    ));
  }

  return bars;
}

List<RadarPoint> computeRadarPoints({
  required ChartDataSet data,
  required RadarSeries series,
  required PolarLayout layout,
  required String angleDataKey,
  double? maxValue,
}) {
  if (data.isEmpty) return [];

  final n = data.length;
  final angleStep = 360.0 / n;
  final points = <RadarPoint>[];

  double computedMax = maxValue ?? 0;
  if (computedMax == 0) {
    for (int i = 0; i < n; i++) {
      final value = data[i].getNumericValue(series.dataKey) ?? 0;
      if (value.abs() > computedMax) computedMax = value.abs();
    }
  }
  if (computedMax == 0) computedMax = 1;

  for (int i = 0; i < n; i++) {
    final value = data[i].getNumericValue(series.dataKey) ?? 0;
    final angle = 90 - i * angleStep;
    final radiusPercent = value / computedMax;
    final radius = layout.outerRadius * radiusPercent;

    final coord = polarToCartesian(layout.cx, layout.cy, radius, angle);

    final name = data[i].getStringValue(angleDataKey);

    points.add(RadarPoint(
      index: i,
      x: coord.x,
      y: coord.y,
      angle: angle,
      radius: radius,
      value: value.toDouble(),
      name: name,
    ));
  }

  return points;
}
