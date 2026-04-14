import 'dart:ui';

import 'package:flutter/rendering.dart';

import '../series/area_series.dart';
import '../../state/models/computed_data.dart';

class AreaSeriesPainter {
  final AreaSeries series;
  final List<AreaPoint> points;

  AreaSeriesPainter({required this.series, required this.points});

  void paint(Canvas canvas, Size size) {
    if (series.hide || points.isEmpty) return;

    _paintArea(canvas);
    _paintLine(canvas);

    if (series.dot) {
      _paintDots(canvas);
    }
  }

  void _paintArea(Canvas canvas) {
    final fillPaint = Paint()
      ..color = series.fill.withValues(alpha: series.fillOpacity)
      ..style = PaintingStyle.fill;

    final validPoints = _getValidSegments();

    for (final segment in validPoints) {
      if (segment.isEmpty) continue;

      final path = Path();

      path.moveTo(segment.first.bottomOffset.dx, segment.first.bottomOffset.dy);

      for (final point in segment) {
        path.lineTo(point.x, point.y);
      }

      for (int i = segment.length - 1; i >= 0; i--) {
        path.lineTo(segment[i].bottomOffset.dx, segment[i].bottomOffset.dy);
      }

      path.close();
      canvas.drawPath(path, fillPaint);
    }
  }

  void _paintLine(Canvas canvas) {
    final strokePaint = Paint()
      ..color = series.stroke
      ..strokeWidth = series.strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    bool started = false;

    for (int i = 0; i < points.length; i++) {
      final point = points[i];

      if (point.isNull) {
        if (!series.connectNulls) {
          started = false;
        }
        continue;
      }

      if (!started) {
        path.moveTo(point.x, point.y);
        started = true;
      } else {
        path.lineTo(point.x, point.y);
      }
    }

    canvas.drawPath(path, strokePaint);
  }

  void _paintDots(Canvas canvas) {
    final dotConfig = series.dotConfig;
    final radius = dotConfig?.radius ?? 4;
    final fill = dotConfig?.fill ?? series.stroke;

    final fillPaint = Paint()
      ..color = fill
      ..style = PaintingStyle.fill;

    for (final point in points) {
      if (point.isNull) continue;
      canvas.drawCircle(point.topOffset, radius, fillPaint);
    }
  }

  List<List<AreaPoint>> _getValidSegments() {
    if (series.connectNulls) {
      return [points.where((p) => !p.isNull).toList()];
    }

    final segments = <List<AreaPoint>>[];
    var currentSegment = <AreaPoint>[];

    for (final point in points) {
      if (point.isNull) {
        if (currentSegment.isNotEmpty) {
          segments.add(currentSegment);
          currentSegment = [];
        }
      } else {
        currentSegment.add(point);
      }
    }

    if (currentSegment.isNotEmpty) {
      segments.add(currentSegment);
    }

    return segments;
  }
}
