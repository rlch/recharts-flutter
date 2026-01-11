import 'dart:ui';

import 'package:flutter/rendering.dart';

import '../../components/tooltip/tooltip_types.dart';
import '../../state/models/chart_layout.dart';

class CursorPainter {
  final CursorConfig config;
  final ChartLayout layout;
  final double? activeX;
  final List<Offset?> activePoints;
  final List<Color> seriesColors;

  CursorPainter({
    required this.config,
    required this.layout,
    this.activeX,
    this.activePoints = const [],
    this.seriesColors = const [],
  });

  void paint(Canvas canvas, Size size) {
    if (!config.show || activeX == null) return;

    _paintCursorLine(canvas);
    _paintActiveDots(canvas);
  }

  void _paintCursorLine(Canvas canvas) {
    if (activeX == null) return;

    final paint = Paint()
      ..color = config.color
      ..strokeWidth = config.strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(activeX!, layout.plotTop);

    if (config.dashPattern != null && config.dashPattern!.isNotEmpty) {
      _drawDashedLine(
        canvas,
        Offset(activeX!, layout.plotTop),
        Offset(activeX!, layout.plotBottom),
        paint,
        config.dashPattern!,
      );
    } else {
      path.lineTo(activeX!, layout.plotBottom);
      canvas.drawPath(path, paint);
    }
  }

  void _drawDashedLine(
    Canvas canvas,
    Offset start,
    Offset end,
    Paint paint,
    List<double> dashPattern,
  ) {
    final totalLength = (end - start).distance;
    if (totalLength == 0) return;

    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final unitDx = dx / totalLength;
    final unitDy = dy / totalLength;

    double currentLength = 0;
    int dashIndex = 0;
    bool drawing = true;

    while (currentLength < totalLength) {
      final dashLength = dashPattern[dashIndex % dashPattern.length];
      final remaining = totalLength - currentLength;
      final segmentLength = dashLength < remaining ? dashLength : remaining;

      if (drawing) {
        canvas.drawLine(
          Offset(
            start.dx + unitDx * currentLength,
            start.dy + unitDy * currentLength,
          ),
          Offset(
            start.dx + unitDx * (currentLength + segmentLength),
            start.dy + unitDy * (currentLength + segmentLength),
          ),
          paint,
        );
      }

      currentLength += segmentLength;
      dashIndex++;
      drawing = !drawing;
    }
  }

  void _paintActiveDots(Canvas canvas) {
    for (int i = 0; i < activePoints.length; i++) {
      final point = activePoints[i];
      if (point == null) continue;

      final color = i < seriesColors.length ? seriesColors[i] : config.color;

      final fillPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(point, config.activeDotRadius, fillPaint);

      if (config.activeDotStroke != null || config.activeDotStrokeWidth > 0) {
        final strokePaint = Paint()
          ..color = config.activeDotStroke ?? const Color(0xFFFFFFFF)
          ..style = PaintingStyle.stroke
          ..strokeWidth = config.activeDotStrokeWidth;

        canvas.drawCircle(point, config.activeDotRadius, strokePaint);
      }
    }
  }
}
