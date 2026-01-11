import 'dart:ui';

class CartesianGrid {
  final bool horizontal;
  final bool vertical;
  final List<double>? strokeDasharray;
  final Color stroke;
  final double strokeWidth;
  final double strokeOpacity;
  final List<double>? horizontalPoints;
  final List<double>? verticalPoints;
  final Color? horizontalFill;
  final List<Color>? horizontalFills;
  final Color? verticalFill;
  final List<Color>? verticalFills;

  const CartesianGrid({
    this.horizontal = true,
    this.vertical = true,
    this.strokeDasharray,
    this.stroke = const Color(0xFFCCCCCC),
    this.strokeWidth = 1,
    this.strokeOpacity = 1,
    this.horizontalPoints,
    this.verticalPoints,
    this.horizontalFill,
    this.horizontalFills,
    this.verticalFill,
    this.verticalFills,
  });

  CartesianGrid copyWith({
    bool? horizontal,
    bool? vertical,
    List<double>? strokeDasharray,
    Color? stroke,
    double? strokeWidth,
    double? strokeOpacity,
    List<double>? horizontalPoints,
    List<double>? verticalPoints,
    Color? horizontalFill,
    List<Color>? horizontalFills,
    Color? verticalFill,
    List<Color>? verticalFills,
  }) {
    return CartesianGrid(
      horizontal: horizontal ?? this.horizontal,
      vertical: vertical ?? this.vertical,
      strokeDasharray: strokeDasharray ?? this.strokeDasharray,
      stroke: stroke ?? this.stroke,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      strokeOpacity: strokeOpacity ?? this.strokeOpacity,
      horizontalPoints: horizontalPoints ?? this.horizontalPoints,
      verticalPoints: verticalPoints ?? this.verticalPoints,
      horizontalFill: horizontalFill ?? this.horizontalFill,
      horizontalFills: horizontalFills ?? this.horizontalFills,
      verticalFill: verticalFill ?? this.verticalFill,
      verticalFills: verticalFills ?? this.verticalFills,
    );
  }
}
