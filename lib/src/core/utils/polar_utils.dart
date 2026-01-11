import 'dart:math' as math;

import 'cartesian_utils.dart';

const double radian = math.pi / 180;

double degreeToRadian(double angle) => angle * math.pi / 180;

double radianToDegree(double angleInRadian) => angleInRadian * 180 / math.pi;

Coordinate polarToCartesian(
  double cx,
  double cy,
  double radius,
  double angle,
) {
  return Coordinate(
    cx + math.cos(-radian * angle) * radius,
    cy + math.sin(-radian * angle) * radius,
  );
}

class ChartOffset {
  final double top;
  final double right;
  final double bottom;
  final double left;

  const ChartOffset({
    this.top = 0,
    this.right = 0,
    this.bottom = 0,
    this.left = 0,
  });
}

double getMaxRadius(
  double width,
  double height, [
  ChartOffset offset = const ChartOffset(),
]) {
  return math.min(
        (width - offset.left - offset.right).abs(),
        (height - offset.top - offset.bottom).abs(),
      ) /
      2;
}

double distanceBetweenPoints(Coordinate point, Coordinate anotherPoint) {
  return math.sqrt(
    math.pow(point.x - anotherPoint.x, 2) +
        math.pow(point.y - anotherPoint.y, 2),
  );
}

class GeometrySector {
  final double cx;
  final double cy;
  final double innerRadius;
  final double outerRadius;
  final double startAngle;
  final double endAngle;

  const GeometrySector({
    required this.cx,
    required this.cy,
    required this.innerRadius,
    required this.outerRadius,
    required this.startAngle,
    required this.endAngle,
  });

  GeometrySector copyWith({
    double? cx,
    double? cy,
    double? innerRadius,
    double? outerRadius,
    double? startAngle,
    double? endAngle,
  }) {
    return GeometrySector(
      cx: cx ?? this.cx,
      cy: cy ?? this.cy,
      innerRadius: innerRadius ?? this.innerRadius,
      outerRadius: outerRadius ?? this.outerRadius,
      startAngle: startAngle ?? this.startAngle,
      endAngle: endAngle ?? this.endAngle,
    );
  }
}

({double radius, double? angle, double? angleInRadian}) getAngleOfPoint(
  Coordinate point,
  GeometrySector sector,
) {
  final radius = distanceBetweenPoints(point, Coordinate(sector.cx, sector.cy));

  if (radius <= 0) {
    return (radius: radius, angle: null, angleInRadian: null);
  }

  final cos = (point.x - sector.cx) / radius;
  var angleInRadian = math.acos(cos);

  if (point.y > sector.cy) {
    angleInRadian = 2 * math.pi - angleInRadian;
  }

  return (
    radius: radius,
    angle: radianToDegree(angleInRadian),
    angleInRadian: angleInRadian,
  );
}

({double startAngle, double endAngle}) formatAngleOfSector(
    GeometrySector sector) {
  final startCnt = (sector.startAngle / 360).floor();
  final endCnt = (sector.endAngle / 360).floor();
  final min = math.min(startCnt, endCnt);

  return (
    startAngle: sector.startAngle - min * 360,
    endAngle: sector.endAngle - min * 360,
  );
}

double _reverseFormatAngleOfSector(double angle, GeometrySector sector) {
  final startCnt = (sector.startAngle / 360).floor();
  final endCnt = (sector.endAngle / 360).floor();
  final min = math.min(startCnt, endCnt);
  return angle + min * 360;
}

({double cx, double cy, double innerRadius, double outerRadius, double startAngle, double endAngle, double radius, double angle})? inRangeOfSector(
  Coordinate point,
  GeometrySector sector,
) {
  final angleResult = getAngleOfPoint(point, sector);
  final radius = angleResult.radius;
  final angle = angleResult.angle;

  if (radius < sector.innerRadius || radius > sector.outerRadius) {
    return null;
  }

  if (radius == 0) {
    return (
      cx: sector.cx,
      cy: sector.cy,
      innerRadius: sector.innerRadius,
      outerRadius: sector.outerRadius,
      startAngle: sector.startAngle,
      endAngle: sector.endAngle,
      radius: radius,
      angle: 0,
    );
  }

  if (angle == null) return null;

  final formatted = formatAngleOfSector(sector);
  var formatAngle = angle;
  bool inRange;

  if (formatted.startAngle <= formatted.endAngle) {
    while (formatAngle > formatted.endAngle) {
      formatAngle -= 360;
    }
    while (formatAngle < formatted.startAngle) {
      formatAngle += 360;
    }
    inRange =
        formatAngle >= formatted.startAngle && formatAngle <= formatted.endAngle;
  } else {
    while (formatAngle > formatted.startAngle) {
      formatAngle -= 360;
    }
    while (formatAngle < formatted.endAngle) {
      formatAngle += 360;
    }
    inRange =
        formatAngle >= formatted.endAngle && formatAngle <= formatted.startAngle;
  }

  if (inRange) {
    return (
      cx: sector.cx,
      cy: sector.cy,
      innerRadius: sector.innerRadius,
      outerRadius: sector.outerRadius,
      startAngle: sector.startAngle,
      endAngle: sector.endAngle,
      radius: radius,
      angle: _reverseFormatAngleOfSector(formatAngle, sector),
    );
  }

  return null;
}
