import 'dart:ui';

import 'package:flutter/rendering.dart';

import '../series/bar_series.dart';
import '../../state/models/computed_data.dart';

class BarSeriesPainter {
  final BarSeries series;
  final List<BarRect> rects;

  BarSeriesPainter({
    required this.series,
    required this.rects,
  });

  void paint(Canvas canvas, Size size) {
    if (series.hide || rects.isEmpty) return;

    final fillPaint = Paint()
      ..color = series.fill.withValues(alpha: series.fillOpacity)
      ..style = PaintingStyle.fill;

    final strokePaint = series.stroke != null && series.strokeWidth > 0
        ? (Paint()
          ..color = series.stroke!
          ..strokeWidth = series.strokeWidth
          ..style = PaintingStyle.stroke)
        : null;

    for (final bar in rects) {
      final rect = bar.rect;

      if (series.radius != null && series.radius! > 0) {
        final rrect = RRect.fromRectAndRadius(
          rect,
          Radius.circular(series.radius!),
        );
        canvas.drawRRect(rrect, fillPaint);
        if (strokePaint != null) {
          canvas.drawRRect(rrect, strokePaint);
        }
      } else {
        canvas.drawRect(rect, fillPaint);
        if (strokePaint != null) {
          canvas.drawRect(rect, strokePaint);
        }
      }
    }
  }
}
