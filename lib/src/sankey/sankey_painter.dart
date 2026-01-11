import 'package:flutter/rendering.dart';

import 'sankey_data.dart';

class SankeyPainter extends CustomPainter {
  final List<SankeyNodeGeometry> nodes;
  final List<SankeyLinkGeometry> links;
  final double nodeWidth;
  final double animationProgress;
  final int? activeNodeIndex;
  final int? activeLinkIndex;
  final bool showLabels;
  final Color? nodeStroke;
  final double nodeStrokeWidth;

  SankeyPainter({
    required this.nodes,
    required this.links,
    this.nodeWidth = 24,
    this.animationProgress = 1.0,
    this.activeNodeIndex,
    this.activeLinkIndex,
    this.showLabels = true,
    this.nodeStroke,
    this.nodeStrokeWidth = 1,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _paintLinks(canvas);
    _paintNodes(canvas);
  }

  void _paintLinks(Canvas canvas) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    for (int i = 0; i < links.length; i++) {
      final link = links[i];

      final isActive = activeLinkIndex == null || activeLinkIndex == i;
      final isNodeActive = activeNodeIndex != null &&
          (nodes[activeNodeIndex!].node.id == link.link.source ||
              nodes[activeNodeIndex!].node.id == link.link.target);

      final alpha = (activeLinkIndex == null && activeNodeIndex == null) ||
              isActive ||
              isNodeActive
          ? 0.5
          : 0.15;

      paint.color = link.color.withValues(alpha: alpha * animationProgress);

      final path = _createLinkPath(link);
      canvas.drawPath(path, paint);
    }
  }

  Path _createLinkPath(SankeyLinkGeometry link) {
    final path = Path();

    final sourceX = link.sourceNode.x + nodeWidth;
    final targetX = link.targetNode.x;
    final sourceY = link.sourceY;
    final targetY = link.targetY;
    final thickness = link.thickness * animationProgress;

    final controlX1 = sourceX + (targetX - sourceX) * 0.5;
    final controlX2 = sourceX + (targetX - sourceX) * 0.5;

    path.moveTo(sourceX, sourceY - thickness / 2);

    path.cubicTo(
      controlX1,
      sourceY - thickness / 2,
      controlX2,
      targetY - thickness / 2,
      targetX,
      targetY - thickness / 2,
    );

    path.lineTo(targetX, targetY + thickness / 2);

    path.cubicTo(
      controlX2,
      targetY + thickness / 2,
      controlX1,
      sourceY + thickness / 2,
      sourceX,
      sourceY + thickness / 2,
    );

    path.close();

    return path;
  }

  void _paintNodes(Canvas canvas) {
    final fillPaint = Paint()..style = PaintingStyle.fill;

    final strokePaint = nodeStroke != null
        ? (Paint()
          ..color = nodeStroke!
          ..strokeWidth = nodeStrokeWidth
          ..style = PaintingStyle.stroke)
        : null;

    for (int i = 0; i < nodes.length; i++) {
      final node = nodes[i];

      final isActive = activeNodeIndex == null || activeNodeIndex == i;
      fillPaint.color = node.color.withValues(
        alpha: isActive ? 1.0 : 0.5,
      );

      final rect = Rect.fromLTWH(
        node.x,
        node.y,
        nodeWidth,
        node.height * animationProgress,
      );

      final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(2));

      canvas.drawRRect(rrect, fillPaint);
      if (strokePaint != null) {
        canvas.drawRRect(rrect, strokePaint);
      }

      if (showLabels && animationProgress >= 0.8) {
        _drawLabel(canvas, node, i);
      }
    }
  }

  void _drawLabel(Canvas canvas, SankeyNodeGeometry node, int index) {
    final label = node.node.name ?? node.node.id;

    final isLeftSide = node.layer == 0;

    final textStyle = TextStyle(
      color: const Color(0xFF333333),
      fontSize: 11,
      fontWeight: FontWeight.w500,
    );

    final textSpan = TextSpan(
      text: label,
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    double x;
    if (isLeftSide) {
      x = node.x - textPainter.width - 4;
      if (x < 0) {
        x = node.x + nodeWidth + 4;
      }
    } else {
      x = node.x + nodeWidth + 4;
    }

    final y = node.y + (node.height * animationProgress - textPainter.height) / 2;

    textPainter.paint(canvas, Offset(x, y));
  }

  @override
  bool shouldRepaint(covariant SankeyPainter oldDelegate) {
    return oldDelegate.nodes != nodes ||
        oldDelegate.links != links ||
        oldDelegate.animationProgress != animationProgress ||
        oldDelegate.activeNodeIndex != activeNodeIndex ||
        oldDelegate.activeLinkIndex != activeLinkIndex;
  }
}
