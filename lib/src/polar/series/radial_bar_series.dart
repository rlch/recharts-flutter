import 'dart:ui';

import '../../core/types/series_types.dart';

class RadialBarSeries {
  final String dataKey;
  final String? nameKey;
  final String? name;
  final double innerRadius;
  final double outerRadius;
  final double startAngle;
  final double endAngle;
  final double? barSize;
  final double cornerRadius;
  final List<Color>? colors;
  final Color? stroke;
  final double strokeWidth;
  final Color? background;
  final LegendType legendType;
  final bool isAnimationActive;
  final int animationDuration;

  const RadialBarSeries({
    required this.dataKey,
    this.nameKey,
    this.name,
    this.innerRadius = 30,
    this.outerRadius = 100,
    this.startAngle = 90,
    this.endAngle = -270,
    this.barSize,
    this.cornerRadius = 0,
    this.colors,
    this.stroke,
    this.strokeWidth = 0,
    this.background,
    this.legendType = LegendType.rect,
    this.isAnimationActive = true,
    this.animationDuration = 400,
  });

  RadialBarSeries copyWith({
    String? dataKey,
    String? nameKey,
    String? name,
    double? innerRadius,
    double? outerRadius,
    double? startAngle,
    double? endAngle,
    double? barSize,
    double? cornerRadius,
    List<Color>? colors,
    Color? stroke,
    double? strokeWidth,
    Color? background,
    LegendType? legendType,
    bool? isAnimationActive,
    int? animationDuration,
  }) {
    return RadialBarSeries(
      dataKey: dataKey ?? this.dataKey,
      nameKey: nameKey ?? this.nameKey,
      name: name ?? this.name,
      innerRadius: innerRadius ?? this.innerRadius,
      outerRadius: outerRadius ?? this.outerRadius,
      startAngle: startAngle ?? this.startAngle,
      endAngle: endAngle ?? this.endAngle,
      barSize: barSize ?? this.barSize,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      colors: colors ?? this.colors,
      stroke: stroke ?? this.stroke,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      background: background ?? this.background,
      legendType: legendType ?? this.legendType,
      isAnimationActive: isAnimationActive ?? this.isAnimationActive,
      animationDuration: animationDuration ?? this.animationDuration,
    );
  }
}

const defaultRadialBarColors = [
  Color(0xFF8884d8),
  Color(0xFF83a6ed),
  Color(0xFF8dd1e1),
  Color(0xFF82ca9d),
  Color(0xFFa4de6c),
];
