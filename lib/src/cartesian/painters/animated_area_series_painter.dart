import 'dart:ui';

import 'package:flutter/rendering.dart';

import '../series/area_series.dart';
import '../../state/models/computed_data.dart';
import '../../core/animation/geometry_interpolation.dart';

class AnimatedAreaSeriesPainter {
  final AreaSeries series;
  final List<AreaPoint> currentPoints;
  final List<AreaPoint>? previousPoints;
  final double animationProgress;

  AnimatedAreaSeriesPainter({
    required this.series,
    required this.currentPoints,
    this.previousPoints,
    this.animationProgress = 1.0,
  });

  void paint(Canvas canvas, Size size) {
    if (series.hide || currentPoints.isEmpty) return;

    final animatedData = _getAnimatedAreaData();

    _paintArea(canvas, animatedData);
    _paintLine(canvas, animatedData.topPoints);

    if (series.dot) {
      _paintDots(canvas, animatedData.topPoints);
    }
  }

  AnimatedAreaData _getAnimatedAreaData() {
    final currentValid = currentPoints.where((p) => !p.isNull).toList();
    final currentTop = currentValid.map((p) => p.topOffset).toList();
    final currentBottom = currentValid.map((p) => p.bottomOffset).toList();

    if (animationProgress >= 1.0 || previousPoints == null) {
      return AnimatedAreaData(
        topPoints: currentTop,
        bottomPoints: currentBottom,
      );
    }

    final previousValid = previousPoints!.where((p) => !p.isNull).toList();
    final previousTop = previousValid.map((p) => p.topOffset).toList();
    final previousBottom = previousValid.map((p) => p.bottomOffset).toList();

    return interpolateAreaPoints(
      AnimatedAreaData(topPoints: previousTop, bottomPoints: previousBottom),
      AnimatedAreaData(topPoints: currentTop, bottomPoints: currentBottom),
      animationProgress,
    );
  }

  void _paintArea(Canvas canvas, AnimatedAreaData data) {
    if (data.topPoints.isEmpty) return;

    final fillPaint = Paint()
      ..color = series.fill.withValues(alpha: series.fillOpacity)
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(data.bottomPoints.first.dx, data.bottomPoints.first.dy);

    for (final point in data.topPoints) {
      path.lineTo(point.dx, point.dy);
    }

    for (int i = data.bottomPoints.length - 1; i >= 0; i--) {
      path.lineTo(data.bottomPoints[i].dx, data.bottomPoints[i].dy);
    }

    path.close();
    canvas.drawPath(path, fillPaint);
  }

  void _paintLine(Canvas canvas, List<Offset> points) {
    if (points.isEmpty) return;

    final strokePaint = Paint()
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

    canvas.drawPath(path, strokePaint);
  }

  void _paintDots(Canvas canvas, List<Offset> points) {
    final dotConfig = series.dotConfig;
    final radius = dotConfig?.radius ?? 4;
    final fill = dotConfig?.fill ?? series.stroke;

    final fillPaint = Paint()
      ..color = fill
      ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point, radius, fillPaint);
    }
  }
}
