import 'package:flutter/rendering.dart';

import '../../core/scale/scale.dart';
import '../../state/models/chart_layout.dart';
import 'reference_area.dart';

class ReferenceAreaPainter {
  final ReferenceArea area;
  final ChartLayout layout;
  final Scale<dynamic, double> xScale;
  final Scale<dynamic, double> yScale;

  ReferenceAreaPainter({
    required this.area,
    required this.layout,
    required this.xScale,
    required this.yScale,
  });

  void paint(Canvas canvas, Size size) {
    double left = layout.plotLeft;
    double right = layout.plotRight;
    double top = layout.plotTop;
    double bottom = layout.plotBottom;

    if (area.x1 != null) {
      double x1 = xScale(area.x1);
      final bandwidth = xScale.bandwidth ?? 0;
      if (bandwidth > 0) {
        x1 += bandwidth / 2;
      }
      left = x1.clamp(layout.plotLeft, layout.plotRight);
    }

    if (area.x2 != null) {
      double x2 = xScale(area.x2);
      final bandwidth = xScale.bandwidth ?? 0;
      if (bandwidth > 0) {
        x2 += bandwidth / 2;
      }
      right = x2.clamp(layout.plotLeft, layout.plotRight);
    }

    if (area.y1 != null) {
      final y1 = yScale(area.y1);
      bottom = y1.clamp(layout.plotTop, layout.plotBottom);
    }

    if (area.y2 != null) {
      final y2 = yScale(area.y2);
      top = y2.clamp(layout.plotTop, layout.plotBottom);
    }

    if (left > right) {
      final temp = left;
      left = right;
      right = temp;
    }
    if (top > bottom) {
      final temp = top;
      top = bottom;
      bottom = temp;
    }

    final rect = Rect.fromLTRB(left, top, right, bottom);

    final fillPaint = Paint()
      ..color = area.fill.withValues(alpha: area.fillOpacity)
      ..style = PaintingStyle.fill;
    canvas.drawRect(rect, fillPaint);

    if (area.stroke != null && area.strokeWidth > 0) {
      final strokePaint = Paint()
        ..color = area.stroke!
        ..strokeWidth = area.strokeWidth
        ..style = PaintingStyle.stroke;
      canvas.drawRect(rect, strokePaint);
    }

    if (area.label != null) {
      _paintLabel(canvas, rect);
    }
  }

  void _paintLabel(Canvas canvas, Rect rect) {
    final textStyle = TextStyle(
      color: area.labelColor ?? area.fill,
      fontSize: area.labelSize,
    );

    final textSpan = TextSpan(text: area.label, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final labelOffset = Offset(
      rect.center.dx - textPainter.width / 2,
      rect.center.dy - textPainter.height / 2,
    );

    textPainter.paint(canvas, labelOffset);
  }
}
