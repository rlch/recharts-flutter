import 'dart:ui';

import '../models/polar_data.dart';
import '../../components/tooltip/tooltip_types.dart';

class PolarTooltipEntry extends TooltipEntry {
  final double? percent;

  const PolarTooltipEntry({
    required super.name,
    required super.value,
    required super.color,
    super.unit,
    this.percent,
  });

  @override
  String get formattedValue {
    if (value == null) return '';
    
    String valueStr;
    if (value is double) {
      valueStr = value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2);
    } else {
      valueStr = value.toString();
    }
    
    if (percent != null) {
      return '$valueStr (${(percent! * 100).toStringAsFixed(1)}%)';
    }
    return valueStr;
  }
}

class PolarTooltipPayload extends TooltipPayload {
  final int sectorIndex;
  final double? percent;

  const PolarTooltipPayload({
    required super.index,
    required super.label,
    required super.entries,
    required super.coordinate,
    required this.sectorIndex,
    this.percent,
  });
}

PolarTooltipPayload? buildPieTooltipPayload({
  required List<SectorGeometry> sectors,
  required int sectorIndex,
  required Offset coordinate,
}) {
  if (sectorIndex < 0 || sectorIndex >= sectors.length) return null;

  final sector = sectors[sectorIndex];
  final entry = PolarTooltipEntry(
    name: sector.name ?? 'Slice ${sector.index}',
    value: sector.value,
    color: sector.color,
    percent: sector.percent,
  );

  return PolarTooltipPayload(
    index: sector.index,
    label: sector.name ?? 'Slice ${sector.index}',
    entries: [entry],
    coordinate: coordinate,
    sectorIndex: sectorIndex,
    percent: sector.percent,
  );
}

PolarTooltipPayload? buildRadialBarTooltipPayload({
  required List<RadialBarGeometry> bars,
  required int barIndex,
  required Offset coordinate,
}) {
  if (barIndex < 0 || barIndex >= bars.length) return null;

  final bar = bars[barIndex];
  final entry = PolarTooltipEntry(
    name: bar.name ?? 'Bar ${bar.index}',
    value: bar.value,
    color: bar.color,
    percent: bar.percent,
  );

  return PolarTooltipPayload(
    index: bar.index,
    label: bar.name ?? 'Bar ${bar.index}',
    entries: [entry],
    coordinate: coordinate,
    sectorIndex: barIndex,
    percent: bar.percent,
  );
}

PolarTooltipPayload? buildRadarTooltipPayload({
  required List<RadarPoint> points,
  required int pointIndex,
  required Offset coordinate,
  required Color seriesColor,
  required String seriesName,
}) {
  if (pointIndex < 0 || pointIndex >= points.length) return null;

  final point = points[pointIndex];
  final entry = TooltipEntry(
    name: seriesName,
    value: point.value,
    color: seriesColor,
  );

  return PolarTooltipPayload(
    index: point.index,
    label: point.name ?? 'Point ${point.index}',
    entries: [entry],
    coordinate: coordinate,
    sectorIndex: pointIndex,
  );
}
