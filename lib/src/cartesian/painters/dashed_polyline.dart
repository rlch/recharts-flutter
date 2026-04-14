import 'dart:ui';

import 'package:flutter/rendering.dart';

void drawDashedPolyline(
  Canvas canvas,
  List<Offset> points,
  Paint paint,
  List<double> dashArray,
) {
  if (points.length < 2) return;

  final pattern = dashArray.where((segment) => segment > 0).toList();
  if (pattern.isEmpty) {
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, paint);
    return;
  }

  int patternIndex = 0;
  bool isDrawing = true;
  double remainingInPattern = pattern[patternIndex];

  for (int i = 1; i < points.length; i++) {
    final start = points[i - 1];
    final end = points[i];
    final segment = end - start;
    final segmentLength = segment.distance;

    if (segmentLength == 0) continue;

    final unit = segment / segmentLength;
    double traveled = 0;

    while (traveled < segmentLength) {
      final remainingInSegment = segmentLength - traveled;
      final step = remainingInPattern < remainingInSegment
          ? remainingInPattern
          : remainingInSegment;

      if (isDrawing) {
        final drawStart = start + unit * traveled;
        final drawEnd = start + unit * (traveled + step);
        canvas.drawLine(drawStart, drawEnd, paint);
      }

      traveled += step;
      remainingInPattern -= step;

      if (remainingInPattern <= 0.000001) {
        patternIndex = (patternIndex + 1) % pattern.length;
        remainingInPattern = pattern[patternIndex];
        isDrawing = !isDrawing;
      }
    }
  }
}
