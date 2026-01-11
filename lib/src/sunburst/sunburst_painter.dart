import 'dart:math' as math;

import 'package:flutter/rendering.dart';

import 'sunburst_node.dart';

class SunburstPainter extends CustomPainter {
  final List<SunburstSector> sectors;
  final Offset center;
  final double animationProgress;
  final int? activeIndex;
  final bool showLabels;
  final Color? stroke;
  final double strokeWidth;

  SunburstPainter({
    required this.sectors,
    required this.center,
    this.animationProgress = 1.0,
    this.activeIndex,
    this.showLabels = true,
    this.stroke,
    this.strokeWidth = 1,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (sectors.isEmpty) return;

    final fillPaint = Paint()..style = PaintingStyle.fill;

    final strokePaint = stroke != null
        ? (Paint()
          ..color = stroke!
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke)
        : (Paint()
          ..color = const Color(0xFFFFFFFF)
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke);

    for (int i = 0; i < sectors.length; i++) {
      final sector = sectors[i];

      if (sector.sweepAngle < 0.001) continue;

      final path = _createSectorPath(sector);

      fillPaint.color = sector.color.withValues(
        alpha: activeIndex == null || activeIndex == i ? 1.0 : 0.5,
      );

      canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, strokePaint);

      if (showLabels && animationProgress >= 0.8 && sector.sweepAngle > 0.15) {
        _drawLabel(canvas, sector);
      }
    }
  }

  Path _createSectorPath(SunburstSector sector) {
    final path = Path();

    final sweepAngle = sector.sweepAngle * animationProgress;
    final innerRadius = sector.innerRadius;
    final outerRadius = sector.innerRadius +
        (sector.outerRadius - sector.innerRadius) * animationProgress;

    final innerStartX = center.dx + innerRadius * math.cos(sector.startAngle);
    final innerStartY = center.dy + innerRadius * math.sin(sector.startAngle);

    path.moveTo(innerStartX, innerStartY);

    path.arcTo(
      Rect.fromCircle(center: center, radius: innerRadius),
      sector.startAngle,
      sweepAngle,
      false,
    );

    final outerEndAngle = sector.startAngle + sweepAngle;
    final outerEndX = center.dx + outerRadius * math.cos(outerEndAngle);
    final outerEndY = center.dy + outerRadius * math.sin(outerEndAngle);

    path.lineTo(outerEndX, outerEndY);

    path.arcTo(
      Rect.fromCircle(center: center, radius: outerRadius),
      outerEndAngle,
      -sweepAngle,
      false,
    );

    path.close();

    return path;
  }

  void _drawLabel(Canvas canvas, SunburstSector sector) {
    final label = sector.node.name;
    if (label == null) return;

    final midAngle = sector.midAngle;
    final midRadius = sector.midRadius;

    final labelX = center.dx + midRadius * math.cos(midAngle);
    final labelY = center.dy + midRadius * math.sin(midAngle);

    final arcLength = sector.sweepAngle * midRadius;
    if (arcLength < 20) return;

    final fontSize = (arcLength / 8).clamp(8.0, 12.0);

    final textStyle = TextStyle(
      color: _getContrastColor(sector.color),
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
    );

    final textSpan = TextSpan(
      text: label,
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout();

    canvas.save();
    canvas.translate(labelX, labelY);

    double rotation = midAngle;
    if (midAngle > math.pi / 2 && midAngle < 3 * math.pi / 2) {
      rotation += math.pi;
    }
    canvas.rotate(rotation);

    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -textPainter.height / 2),
    );

    canvas.restore();
  }

  Color _getContrastColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
  }

  @override
  bool shouldRepaint(covariant SunburstPainter oldDelegate) {
    return oldDelegate.sectors != sectors ||
        oldDelegate.animationProgress != animationProgress ||
        oldDelegate.activeIndex != activeIndex;
  }
}
