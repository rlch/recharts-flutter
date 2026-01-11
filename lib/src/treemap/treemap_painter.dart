import 'package:flutter/rendering.dart';

import 'treemap_node.dart';

class TreemapPainter extends CustomPainter {
  final List<TreemapRect> rects;
  final double animationProgress;
  final int? activeIndex;
  final bool showLabels;
  final Color? stroke;
  final double strokeWidth;
  final double padding;

  TreemapPainter({
    required this.rects,
    this.animationProgress = 1.0,
    this.activeIndex,
    this.showLabels = true,
    this.stroke,
    this.strokeWidth = 1,
    this.padding = 2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (rects.isEmpty) return;

    final fillPaint = Paint()..style = PaintingStyle.fill;

    final strokePaint = stroke != null
        ? (Paint()
          ..color = stroke!
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke)
        : null;

    for (int i = 0; i < rects.length; i++) {
      final treemapRect = rects[i];
      final rect = _applyPadding(treemapRect.rect);

      if (rect.width <= 0 || rect.height <= 0) continue;

      final animatedRect = _animateRect(rect);

      fillPaint.color = treemapRect.color.withValues(
        alpha: activeIndex == null || activeIndex == i ? 1.0 : 0.5,
      );

      final rrect = RRect.fromRectAndRadius(animatedRect, const Radius.circular(2));
      canvas.drawRRect(rrect, fillPaint);

      if (strokePaint != null) {
        canvas.drawRRect(rrect, strokePaint);
      }

      if (showLabels && animationProgress >= 0.8) {
        _drawLabel(canvas, animatedRect, treemapRect);
      }
    }
  }

  Rect _applyPadding(Rect rect) {
    return Rect.fromLTWH(
      rect.left + padding / 2,
      rect.top + padding / 2,
      rect.width - padding,
      rect.height - padding,
    );
  }

  Rect _animateRect(Rect rect) {
    if (animationProgress >= 1.0) return rect;

    final center = rect.center;
    final width = rect.width * animationProgress;
    final height = rect.height * animationProgress;

    return Rect.fromCenter(
      center: center,
      width: width,
      height: height,
    );
  }

  void _drawLabel(Canvas canvas, Rect rect, TreemapRect treemapRect) {
    final label = treemapRect.node.name;
    if (label == null) return;

    final minDimension = rect.width < rect.height ? rect.width : rect.height;
    if (minDimension < 30) return;

    final fontSize = (minDimension / 6).clamp(8.0, 14.0);

    final textStyle = TextStyle(
      color: _getContrastColor(treemapRect.color),
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
      maxLines: 2,
      ellipsis: '…',
    );

    textPainter.layout(maxWidth: rect.width - 8);

    if (textPainter.width > rect.width - 4 || textPainter.height > rect.height - 4) {
      return;
    }

    final offset = Offset(
      rect.center.dx - textPainter.width / 2,
      rect.center.dy - textPainter.height / 2,
    );

    textPainter.paint(canvas, offset);
  }

  Color _getContrastColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
  }

  @override
  bool shouldRepaint(covariant TreemapPainter oldDelegate) {
    return oldDelegate.rects != rects ||
        oldDelegate.animationProgress != animationProgress ||
        oldDelegate.activeIndex != activeIndex;
  }
}
