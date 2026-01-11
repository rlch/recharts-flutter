import 'package:flutter/rendering.dart';

import 'funnel_series.dart';
import 'funnel_geometry.dart';

class FunnelPainter extends CustomPainter {
  final List<TrapezoidGeometry> trapezoids;
  final FunnelSeries series;
  final double animationProgress;
  final int? activeIndex;

  FunnelPainter({
    required this.trapezoids,
    required this.series,
    this.animationProgress = 1.0,
    this.activeIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (trapezoids.isEmpty) return;

    final fillPaint = Paint()..style = PaintingStyle.fill;

    final strokePaint = series.stroke != null
        ? (Paint()
          ..color = series.stroke!
          ..strokeWidth = series.strokeWidth
          ..style = PaintingStyle.stroke)
        : null;

    for (int i = 0; i < trapezoids.length; i++) {
      final trapezoid = trapezoids[i];

      final animatedTrapezoid = _animateTrapezoid(trapezoid);
      final path = animatedTrapezoid.toPath();

      fillPaint.color = trapezoid.color.withValues(
        alpha: activeIndex == null || activeIndex == i ? 1.0 : 0.4,
      );

      canvas.drawPath(path, fillPaint);
      if (strokePaint != null) {
        canvas.drawPath(path, strokePaint);
      }

      if (series.label && trapezoid.label != null && animationProgress >= 0.8) {
        _drawLabel(canvas, animatedTrapezoid);
      }
    }
  }

  TrapezoidGeometry _animateTrapezoid(TrapezoidGeometry trapezoid) {
    if (animationProgress >= 1.0) return trapezoid;

    final progress = animationProgress;
    return TrapezoidGeometry(
      index: trapezoid.index,
      x: trapezoid.x,
      y: trapezoid.y,
      width: trapezoid.width,
      height: trapezoid.height * progress,
      upperWidth: trapezoid.upperWidth * progress,
      lowerWidth: trapezoid.lowerWidth * progress,
      color: trapezoid.color,
      label: trapezoid.label,
      value: trapezoid.value,
    );
  }

  void _drawLabel(Canvas canvas, TrapezoidGeometry trapezoid) {
    final textStyle = TextStyle(
      color: _getContrastColor(trapezoid.color),
      fontSize: 12,
      fontWeight: FontWeight.w500,
    );

    final textSpan = TextSpan(
      text: trapezoid.label,
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout();

    final center = trapezoid.center;
    final offset = Offset(
      center.dx - textPainter.width / 2,
      center.dy - textPainter.height / 2,
    );

    textPainter.paint(canvas, offset);
  }

  Color _getContrastColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
  }

  @override
  bool shouldRepaint(covariant FunnelPainter oldDelegate) {
    return oldDelegate.trapezoids != trapezoids ||
        oldDelegate.animationProgress != animationProgress ||
        oldDelegate.activeIndex != activeIndex;
  }
}
