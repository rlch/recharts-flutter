import 'dart:ui';

import '../../core/utils/polar_utils.dart';
import '../../core/utils/cartesian_utils.dart';
import '../models/polar_data.dart';

int? findPieSectorAtPoint(
  Offset point,
  List<SectorGeometry> sectors,
) {
  if (sectors.isEmpty) return null;

  for (final sector in sectors) {
    final geometrySector = GeometrySector(
      cx: sector.cx,
      cy: sector.cy,
      innerRadius: sector.innerRadius,
      outerRadius: sector.outerRadius,
      startAngle: sector.startAngle,
      endAngle: sector.endAngle,
    );

    final result = inRangeOfSector(
      Coordinate(point.dx, point.dy),
      geometrySector,
    );

    if (result != null) {
      return sector.index;
    }
  }

  return null;
}

int? findRadialBarAtPoint(
  Offset point,
  List<RadialBarGeometry> bars,
) {
  if (bars.isEmpty) return null;

  for (final bar in bars) {
    final geometrySector = GeometrySector(
      cx: bar.cx,
      cy: bar.cy,
      innerRadius: bar.innerRadius,
      outerRadius: bar.outerRadius,
      startAngle: bar.startAngle,
      endAngle: bar.endAngle,
    );

    final result = inRangeOfSector(
      Coordinate(point.dx, point.dy),
      geometrySector,
    );

    if (result != null) {
      return bar.index;
    }
  }

  return null;
}

int? findRadarPointAtPoint(
  Offset point,
  List<RadarPoint> points, {
  double hitRadius = 10,
}) {
  if (points.isEmpty) return null;

  double minDistance = double.infinity;
  int? nearestIndex;

  for (final radarPoint in points) {
    final distance = (point - radarPoint.offset).distance;
    if (distance < hitRadius && distance < minDistance) {
      minDistance = distance;
      nearestIndex = radarPoint.index;
    }
  }

  return nearestIndex;
}

bool isPointInPolygon(Offset point, List<RadarPoint> polygon) {
  if (polygon.length < 3) return false;

  bool inside = false;
  int j = polygon.length - 1;

  for (int i = 0; i < polygon.length; i++) {
    final xi = polygon[i].x;
    final yi = polygon[i].y;
    final xj = polygon[j].x;
    final yj = polygon[j].y;

    if (((yi > point.dy) != (yj > point.dy)) &&
        (point.dx < (xj - xi) * (point.dy - yi) / (yj - yi) + xi)) {
      inside = !inside;
    }
    j = i;
  }

  return inside;
}
