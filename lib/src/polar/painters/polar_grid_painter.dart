import 'dart:ui';

import 'package:flutter/rendering.dart';

import '../polar_layout.dart';
import '../grid/polar_grid.dart';
import '../../core/utils/polar_utils.dart';

class PolarGridPainter {
  final PolarGrid grid;
  final PolarLayout layout;
  final int dataPointCount;

  PolarGridPainter({
    required this.grid,
    required this.layout,
    required this.dataPointCount,
  });

  void paint(Canvas canvas, Size size) {
    _paintConcentricShapes(canvas);

    if (grid.showRadialLines) {
      _paintRadialLines(canvas);
    }
  }

  void _paintConcentricShapes(Canvas canvas) {
    final count = grid.concentricCircleCount ?? 5;
    if (count <= 0) return;

    final paint = Paint()
      ..color = grid.strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = grid.strokeWidth;

    for (int i = 1; i <= count; i++) {
      final radius = layout.outerRadius * (i / count);

      if (grid.gridType == PolarGridType.circle) {
        canvas.drawCircle(layout.center, radius, paint);
      } else {
        _paintPolygon(canvas, radius, paint);
      }
    }
  }

  void _paintPolygon(Canvas canvas, double radius, Paint paint) {
    final sides = grid.radialLineCount ?? dataPointCount;
    if (sides < 3) return;

    final path = Path();
    final angleStep = 360.0 / sides;

    for (int i = 0; i <= sides; i++) {
      final angle = 90 - i * angleStep;
      final point = polarToCartesian(layout.cx, layout.cy, radius, angle);

      if (i == 0) {
        path.moveTo(point.x, point.y);
      } else {
        path.lineTo(point.x, point.y);
      }
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  void _paintRadialLines(Canvas canvas) {
    final count = grid.radialLineCount ?? dataPointCount;
    if (count < 2) return;

    final paint = Paint()
      ..color = grid.radialLineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = grid.radialLineWidth;

    final angleStep = 360.0 / count;

    for (int i = 0; i < count; i++) {
      final angle = 90 - i * angleStep;
      final endPoint =
          polarToCartesian(layout.cx, layout.cy, layout.outerRadius, angle);

      canvas.drawLine(layout.center, Offset(endPoint.x, endPoint.y), paint);
    }
  }
}
