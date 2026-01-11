import 'dart:ui';

class ReferenceDot {
  final dynamic x;
  final dynamic y;
  final double r;
  final Color fill;
  final Color? stroke;
  final double strokeWidth;
  final String? label;
  final Color? labelColor;
  final double labelSize;
  final ReferenceDotLabelPosition labelPosition;
  final bool isFront;
  final String? xAxisId;
  final String? yAxisId;

  const ReferenceDot({
    required this.x,
    required this.y,
    this.r = 10,
    this.fill = const Color(0xFF8884d8),
    this.stroke,
    this.strokeWidth = 0,
    this.label,
    this.labelColor,
    this.labelSize = 12,
    this.labelPosition = ReferenceDotLabelPosition.top,
    this.isFront = false,
    this.xAxisId,
    this.yAxisId,
  });

  ReferenceDot copyWith({
    dynamic x,
    dynamic y,
    double? r,
    Color? fill,
    Color? stroke,
    double? strokeWidth,
    String? label,
    Color? labelColor,
    double? labelSize,
    ReferenceDotLabelPosition? labelPosition,
    bool? isFront,
    String? xAxisId,
    String? yAxisId,
  }) {
    return ReferenceDot(
      x: x ?? this.x,
      y: y ?? this.y,
      r: r ?? this.r,
      fill: fill ?? this.fill,
      stroke: stroke ?? this.stroke,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      label: label ?? this.label,
      labelColor: labelColor ?? this.labelColor,
      labelSize: labelSize ?? this.labelSize,
      labelPosition: labelPosition ?? this.labelPosition,
      isFront: isFront ?? this.isFront,
      xAxisId: xAxisId ?? this.xAxisId,
      yAxisId: yAxisId ?? this.yAxisId,
    );
  }
}

enum ReferenceDotLabelPosition {
  top,
  right,
  bottom,
  left,
  center,
}
