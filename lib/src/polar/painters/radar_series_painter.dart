import 'dart:ui';

import 'package:flutter/rendering.dart';

import '../../state/models/polar_data.dart';
import '../series/radar_series.dart';

class RadarSeriesPainter {
  final RadarSeries series;
  final List<RadarPoint> points;
  final List<RadarPoint>? previousPoints;
  final double animationProgress;

  RadarSeriesPainter({
    required this.series,
    required this.points,
    this.previousPoints,
    this.animationProgress = 1.0,
  });

  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final animatedPoints = _getAnimatedPoints();

    _paintPolygon(canvas, animatedPoints);

    if (series.dot) {
      _paintDots(canvas, animatedPoints);
    }
  }

  List<RadarPoint> _getAnimatedPoints() {
    if (previousPoints == null || animationProgress >= 1.0) {
      if (animationProgress < 1.0) {
        return points.map((point) {
          final animatedX = _lerp(points.first.x, point.x, animationProgress);
          final animatedY = _lerp(points.first.y, point.y, animationProgress);
          return RadarPoint(
            index: point.index,
            x: animatedX,
            y: animatedY,
            angle: point.angle,
            radius: _lerp(0, point.radius, animationProgress),
            value: point.value,
            name: point.name,
          );
        }).toList();
      }
      return points;
    }

    return points.map((point) {
      final prev = previousPoints!.length > point.index
          ? previousPoints![point.index]
          : null;

      if (prev == null) {
        return point;
      }

      return RadarPoint(
        index: point.index,
        x: _lerp(prev.x, point.x, animationProgress),
        y: _lerp(prev.y, point.y, animationProgress),
        angle: point.angle,
        radius: _lerp(prev.radius, point.radius, animationProgress),
        value: point.value,
        name: point.name,
      );
    }).toList();
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;

  void _paintPolygon(Canvas canvas, List<RadarPoint> pts) {
    if (pts.isEmpty) return;

    final path = Path()..moveTo(pts.first.x, pts.first.y);

    for (int i = 1; i < pts.length; i++) {
      path.lineTo(pts[i].x, pts[i].y);
    }
    path.close();

    final fillPaint = Paint()
      ..color = series.fill.withValues(alpha: series.fillOpacity)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, fillPaint);

    final strokePaint = Paint()
      ..color = series.stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = series.strokeWidth
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, strokePaint);
  }

  void _paintDots(Canvas canvas, List<RadarPoint> pts) {
    final dotPaint = Paint()
      ..color = series.stroke
      ..style = PaintingStyle.fill;

    for (final point in pts) {
      canvas.drawCircle(point.offset, series.dotRadius, dotPaint);
    }
  }
}
