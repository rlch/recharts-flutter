import 'dart:ui';

import 'package:flutter/rendering.dart';

import '../grid/cartesian_grid.dart';
import '../../state/models/chart_layout.dart';

class GridPainter {
  final CartesianGrid grid;
  final ChartLayout layout;
  final List<double> horizontalLines;
  final List<double> verticalLines;

  GridPainter({
    required this.grid,
    required this.layout,
    required this.horizontalLines,
    required this.verticalLines,
  });

  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = grid.stroke.withValues(alpha: grid.strokeOpacity)
      ..strokeWidth = grid.strokeWidth
      ..style = PaintingStyle.stroke;

    if (grid.strokeDasharray != null && grid.strokeDasharray!.isNotEmpty) {
      _paintDashedLines(canvas, paint);
    } else {
      _paintSolidLines(canvas, paint);
    }

    _paintFills(canvas);
  }

  void _paintSolidLines(Canvas canvas, Paint paint) {
    if (grid.horizontal) {
      for (final y in horizontalLines) {
        if (y >= layout.plotTop && y <= layout.plotBottom) {
          canvas.drawLine(
            Offset(layout.plotLeft, y),
            Offset(layout.plotRight, y),
            paint,
          );
        }
      }
    }

    if (grid.vertical) {
      for (final x in verticalLines) {
        if (x >= layout.plotLeft && x <= layout.plotRight) {
          canvas.drawLine(
            Offset(x, layout.plotTop),
            Offset(x, layout.plotBottom),
            paint,
          );
        }
      }
    }
  }

  void _paintDashedLines(Canvas canvas, Paint paint) {
    final dash = grid.strokeDasharray!;

    if (grid.horizontal) {
      for (final y in horizontalLines) {
        if (y >= layout.plotTop && y <= layout.plotBottom) {
          _drawDashedLine(
            canvas,
            Offset(layout.plotLeft, y),
            Offset(layout.plotRight, y),
            paint,
            dash,
          );
        }
      }
    }

    if (grid.vertical) {
      for (final x in verticalLines) {
        if (x >= layout.plotLeft && x <= layout.plotRight) {
          _drawDashedLine(
            canvas,
            Offset(x, layout.plotTop),
            Offset(x, layout.plotBottom),
            paint,
            dash,
          );
        }
      }
    }
  }

  void _drawDashedLine(
    Canvas canvas,
    Offset start,
    Offset end,
    Paint paint,
    List<double> dashArray,
  ) {
    final path = Path();
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final distance = (dx * dx + dy * dy);
    if (distance == 0) return;

    final length = distance > 0 ? (dx.abs() + dy.abs()).abs() : 0.0;
    final unitX = dx / length;
    final unitY = dy / length;

    var currentX = start.dx;
    var currentY = start.dy;
    var dashIndex = 0;
    var draw = true;
    var remaining = length;

    while (remaining > 0) {
      final dashLength = dashArray[dashIndex % dashArray.length];
      final segmentLength = dashLength < remaining ? dashLength : remaining;

      final nextX = currentX + unitX * segmentLength;
      final nextY = currentY + unitY * segmentLength;

      if (draw) {
        path.moveTo(currentX, currentY);
        path.lineTo(nextX, nextY);
      }

      currentX = nextX;
      currentY = nextY;
      remaining -= segmentLength;
      draw = !draw;
      dashIndex++;
    }

    canvas.drawPath(path, paint);
  }

  void _paintFills(Canvas canvas) {
    if (grid.horizontalFills != null && grid.horizontalFills!.isNotEmpty) {
      final fills = grid.horizontalFills!;
      final sortedY = List<double>.from(horizontalLines)..sort();

      for (int i = 0; i < sortedY.length - 1; i++) {
        final fillPaint = Paint()
          ..color = fills[i % fills.length]
          ..style = PaintingStyle.fill;

        canvas.drawRect(
          Rect.fromLTRB(
            layout.plotLeft,
            sortedY[i],
            layout.plotRight,
            sortedY[i + 1],
          ),
          fillPaint,
        );
      }
    }

    if (grid.verticalFills != null && grid.verticalFills!.isNotEmpty) {
      final fills = grid.verticalFills!;
      final sortedX = List<double>.from(verticalLines)..sort();

      for (int i = 0; i < sortedX.length - 1; i++) {
        final fillPaint = Paint()
          ..color = fills[i % fills.length]
          ..style = PaintingStyle.fill;

        canvas.drawRect(
          Rect.fromLTRB(
            sortedX[i],
            layout.plotTop,
            sortedX[i + 1],
            layout.plotBottom,
          ),
          fillPaint,
        );
      }
    }
  }
}
