import 'package:flutter/rendering.dart';

import '../../core/scale/scale.dart';
import '../../core/types/axis_types.dart';
import '../axis/x_axis.dart';
import '../axis/y_axis.dart';

class AxisPainter {
  final Scale<dynamic, double> scale;
  final bool isXAxis;
  final bool isLeft;
  final bool isTop;
  final double axisPosition;
  final double plotStart;
  final double plotEnd;
  final int tickCount;
  final Color tickColor;
  final Color labelColor;
  final double tickSize;
  final double tickMargin;
  final String? unit;
  final AxisTickFormatter? tickFormatter;
  final List<dynamic>? ticks;
  final bool hide;

  AxisPainter({
    required this.scale,
    required this.isXAxis,
    this.isLeft = true,
    this.isTop = false,
    required this.axisPosition,
    required this.plotStart,
    required this.plotEnd,
    this.tickCount = 5,
    this.tickColor = const Color(0xFF666666),
    this.labelColor = const Color(0xFF666666),
    this.tickSize = 6,
    this.tickMargin = 3,
    this.unit,
    this.tickFormatter,
    this.ticks,
    this.hide = false,
  });

  factory AxisPainter.fromXAxis({
    required XAxis axis,
    required Scale<dynamic, double> scale,
    required double axisY,
    required double plotLeft,
    required double plotRight,
  }) {
    return AxisPainter(
      scale: scale,
      isXAxis: true,
      isTop: axis.orientation == AxisOrientation.top,
      axisPosition: axisY,
      plotStart: plotLeft,
      plotEnd: plotRight,
      tickCount: axis.tickCount ?? 5,
      ticks: axis.ticks,
      tickMargin: axis.tickMargin ?? 3,
      unit: axis.unit,
      tickFormatter: axis.tickFormatter,
      hide: axis.hide,
    );
  }

  factory AxisPainter.fromYAxis({
    required YAxis axis,
    required Scale<dynamic, double> scale,
    required double axisX,
    required double plotTop,
    required double plotBottom,
  }) {
    return AxisPainter(
      scale: scale,
      isXAxis: false,
      isLeft: axis.orientation == AxisOrientation.left,
      axisPosition: axisX,
      plotStart: plotTop,
      plotEnd: plotBottom,
      tickCount: axis.tickCount ?? 5,
      ticks: axis.ticks,
      tickMargin: axis.tickMargin ?? 3,
      unit: axis.unit,
      tickFormatter: axis.tickFormatter,
      hide: axis.hide,
    );
  }

  void paint(Canvas canvas, Size size) {
    if (hide) return;

    final axisPaint = Paint()
      ..color = tickColor
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    if (isXAxis) {
      _paintXAxis(canvas, axisPaint);
    } else {
      _paintYAxis(canvas, axisPaint);
    }
  }

  void _paintXAxis(Canvas canvas, Paint axisPaint) {
    canvas.drawLine(
      Offset(plotStart, axisPosition),
      Offset(plotEnd, axisPosition),
      axisPaint,
    );

    final ticks = this.ticks ?? scale.ticks(tickCount);
    final bandwidth = scale.bandwidth ?? 0;
    final xOffset = bandwidth / 2;

    // Layout all labels up front so we can detect overlap and stride-skip.
    // Labels are centered on each tick, so two neighbours collide when
    // the sum of their half-widths + gap exceeds the tick spacing.
    const labelGap = 6.0;
    final painters = <TextPainter>[];
    final xs = <double>[];
    for (final tick in ticks) {
      final x = scale(tick) + xOffset;
      final painter = TextPainter(
        text: TextSpan(
          text: _formatLabel(tick),
          style: TextStyle(color: labelColor, fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      painters.add(painter);
      xs.add(x);
    }

    int stride = 1;
    if (painters.length > 1) {
      final plotWidth = plotEnd - plotStart;
      // Use the widest label as the worst-case footprint for stride math.
      var maxWidth = 0.0;
      for (final p in painters) {
        if (p.width > maxWidth) maxWidth = p.width;
      }
      final slotsThatFit = (plotWidth / (maxWidth + labelGap)).floor();
      if (slotsThatFit > 0 && painters.length > slotsThatFit) {
        stride = (painters.length / slotsThatFit).ceil();
      }
    }

    for (var i = 0; i < painters.length; i++) {
      final x = xs[i];
      if (x < plotStart || x > plotEnd) continue;

      final tickStart = isTop ? axisPosition - tickSize : axisPosition;
      final tickEnd = isTop ? axisPosition : axisPosition + tickSize;
      canvas.drawLine(Offset(x, tickStart), Offset(x, tickEnd), axisPaint);

      if (stride > 1 && i % stride != 0) continue;

      final textPainter = painters[i];
      final labelY = isTop
          ? axisPosition - tickSize - tickMargin - textPainter.height
          : axisPosition + tickSize + tickMargin;

      textPainter.paint(canvas, Offset(x - textPainter.width / 2, labelY));
    }
  }

  void _paintYAxis(Canvas canvas, Paint axisPaint) {
    canvas.drawLine(
      Offset(axisPosition, plotStart),
      Offset(axisPosition, plotEnd),
      axisPaint,
    );

    final ticks = this.ticks ?? scale.ticks(tickCount);
    final bandwidth = scale.bandwidth ?? 0;
    final yOffset = bandwidth / 2;

    for (final tick in ticks) {
      final y = scale(tick) + yOffset;
      if (y < plotStart || y > plotEnd) continue;

      final tickStart = isLeft ? axisPosition - tickSize : axisPosition;
      final tickEnd = isLeft ? axisPosition : axisPosition + tickSize;

      canvas.drawLine(Offset(tickStart, y), Offset(tickEnd, y), axisPaint);

      final label = _formatLabel(tick);
      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(color: labelColor, fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      final labelX = isLeft
          ? axisPosition - tickSize - tickMargin - textPainter.width
          : axisPosition + tickSize + tickMargin;

      textPainter.paint(canvas, Offset(labelX, y - textPainter.height / 2));
    }
  }

  String _formatLabel(dynamic value) =>
      formatAxisLabel(value, unit: unit, tickFormatter: tickFormatter);
}

String formatAxisLabel(
  dynamic value, {
  String? unit,
  AxisTickFormatter? tickFormatter,
}) {
  if (tickFormatter != null) {
    return tickFormatter(value);
  }

  if (value is double) {
    if (value == value.toInt()) {
      return '${value.toInt()}${unit ?? ''}';
    }
    return '${value.toStringAsFixed(1)}${unit ?? ''}';
  }
  return '$value${unit ?? ''}';
}
