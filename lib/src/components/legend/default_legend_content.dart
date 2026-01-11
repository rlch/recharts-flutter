import 'package:flutter/material.dart';

import '../../core/types/series_types.dart';
import 'legend_entry.dart';
import 'chart_legend.dart';

typedef LegendItemTapCallback = void Function(LegendEntry entry);
typedef LegendContentBuilder = Widget Function(
  List<LegendEntry> entries,
  LegendItemTapCallback onTap,
);

class DefaultLegendContent extends StatelessWidget {
  final List<LegendEntry> entries;
  final ChartLegend config;
  final LegendItemTapCallback? onItemTap;

  const DefaultLegendContent({
    super.key,
    required this.entries,
    required this.config,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    final children = entries.map((entry) {
      return _LegendItem(
        entry: entry,
        config: config,
        onTap: onItemTap != null ? () => onItemTap!(entry) : null,
      );
    }).toList();

    if (config.layout == LegendLayout.horizontal) {
      return Wrap(
        spacing: config.itemGap,
        runSpacing: config.itemGap / 2,
        alignment: _wrapAlignment,
        children: children,
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: _crossAxisAlignment,
        children: children.map((child) {
          return Padding(
            padding: EdgeInsets.only(bottom: config.itemGap / 2),
            child: child,
          );
        }).toList(),
      );
    }
  }

  WrapAlignment get _wrapAlignment {
    switch (config.align) {
      case LegendAlign.left:
        return WrapAlignment.start;
      case LegendAlign.center:
        return WrapAlignment.center;
      case LegendAlign.right:
        return WrapAlignment.end;
    }
  }

  CrossAxisAlignment get _crossAxisAlignment {
    switch (config.align) {
      case LegendAlign.left:
        return CrossAxisAlignment.start;
      case LegendAlign.center:
        return CrossAxisAlignment.center;
      case LegendAlign.right:
        return CrossAxisAlignment.end;
    }
  }
}

class _LegendItem extends StatelessWidget {
  final LegendEntry entry;
  final ChartLegend config;
  final VoidCallback? onTap;

  const _LegendItem({
    required this.entry,
    required this.config,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = config.textColor ?? Colors.black87;
    final effectiveOpacity = entry.visible ? 1.0 : 0.3;

    Widget content = Opacity(
      opacity: effectiveOpacity,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIcon(),
          const SizedBox(width: 4),
          Text(
            entry.name,
            style: TextStyle(
              color: textColor,
              fontSize: config.textSize,
              fontWeight: config.textWeight,
            ),
          ),
        ],
      ),
    );

    if (config.interactive && onTap != null) {
      content = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: content,
        ),
      );
    }

    return content;
  }

  Widget _buildIcon() {
    final size = config.iconSize;
    final color = entry.color;
    final iconType = entry.iconType;

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _LegendIconPainter(
          iconType: iconType,
          color: color,
        ),
      ),
    );
  }
}

class _LegendIconPainter extends CustomPainter {
  final LegendType iconType;
  final Color color;

  _LegendIconPainter({
    required this.iconType,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final center = Offset(size.width / 2, size.height / 2);
    final minDim = size.width < size.height ? size.width : size.height;

    switch (iconType) {
      case LegendType.line:
      case LegendType.plainline:
        paint.strokeWidth = 2;
        paint.style = PaintingStyle.stroke;
        canvas.drawLine(
          Offset(0, center.dy),
          Offset(size.width, center.dy),
          paint,
        );
      case LegendType.square:
        canvas.drawRect(
          Rect.fromLTWH(0, 0, size.width, size.height),
          paint,
        );
      case LegendType.rect:
        final rectHeight = size.height * 0.6;
        final top = (size.height - rectHeight) / 2;
        canvas.drawRect(
          Rect.fromLTWH(0, top, size.width, rectHeight),
          paint,
        );
      case LegendType.circle:
        canvas.drawCircle(center, minDim / 2, paint);
      case LegendType.cross:
        paint.strokeWidth = 2;
        paint.style = PaintingStyle.stroke;
        canvas.drawLine(
          Offset(0, 0),
          Offset(size.width, size.height),
          paint,
        );
        canvas.drawLine(
          Offset(size.width, 0),
          Offset(0, size.height),
          paint,
        );
      case LegendType.diamond:
        final path = Path();
        path.moveTo(center.dx, 0);
        path.lineTo(size.width, center.dy);
        path.lineTo(center.dx, size.height);
        path.lineTo(0, center.dy);
        path.close();
        canvas.drawPath(path, paint);
      case LegendType.star:
        _drawStar(canvas, center, minDim / 2, 5, paint);
      case LegendType.triangle:
        final path = Path();
        path.moveTo(center.dx, 0);
        path.lineTo(size.width, size.height);
        path.lineTo(0, size.height);
        path.close();
        canvas.drawPath(path, paint);
      case LegendType.wye:
        paint.strokeWidth = 2;
        paint.style = PaintingStyle.stroke;
        canvas.drawLine(center, Offset(center.dx, 0), paint);
        canvas.drawLine(center, Offset(0, size.height), paint);
        canvas.drawLine(center, Offset(size.width, size.height), paint);
      case LegendType.none:
        break;
    }
  }

  void _drawStar(
    Canvas canvas,
    Offset center,
    double radius,
    int points,
    Paint paint,
  ) {
    final path = Path();
    final innerRadius = radius * 0.4;
    final angle = 3.14159 / points;

    for (int i = 0; i < points * 2; i++) {
      final r = i.isEven ? radius : innerRadius;
      final a = i * angle - 3.14159 / 2;
      final x = center.dx + r * (i.isEven ? 1 : 0.4) * _cos(a);
      final y = center.dy + r * (i.isEven ? 1 : 0.4) * _sin(a);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  double _cos(double a) => a == 0 ? 1 : (a.abs() < 0.0001 ? 1 : _cosInternal(a));
  double _sin(double a) => a == 0 ? 0 : (a.abs() < 0.0001 ? 0 : _sinInternal(a));
  double _cosInternal(double a) {
    final pi = 3.14159265359;
    a = a % (2 * pi);
    return 1 -
        (a * a) / 2 +
        (a * a * a * a) / 24 -
        (a * a * a * a * a * a) / 720;
  }

  double _sinInternal(double a) {
    final pi = 3.14159265359;
    a = a % (2 * pi);
    return a -
        (a * a * a) / 6 +
        (a * a * a * a * a) / 120 -
        (a * a * a * a * a * a * a) / 5040;
  }

  @override
  bool shouldRepaint(covariant _LegendIconPainter oldDelegate) {
    return iconType != oldDelegate.iconType || color != oldDelegate.color;
  }
}
