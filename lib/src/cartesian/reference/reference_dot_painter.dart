import 'package:flutter/rendering.dart';

import '../../core/scale/scale.dart';
import '../../state/models/chart_layout.dart';
import 'reference_dot.dart';

class ReferenceDotPainter {
  final ReferenceDot dot;
  final ChartLayout layout;
  final Scale<dynamic, double> xScale;
  final Scale<dynamic, double> yScale;

  ReferenceDotPainter({
    required this.dot,
    required this.layout,
    required this.xScale,
    required this.yScale,
  });

  void paint(Canvas canvas, Size size) {
    double x = xScale(dot.x);
    final bandwidth = xScale.bandwidth ?? 0;
    if (bandwidth > 0) {
      x += bandwidth / 2;
    }

    final y = yScale(dot.y);

    if (x < layout.plotLeft - dot.r ||
        x > layout.plotRight + dot.r ||
        y < layout.plotTop - dot.r ||
        y > layout.plotBottom + dot.r) {
      return;
    }

    final center = Offset(x, y);

    final fillPaint = Paint()
      ..color = dot.fill
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, dot.r, fillPaint);

    if (dot.stroke != null && dot.strokeWidth > 0) {
      final strokePaint = Paint()
        ..color = dot.stroke!
        ..strokeWidth = dot.strokeWidth
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(center, dot.r, strokePaint);
    }

    if (dot.label != null) {
      _paintLabel(canvas, center);
    }
  }

  void _paintLabel(Canvas canvas, Offset center) {
    final textStyle = TextStyle(
      color: dot.labelColor ?? dot.fill,
      fontSize: dot.labelSize,
    );

    final textSpan = TextSpan(text: dot.label, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    Offset labelOffset;
    final padding = 4.0;

    switch (dot.labelPosition) {
      case ReferenceDotLabelPosition.top:
        labelOffset = Offset(
          center.dx - textPainter.width / 2,
          center.dy - dot.r - textPainter.height - padding,
        );
      case ReferenceDotLabelPosition.right:
        labelOffset = Offset(
          center.dx + dot.r + padding,
          center.dy - textPainter.height / 2,
        );
      case ReferenceDotLabelPosition.bottom:
        labelOffset = Offset(
          center.dx - textPainter.width / 2,
          center.dy + dot.r + padding,
        );
      case ReferenceDotLabelPosition.left:
        labelOffset = Offset(
          center.dx - dot.r - textPainter.width - padding,
          center.dy - textPainter.height / 2,
        );
      case ReferenceDotLabelPosition.center:
        labelOffset = Offset(
          center.dx - textPainter.width / 2,
          center.dy - textPainter.height / 2,
        );
    }

    textPainter.paint(canvas, labelOffset);
  }
}
