import 'package:flutter/rendering.dart';

import '../../core/scale/scale.dart';
import '../../state/models/chart_layout.dart';
import 'reference_line.dart';

class ReferenceLinePainter {
  final ReferenceLine line;
  final ChartLayout layout;
  final Scale<dynamic, double> xScale;
  final Scale<dynamic, double> yScale;

  ReferenceLinePainter({
    required this.line,
    required this.layout,
    required this.xScale,
    required this.yScale,
  });

  void paint(Canvas canvas, Size size) {
    final orientation = line.effectiveOrientation;

    Offset start;
    Offset end;

    if (orientation == ReferenceLineOrientation.horizontal) {
      if (line.y == null) return;

      final y = yScale(line.y);
      if (y < layout.plotTop || y > layout.plotBottom) return;

      start = Offset(layout.plotLeft, y);
      end = Offset(layout.plotRight, y);
    } else {
      if (line.x == null) return;

      double x = xScale(line.x);
      final bandwidth = xScale.bandwidth ?? 0;
      if (bandwidth > 0) {
        x += bandwidth / 2;
      }

      if (x < layout.plotLeft || x > layout.plotRight) return;

      start = Offset(x, layout.plotTop);
      end = Offset(x, layout.plotBottom);
    }

    final paint = Paint()
      ..color = line.stroke
      ..strokeWidth = line.strokeWidth
      ..style = PaintingStyle.stroke;

    if (line.strokeDasharray != null && line.strokeDasharray!.isNotEmpty) {
      _drawDashedLine(canvas, start, end, paint, line.strokeDasharray!);
    } else {
      canvas.drawLine(start, end, paint);
    }

    if (line.label != null) {
      _paintLabel(canvas, start, end, orientation);
    }
  }

  void _drawDashedLine(
    Canvas canvas,
    Offset start,
    Offset end,
    Paint paint,
    List<double> dashArray,
  ) {
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final distance = (dx * dx + dy * dy);
    final length = distance > 0 ? _sqrt(distance) : 0;
    if (length == 0) return;

    final unitX = dx / length;
    final unitY = dy / length;

    double drawn = 0;
    int dashIndex = 0;
    bool isDrawing = true;

    while (drawn < length) {
      final dashLength = dashArray[dashIndex % dashArray.length];
      final remaining = length - drawn;
      final segment = dashLength < remaining ? dashLength : remaining;

      if (isDrawing) {
        canvas.drawLine(
          Offset(start.dx + unitX * drawn, start.dy + unitY * drawn),
          Offset(
            start.dx + unitX * (drawn + segment),
            start.dy + unitY * (drawn + segment),
          ),
          paint,
        );
      }

      drawn += segment;
      dashIndex++;
      isDrawing = !isDrawing;
    }
  }

  double _sqrt(double value) {
    if (value <= 0) return 0;
    double guess = value / 2;
    for (int i = 0; i < 20; i++) {
      guess = (guess + value / guess) / 2;
    }
    return guess;
  }

  void _paintLabel(
    Canvas canvas,
    Offset start,
    Offset end,
    ReferenceLineOrientation orientation,
  ) {
    final textStyle = TextStyle(
      color: line.labelColor ?? line.stroke,
      fontSize: line.labelSize,
    );

    final textSpan = TextSpan(text: line.label, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    Offset labelOffset;

    switch (line.labelPosition) {
      case ReferenceLineLabelPosition.start:
        if (orientation == ReferenceLineOrientation.horizontal) {
          labelOffset = Offset(
            start.dx - textPainter.width - 4,
            start.dy - textPainter.height / 2,
          );
        } else {
          labelOffset = Offset(
            start.dx - textPainter.width / 2,
            start.dy - textPainter.height - 4,
          );
        }
      case ReferenceLineLabelPosition.center:
        if (orientation == ReferenceLineOrientation.horizontal) {
          labelOffset = Offset(
            (start.dx + end.dx) / 2 - textPainter.width / 2,
            start.dy - textPainter.height - 4,
          );
        } else {
          labelOffset = Offset(
            start.dx + 4,
            (start.dy + end.dy) / 2 - textPainter.height / 2,
          );
        }
      case ReferenceLineLabelPosition.end:
        if (orientation == ReferenceLineOrientation.horizontal) {
          labelOffset = Offset(
            end.dx + 4,
            end.dy - textPainter.height / 2,
          );
        } else {
          labelOffset = Offset(
            end.dx - textPainter.width / 2,
            end.dy + 4,
          );
        }
      case ReferenceLineLabelPosition.insideStart:
        if (orientation == ReferenceLineOrientation.horizontal) {
          labelOffset = Offset(
            start.dx + 4,
            start.dy - textPainter.height - 4,
          );
        } else {
          labelOffset = Offset(
            start.dx + 4,
            start.dy + 4,
          );
        }
      case ReferenceLineLabelPosition.insideEnd:
        if (orientation == ReferenceLineOrientation.horizontal) {
          labelOffset = Offset(
            end.dx - textPainter.width - 4,
            end.dy - textPainter.height - 4,
          );
        } else {
          labelOffset = Offset(
            end.dx + 4,
            end.dy - textPainter.height - 4,
          );
        }
    }

    textPainter.paint(canvas, labelOffset);
  }
}
