import 'dart:ui';

enum PolarGridType {
  polygon,
  circle,
}

class PolarGrid {
  final PolarGridType gridType;
  final Color strokeColor;
  final double strokeWidth;
  final List<double>? strokeDashArray;
  final bool showRadialLines;
  final int? radialLineCount;
  final Color radialLineColor;
  final double radialLineWidth;
  final int? concentricCircleCount;

  const PolarGrid({
    this.gridType = PolarGridType.polygon,
    this.strokeColor = const Color(0xFFCCCCCC),
    this.strokeWidth = 1,
    this.strokeDashArray,
    this.showRadialLines = true,
    this.radialLineCount,
    this.radialLineColor = const Color(0xFFCCCCCC),
    this.radialLineWidth = 1,
    this.concentricCircleCount = 5,
  });

  PolarGrid copyWith({
    PolarGridType? gridType,
    Color? strokeColor,
    double? strokeWidth,
    List<double>? strokeDashArray,
    bool? showRadialLines,
    int? radialLineCount,
    Color? radialLineColor,
    double? radialLineWidth,
    int? concentricCircleCount,
  }) {
    return PolarGrid(
      gridType: gridType ?? this.gridType,
      strokeColor: strokeColor ?? this.strokeColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      strokeDashArray: strokeDashArray ?? this.strokeDashArray,
      showRadialLines: showRadialLines ?? this.showRadialLines,
      radialLineCount: radialLineCount ?? this.radialLineCount,
      radialLineColor: radialLineColor ?? this.radialLineColor,
      radialLineWidth: radialLineWidth ?? this.radialLineWidth,
      concentricCircleCount:
          concentricCircleCount ?? this.concentricCircleCount,
    );
  }
}
