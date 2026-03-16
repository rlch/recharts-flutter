import 'dart:ui';

import 'package:flutter/rendering.dart';

import '../series/line_series.dart';
import 'dashed_polyline.dart';
import '../../state/models/computed_data.dart';

class LineSeriesPainter {
  final LineSeries series;
  final List<LinePoint> points;

  LineSeriesPainter({required this.series, required this.points});

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

    final segments = _buildSegments();
    if (segments.isEmpty) return;

    if (series.strokeDasharray != null && series.strokeDasharray!.isNotEmpty) {
      for (final segment in segments) {
        drawDashedPolyline(canvas, segment, paint, series.strokeDasharray!);
      }
      return;
    }

    for (final segment in segments) {
      final path = Path()..moveTo(segment.first.dx, segment.first.dy);
      for (int i = 1; i < segment.length; i++) {
        path.lineTo(segment[i].dx, segment[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  List<List<Offset>> _buildSegments() {
    final segments = <List<Offset>>[];
    var currentSegment = <Offset>[];

    for (final point in points) {
      if (point.isNull) {
        if (!series.connectNulls) {
          if (currentSegment.length > 1) {
            segments.add(currentSegment);
          }
          currentSegment = <Offset>[];
        }
        continue;
      }

      currentSegment.add(point.offset);
    }

    if (currentSegment.length > 1) {
      segments.add(currentSegment);
    }

    return segments;
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
