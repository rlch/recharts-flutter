import 'dart:ui';

import 'package:flutter/rendering.dart';

import '../series/bar_series.dart';
import '../../state/models/computed_data.dart';
import '../../core/animation/geometry_interpolation.dart';

class AnimatedBarSeriesPainter {
  final BarSeries series;
  final List<BarRect> currentRects;
  final List<BarRect>? previousRects;
  final double animationProgress;

  AnimatedBarSeriesPainter({
    required this.series,
    required this.currentRects,
    this.previousRects,
    this.animationProgress = 1.0,
  });

  void paint(Canvas canvas, Size size) {
    if (series.hide || currentRects.isEmpty) return;

    final rects = _getAnimatedRects();

    final fillPaint = Paint()
      ..color = series.fill.withValues(alpha: series.fillOpacity)
      ..style = PaintingStyle.fill;

    final strokePaint = series.stroke != null && series.strokeWidth > 0
        ? (Paint()
          ..color = series.stroke!
          ..strokeWidth = series.strokeWidth
          ..style = PaintingStyle.stroke)
        : null;

    for (final rect in rects) {
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

  List<Rect> _getAnimatedRects() {
    final currentRectList = currentRects.map((b) => b.rect).toList();

    if (animationProgress >= 1.0 || previousRects == null) {
      return currentRectList;
    }

    final previousRectList = previousRects!.map((b) => b.rect).toList();

    return interpolateRects(previousRectList, currentRectList, animationProgress);
  }
}
