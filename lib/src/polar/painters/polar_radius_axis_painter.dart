import 'package:flutter/rendering.dart';

import '../polar_layout.dart';
import '../axis/polar_radius_axis.dart';
import '../../core/utils/polar_utils.dart';
import '../../core/utils/cartesian_utils.dart';

class PolarRadiusAxisPainter {
  final PolarRadiusAxis axis;
  final PolarLayout layout;
  final List<num> ticks;
  final double maxValue;

  PolarRadiusAxisPainter({
    required this.axis,
    required this.layout,
    required this.ticks,
    required this.maxValue,
  });

  void paint(Canvas canvas, Size size) {
    if (axis.hide) return;

    if (axis.showAxisLine) {
      _paintAxisLine(canvas);
    }

    _paintTicks(canvas);
  }

  void _paintAxisLine(Canvas canvas) {
    final endPoint = polarToCartesian(
        layout.cx, layout.cy, layout.outerRadius, axis.angle);

    final paint = Paint()
      ..color = axis.axisLineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = axis.axisLineWidth;

    canvas.drawLine(layout.center, Offset(endPoint.x, endPoint.y), paint);
  }

  void _paintTicks(Canvas canvas) {
    if (ticks.isEmpty || maxValue == 0) return;

    final tickPaint = Paint()
      ..color = axis.tickColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = axis.tickStrokeWidth;

    for (final tick in ticks) {
      final radius = layout.outerRadius * (tick / maxValue);
      final point = polarToCartesian(layout.cx, layout.cy, radius, axis.angle);

      final perpAngle = axis.angle + 90;
      final tickStart =
          polarToCartesian(point.x, point.y, axis.tickSize / 2, perpAngle);
      final tickEnd =
          polarToCartesian(point.x, point.y, axis.tickSize / 2, perpAngle + 180);

      canvas.drawLine(
        Offset(tickStart.x, tickStart.y),
        Offset(tickEnd.x, tickEnd.y),
        tickPaint,
      );

      _paintTickLabel(canvas, tick, point);
    }
  }

  void _paintTickLabel(Canvas canvas, num tick, Coordinate point) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: tick.toString(),
        style: TextStyle(
          color: axis.labelColor,
          fontSize: axis.labelFontSize,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final normalizedAngle = ((axis.angle % 360) + 360) % 360;

    double dx = point.x;
    double dy = point.y;

    if (normalizedAngle > 45 && normalizedAngle < 135) {
      dx -= textPainter.width / 2;
      dy -= textPainter.height + 4;
    } else if (normalizedAngle >= 135 && normalizedAngle <= 225) {
      dx -= textPainter.width + 4;
      dy -= textPainter.height / 2;
    } else if (normalizedAngle > 225 && normalizedAngle < 315) {
      dx -= textPainter.width / 2;
      dy += 4;
    } else {
      dx += 4;
      dy -= textPainter.height / 2;
    }

    textPainter.paint(canvas, Offset(dx, dy));
  }
}
