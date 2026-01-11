import 'dart:ui';

import 'package:flutter/rendering.dart';

import '../series/line_series.dart';
import '../../state/models/computed_data.dart';
import '../../core/animation/geometry_interpolation.dart';

class AnimatedLineSeriesPainter {
  final LineSeries series;
  final List<LinePoint> currentPoints;
  final List<LinePoint>? previousPoints;
  final double animationProgress;

  AnimatedLineSeriesPainter({
    required this.series,
    required this.currentPoints,
    this.previousPoints,
    this.animationProgress = 1.0,
  });

  void paint(Canvas canvas, Size size) {
    if (series.hide || currentPoints.isEmpty) return;

    final points = _getAnimatedPoints();

    _paintLine(canvas, points);

    if (series.dot) {
      _paintDots(canvas, points);
    }
  }

  List<Offset> _getAnimatedPoints() {
    final currentOffsets = currentPoints
        .where((p) => !p.isNull)
        .map((p) => p.offset)
        .toList();

    if (animationProgress >= 1.0 || previousPoints == null) {
      return currentOffsets;
    }

    final previousOffsets = previousPoints!
        .where((p) => !p.isNull)
        .map((p) => p.offset)
        .toList();

    return interpolatePoints(previousOffsets, currentOffsets, animationProgress);
  }

  void _paintLine(Canvas canvas, List<Offset> points) {
    if (points.isEmpty) return;

    final paint = Paint()
      ..color = series.stroke
      ..strokeWidth = series.strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);

    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paint);
  }

  void _paintDots(Canvas canvas, List<Offset> points) {
    final dotConfig = series.dotConfig;
    final radius = dotConfig?.radius ?? 4;
    final fill = dotConfig?.fill ?? series.stroke;
    final stroke = dotConfig?.stroke;
    final strokeWidth = dotConfig?.strokeWidth ?? 1;

    final fillPaint = Paint()
      ..color = fill
      ..style = PaintingStyle.fill;

    final strokePaint = stroke != null
        ? (Paint()
          ..color = stroke
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke)
        : null;

    for (final point in points) {
      canvas.drawCircle(point, radius, fillPaint);
      if (strokePaint != null) {
        canvas.drawCircle(point, radius, strokePaint);
      }
    }
  }
}
