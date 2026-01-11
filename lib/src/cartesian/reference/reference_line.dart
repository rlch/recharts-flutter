import 'dart:ui';

enum ReferenceLineOrientation { horizontal, vertical }

class ReferenceLine {
  final dynamic x;
  final dynamic y;
  final ReferenceLineOrientation? orientation;
  final Color stroke;
  final double strokeWidth;
  final List<double>? strokeDasharray;
  final String? label;
  final ReferenceLineLabelPosition labelPosition;
  final Color? labelColor;
  final double labelSize;
  final bool isFront;
  final String? xAxisId;
  final String? yAxisId;

  const ReferenceLine({
    this.x,
    this.y,
    this.orientation,
    this.stroke = const Color(0xFFCCCCCC),
    this.strokeWidth = 1,
    this.strokeDasharray,
    this.label,
    this.labelPosition = ReferenceLineLabelPosition.end,
    this.labelColor,
    this.labelSize = 12,
    this.isFront = false,
    this.xAxisId,
    this.yAxisId,
  });

  ReferenceLineOrientation get effectiveOrientation {
    if (orientation != null) return orientation!;
    if (y != null) return ReferenceLineOrientation.horizontal;
    return ReferenceLineOrientation.vertical;
  }

  ReferenceLine copyWith({
    dynamic x,
    dynamic y,
    ReferenceLineOrientation? orientation,
    Color? stroke,
    double? strokeWidth,
    List<double>? strokeDasharray,
    String? label,
    ReferenceLineLabelPosition? labelPosition,
    Color? labelColor,
    double? labelSize,
    bool? isFront,
    String? xAxisId,
    String? yAxisId,
  }) {
    return ReferenceLine(
      x: x ?? this.x,
      y: y ?? this.y,
      orientation: orientation ?? this.orientation,
      stroke: stroke ?? this.stroke,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      strokeDasharray: strokeDasharray ?? this.strokeDasharray,
      label: label ?? this.label,
      labelPosition: labelPosition ?? this.labelPosition,
      labelColor: labelColor ?? this.labelColor,
      labelSize: labelSize ?? this.labelSize,
      isFront: isFront ?? this.isFront,
      xAxisId: xAxisId ?? this.xAxisId,
      yAxisId: yAxisId ?? this.yAxisId,
    );
  }
}

enum ReferenceLineLabelPosition {
  start,
  center,
  end,
  insideStart,
  insideEnd,
}
