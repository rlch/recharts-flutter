import 'dart:ui';

import 'package:flutter/rendering.dart';

import '../series/line_series.dart';
import '../../state/models/computed_data.dart';

class LineSeriesPainter {
  final LineSeries series;
  final List<LinePoint> points;

  LineSeriesPainter({
    required this.series,
    required this.points,
  });

  void paint(Canvas canvas, Size size) {
    if (series.hide || points.isEmpty) return;

    _paintLine(canvas);

    if (series.dot) {
      _paintDots(canvas);
    }
  }

  void _paintLine(Canvas canvas) {
    final paint = Paint()
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

    canvas.drawPath(path, paint);
  }

  void _paintDots(Canvas canvas) {
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
      if (point.isNull) continue;

      canvas.drawCircle(point.offset, radius, fillPaint);
      if (strokePaint != null) {
        canvas.drawCircle(point.offset, radius, strokePaint);
      }
    }
  }
}
