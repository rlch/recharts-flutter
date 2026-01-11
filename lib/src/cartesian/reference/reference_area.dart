import 'dart:ui';

class ReferenceArea {
  final dynamic x1;
  final dynamic x2;
  final dynamic y1;
  final dynamic y2;
  final Color fill;
  final double fillOpacity;
  final Color? stroke;
  final double strokeWidth;
  final String? label;
  final Color? labelColor;
  final double labelSize;
  final bool isFront;
  final String? xAxisId;
  final String? yAxisId;

  const ReferenceArea({
    this.x1,
    this.x2,
    this.y1,
    this.y2,
    this.fill = const Color(0xFFCCCCCC),
    this.fillOpacity = 0.5,
    this.stroke,
    this.strokeWidth = 0,
    this.label,
    this.labelColor,
    this.labelSize = 12,
    this.isFront = false,
    this.xAxisId,
    this.yAxisId,
  });

  bool get isHorizontal => y1 != null && y2 != null && x1 == null && x2 == null;
  bool get isVertical => x1 != null && x2 != null && y1 == null && y2 == null;
  bool get isRect => x1 != null && x2 != null && y1 != null && y2 != null;

  ReferenceArea copyWith({
    dynamic x1,
    dynamic x2,
    dynamic y1,
    dynamic y2,
    Color? fill,
    double? fillOpacity,
    Color? stroke,
    double? strokeWidth,
    String? label,
    Color? labelColor,
    double? labelSize,
    bool? isFront,
    String? xAxisId,
    String? yAxisId,
  }) {
    return ReferenceArea(
      x1: x1 ?? this.x1,
      x2: x2 ?? this.x2,
      y1: y1 ?? this.y1,
      y2: y2 ?? this.y2,
      fill: fill ?? this.fill,
      fillOpacity: fillOpacity ?? this.fillOpacity,
      stroke: stroke ?? this.stroke,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      label: label ?? this.label,
      labelColor: labelColor ?? this.labelColor,
      labelSize: labelSize ?? this.labelSize,
      isFront: isFront ?? this.isFront,
      xAxisId: xAxisId ?? this.xAxisId,
      yAxisId: yAxisId ?? this.yAxisId,
    );
  }
}
