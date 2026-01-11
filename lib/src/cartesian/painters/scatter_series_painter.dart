import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/rendering.dart';

import '../series/scatter_series.dart';

class ScatterPoint {
  final int index;
  final double x;
  final double y;
  final double size;
  final dynamic xValue;
  final dynamic yValue;
  final dynamic zValue;

  const ScatterPoint({
    required this.index,
    required this.x,
    required this.y,
    required this.size,
    this.xValue,
    this.yValue,
    this.zValue,
  });

  Offset get offset => Offset(x, y);
}

class ScatterSeriesPainter {
  final ScatterSeries series;
  final List<ScatterPoint> points;

  ScatterSeriesPainter({
    required this.series,
    required this.points,
  });

  void paint(Canvas canvas, Size size) {
    if (series.hide || points.isEmpty) return;

    final fillPaint = Paint()
      ..color = series.fill
      ..style = PaintingStyle.fill;

    final strokePaint = series.stroke != null
        ? (Paint()
          ..color = series.stroke!
          ..strokeWidth = series.strokeWidth
          ..style = PaintingStyle.stroke)
        : null;

    for (final point in points) {
      final path = _createShapePath(point.offset, point.size, series.shape);
      canvas.drawPath(path, fillPaint);
      if (strokePaint != null) {
        canvas.drawPath(path, strokePaint);
      }
    }
  }

  static Path _createShapePath(Offset center, double size, ScatterShape shape) {
    final radius = size / 2;
    switch (shape) {
      case ScatterShape.circle:
        return _createCircle(center, radius);
      case ScatterShape.cross:
        return _createCross(center, radius);
      case ScatterShape.diamond:
        return _createDiamond(center, radius);
      case ScatterShape.square:
        return _createSquare(center, radius);
      case ScatterShape.star:
        return _createStar(center, radius);
      case ScatterShape.triangle:
        return _createTriangle(center, radius);
      case ScatterShape.wye:
        return _createWye(center, radius);
    }
  }

  static Path _createCircle(Offset center, double radius) {
    return Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));
  }

  static Path _createCross(Offset center, double radius) {
    final path = Path();
    final arm = radius * 0.4;
    path.moveTo(center.dx - radius, center.dy - arm);
    path.lineTo(center.dx - arm, center.dy - arm);
    path.lineTo(center.dx - arm, center.dy - radius);
    path.lineTo(center.dx + arm, center.dy - radius);
    path.lineTo(center.dx + arm, center.dy - arm);
    path.lineTo(center.dx + radius, center.dy - arm);
    path.lineTo(center.dx + radius, center.dy + arm);
    path.lineTo(center.dx + arm, center.dy + arm);
    path.lineTo(center.dx + arm, center.dy + radius);
    path.lineTo(center.dx - arm, center.dy + radius);
    path.lineTo(center.dx - arm, center.dy + arm);
    path.lineTo(center.dx - radius, center.dy + arm);
    path.close();
    return path;
  }

  static Path _createDiamond(Offset center, double radius) {
    final path = Path();
    path.moveTo(center.dx, center.dy - radius);
    path.lineTo(center.dx + radius, center.dy);
    path.lineTo(center.dx, center.dy + radius);
    path.lineTo(center.dx - radius, center.dy);
    path.close();
    return path;
  }

  static Path _createSquare(Offset center, double radius) {
    return Path()
      ..addRect(Rect.fromCenter(
        center: center,
        width: radius * 2,
        height: radius * 2,
      ));
  }

  static Path _createStar(Offset center, double radius) {
    final path = Path();
    final innerRadius = radius * 0.4;
    const points = 5;
    const angle = math.pi / points;

    for (int i = 0; i < points * 2; i++) {
      final r = i.isEven ? radius : innerRadius;
      final a = i * angle - math.pi / 2;
      final x = center.dx + r * math.cos(a);
      final y = center.dy + r * math.sin(a);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  static Path _createTriangle(Offset center, double radius) {
    final path = Path();
    final height = radius * 2 * math.sqrt(3) / 2;
    path.moveTo(center.dx, center.dy - height * 2 / 3);
    path.lineTo(center.dx + radius, center.dy + height / 3);
    path.lineTo(center.dx - radius, center.dy + height / 3);
    path.close();
    return path;
  }

  static Path _createWye(Offset center, double radius) {
    final path = Path();
    final arm = radius * 0.35;
    final angles = [
      -math.pi / 2,
      math.pi / 6,
      5 * math.pi / 6,
    ];

    for (final angle in angles) {
      final cos = math.cos(angle);
      final sin = math.sin(angle);
      final perpCos = math.cos(angle + math.pi / 2);
      final perpSin = math.sin(angle + math.pi / 2);

      path.moveTo(
        center.dx + arm * perpCos,
        center.dy + arm * perpSin,
      );
      path.lineTo(
        center.dx + radius * cos + arm * perpCos,
        center.dy + radius * sin + arm * perpSin,
      );
      path.lineTo(
        center.dx + radius * cos - arm * perpCos,
        center.dy + radius * sin - arm * perpSin,
      );
      path.lineTo(
        center.dx - arm * perpCos,
        center.dy - arm * perpSin,
      );
    }
    path.close();
    return path;
  }

  static Path createShapePath(Offset center, double size, ScatterShape shape) {
    return _createShapePath(center, size, shape);
  }
}
