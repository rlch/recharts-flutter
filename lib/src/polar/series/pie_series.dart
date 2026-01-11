import 'dart:ui';

import '../../core/types/series_types.dart';

class PieSeries {
  final String dataKey;
  final String? nameKey;
  final String? name;
  final double innerRadius;
  final double outerRadius;
  final double startAngle;
  final double endAngle;
  final double paddingAngle;
  final double cornerRadius;
  final List<Color>? colors;
  final Color? stroke;
  final double strokeWidth;
  final bool label;
  final LegendType legendType;
  final bool isAnimationActive;
  final int animationDuration;

  const PieSeries({
    required this.dataKey,
    this.nameKey,
    this.name,
    this.innerRadius = 0,
    this.outerRadius = 80,
    this.startAngle = 0,
    this.endAngle = 360,
    this.paddingAngle = 0,
    this.cornerRadius = 0,
    this.colors,
    this.stroke,
    this.strokeWidth = 1,
    this.label = false,
    this.legendType = LegendType.rect,
    this.isAnimationActive = true,
    this.animationDuration = 400,
  });

  PieSeries copyWith({
    String? dataKey,
    String? nameKey,
    String? name,
    double? innerRadius,
    double? outerRadius,
    double? startAngle,
    double? endAngle,
    double? paddingAngle,
    double? cornerRadius,
    List<Color>? colors,
    Color? stroke,
    double? strokeWidth,
    bool? label,
    LegendType? legendType,
    bool? isAnimationActive,
    int? animationDuration,
  }) {
    return PieSeries(
      dataKey: dataKey ?? this.dataKey,
      nameKey: nameKey ?? this.nameKey,
      name: name ?? this.name,
      innerRadius: innerRadius ?? this.innerRadius,
      outerRadius: outerRadius ?? this.outerRadius,
      startAngle: startAngle ?? this.startAngle,
      endAngle: endAngle ?? this.endAngle,
      paddingAngle: paddingAngle ?? this.paddingAngle,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      colors: colors ?? this.colors,
      stroke: stroke ?? this.stroke,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      label: label ?? this.label,
      legendType: legendType ?? this.legendType,
      isAnimationActive: isAnimationActive ?? this.isAnimationActive,
      animationDuration: animationDuration ?? this.animationDuration,
    );
  }
}

const defaultPieColors = [
  Color(0xFF8884d8),
  Color(0xFF83a6ed),
  Color(0xFF8dd1e1),
  Color(0xFF82ca9d),
  Color(0xFFa4de6c),
  Color(0xFFd0ed57),
  Color(0xFFffc658),
  Color(0xFFff8042),
];
