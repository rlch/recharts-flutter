import 'package:flutter/rendering.dart';

import '../polar_layout.dart';
import '../axis/polar_angle_axis.dart';
import '../../core/utils/polar_utils.dart';

class PolarAngleAxisPainter {
  final PolarAngleAxis axis;
  final PolarLayout layout;
  final List<String> labels;

  PolarAngleAxisPainter({
    required this.axis,
    required this.layout,
    required this.labels,
  });

  void paint(Canvas canvas, Size size) {
    if (axis.hide || labels.isEmpty) return;

    final count = labels.length;
    final angleStep = 360.0 / count;

    final tickPaint = Paint()
      ..color = axis.tickColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = axis.tickStrokeWidth;

    for (int i = 0; i < count; i++) {
      final angle = 90 - i * angleStep;

      final innerPoint =
          polarToCartesian(layout.cx, layout.cy, layout.outerRadius, angle);
      final outerPoint = polarToCartesian(
          layout.cx, layout.cy, layout.outerRadius + axis.tickSize, angle);

      canvas.drawLine(
        Offset(innerPoint.x, innerPoint.y),
        Offset(outerPoint.x, outerPoint.y),
        tickPaint,
      );

      _paintLabel(canvas, labels[i], angle);
    }
  }

  void _paintLabel(Canvas canvas, String label, double angle) {
    final labelRadius = layout.outerRadius + axis.tickSize + axis.labelOffset;
    final labelPoint =
        polarToCartesian(layout.cx, layout.cy, labelRadius, angle);

    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: axis.labelColor,
          fontSize: axis.labelFontSize,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    double dx = labelPoint.x;
    double dy = labelPoint.y;

    final normalizedAngle = ((angle % 360) + 360) % 360;

    if (normalizedAngle > 80 && normalizedAngle < 100) {
      dx -= textPainter.width / 2;
      dy -= textPainter.height;
    } else if (normalizedAngle > 260 && normalizedAngle < 280) {
      dx -= textPainter.width / 2;
    } else if (normalizedAngle >= 0 && normalizedAngle <= 80 ||
        normalizedAngle >= 280 && normalizedAngle <= 360) {
      dy -= textPainter.height / 2;
    } else {
      dx -= textPainter.width;
      dy -= textPainter.height / 2;
    }

    textPainter.paint(canvas, Offset(dx, dy));
  }
}
