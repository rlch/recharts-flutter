import 'dart:ui';

import 'package:flutter/rendering.dart';

import '../../state/models/polar_data.dart';
import '../series/radial_bar_series.dart';
import '../../core/utils/polar_utils.dart';

class RadialBarSeriesPainter {
  final RadialBarSeries series;
  final List<RadialBarGeometry> bars;
  final List<RadialBarGeometry>? previousBars;
  final double animationProgress;

  RadialBarSeriesPainter({
    required this.series,
    required this.bars,
    this.previousBars,
    this.animationProgress = 1.0,
  });

  void paint(Canvas canvas, Size size) {
    if (bars.isEmpty) return;

    for (final bar in bars) {
      if (series.background != null) {
        _paintBackground(canvas, bar);
      }

      final animatedBar = _getAnimatedBar(bar);
      _paintBar(canvas, animatedBar);
    }
  }

  RadialBarGeometry _getAnimatedBar(RadialBarGeometry bar) {
    if (previousBars == null || animationProgress >= 1.0) {
      final startAngle = bar.startAngle;
      final targetEnd = bar.endAngle;
      final animatedEnd = _lerp(startAngle, targetEnd, animationProgress);
      return RadialBarGeometry(
        index: bar.index,
        cx: bar.cx,
        cy: bar.cy,
        innerRadius: bar.innerRadius,
        outerRadius: bar.outerRadius,
        startAngle: bar.startAngle,
        endAngle: animatedEnd,
        value: bar.value,
        maxValue: bar.maxValue,
        name: bar.name,
        color: bar.color,
      );
    }

    final prev =
        previousBars!.length > bar.index ? previousBars![bar.index] : null;

    if (prev == null) {
      return RadialBarGeometry(
        index: bar.index,
        cx: bar.cx,
        cy: bar.cy,
        innerRadius: bar.innerRadius,
        outerRadius: bar.outerRadius,
        startAngle: bar.startAngle,
        endAngle: _lerp(bar.startAngle, bar.endAngle, animationProgress),
        value: bar.value,
        maxValue: bar.maxValue,
        name: bar.name,
        color: bar.color,
      );
    }

    return RadialBarGeometry(
      index: bar.index,
      cx: bar.cx,
      cy: bar.cy,
      innerRadius: _lerp(prev.innerRadius, bar.innerRadius, animationProgress),
      outerRadius: _lerp(prev.outerRadius, bar.outerRadius, animationProgress),
      startAngle: _lerp(prev.startAngle, bar.startAngle, animationProgress),
      endAngle: _lerp(prev.endAngle, bar.endAngle, animationProgress),
      value: bar.value,
      maxValue: bar.maxValue,
      name: bar.name,
      color: bar.color,
    );
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;

  void _paintBackground(Canvas canvas, RadialBarGeometry bar) {
    final fullEndAngle = bar.startAngle > 0
        ? bar.startAngle - 360
        : bar.startAngle + 360;

    final path = _createArcPath(
      bar.cx,
      bar.cy,
      bar.innerRadius,
      bar.outerRadius,
      bar.startAngle,
      fullEndAngle,
    );

    final paint = Paint()
      ..color = series.background!
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  void _paintBar(Canvas canvas, RadialBarGeometry bar) {
    if ((bar.endAngle - bar.startAngle).abs() < 0.1) return;

    final path = _createArcPath(
      bar.cx,
      bar.cy,
      bar.innerRadius,
      bar.outerRadius,
      bar.startAngle,
      bar.endAngle,
    );

    final fillPaint = Paint()
      ..color = bar.color
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, fillPaint);

    if (series.stroke != null && series.strokeWidth > 0) {
      final strokePaint = Paint()
        ..color = series.stroke!
        ..style = PaintingStyle.stroke
        ..strokeWidth = series.strokeWidth;

      canvas.drawPath(path, strokePaint);
    }
  }

  Path _createArcPath(
    double cx,
    double cy,
    double innerRadius,
    double outerRadius,
    double startAngle,
    double endAngle,
  ) {
    final path = Path();

    final startAngleRad = degreeToRadian(startAngle);
    final endAngleRad = degreeToRadian(endAngle);
    final sweepAngle = endAngleRad - startAngleRad;

    final outerStart = polarToCartesian(cx, cy, outerRadius, startAngle);
    path.moveTo(outerStart.x, outerStart.y);

    path.arcTo(
      Rect.fromCircle(center: Offset(cx, cy), radius: outerRadius),
      -startAngleRad,
      -sweepAngle,
      false,
    );

    final innerEnd = polarToCartesian(cx, cy, innerRadius, endAngle);
    path.lineTo(innerEnd.x, innerEnd.y);

    path.arcTo(
      Rect.fromCircle(center: Offset(cx, cy), radius: innerRadius),
      -endAngleRad,
      sweepAngle,
      false,
    );

    path.close();

    return path;
  }
}
