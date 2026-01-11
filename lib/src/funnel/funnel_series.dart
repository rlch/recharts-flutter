import 'dart:ui';

import '../core/types/series_types.dart';

enum FunnelShape {
  trapezoid,
  rectangle,
}

class FunnelSeries {
  final String dataKey;
  final String? nameKey;
  final String? name;
  final FunnelShape shape;
  final List<Color>? colors;
  final Color? stroke;
  final double strokeWidth;
  final bool label;
  final LegendType legendType;
  final bool isAnimationActive;
  final int animationDuration;
  final bool reversed;
  final double gap;

  const FunnelSeries({
    required this.dataKey,
    this.nameKey,
    this.name,
    this.shape = FunnelShape.trapezoid,
    this.colors,
    this.stroke,
    this.strokeWidth = 1,
    this.label = true,
    this.legendType = LegendType.rect,
    this.isAnimationActive = true,
    this.animationDuration = 400,
    this.reversed = false,
    this.gap = 4,
  });

  FunnelSeries copyWith({
    String? dataKey,
    String? nameKey,
    String? name,
    FunnelShape? shape,
    List<Color>? colors,
    Color? stroke,
    double? strokeWidth,
    bool? label,
    LegendType? legendType,
    bool? isAnimationActive,
    int? animationDuration,
    bool? reversed,
    double? gap,
  }) {
    return FunnelSeries(
      dataKey: dataKey ?? this.dataKey,
      nameKey: nameKey ?? this.nameKey,
      name: name ?? this.name,
      shape: shape ?? this.shape,
      colors: colors ?? this.colors,
      stroke: stroke ?? this.stroke,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      label: label ?? this.label,
      legendType: legendType ?? this.legendType,
      isAnimationActive: isAnimationActive ?? this.isAnimationActive,
      animationDuration: animationDuration ?? this.animationDuration,
      reversed: reversed ?? this.reversed,
      gap: gap ?? this.gap,
    );
  }
}

const defaultFunnelColors = [
  Color(0xFF8884d8),
  Color(0xFF83a6ed),
  Color(0xFF8dd1e1),
  Color(0xFF82ca9d),
  Color(0xFFa4de6c),
  Color(0xFFd0ed57),
  Color(0xFFffc658),
  Color(0xFFff8042),
];
