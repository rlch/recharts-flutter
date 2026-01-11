import 'dart:ui';

import '../../core/types/series_types.dart';

class RadarSeries {
  final String dataKey;
  final String? name;
  final Color fill;
  final Color stroke;
  final double fillOpacity;
  final double strokeWidth;
  final bool dot;
  final double dotRadius;
  final LegendType legendType;
  final bool isAnimationActive;
  final int animationDuration;

  const RadarSeries({
    required this.dataKey,
    this.name,
    this.fill = const Color(0xFF8884d8),
    this.stroke = const Color(0xFF8884d8),
    this.fillOpacity = 0.6,
    this.strokeWidth = 2,
    this.dot = true,
    this.dotRadius = 4,
    this.legendType = LegendType.rect,
    this.isAnimationActive = true,
    this.animationDuration = 400,
  });

  RadarSeries copyWith({
    String? dataKey,
    String? name,
    Color? fill,
    Color? stroke,
    double? fillOpacity,
    double? strokeWidth,
    bool? dot,
    double? dotRadius,
    LegendType? legendType,
    bool? isAnimationActive,
    int? animationDuration,
  }) {
    return RadarSeries(
      dataKey: dataKey ?? this.dataKey,
      name: name ?? this.name,
      fill: fill ?? this.fill,
      stroke: stroke ?? this.stroke,
      fillOpacity: fillOpacity ?? this.fillOpacity,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      dot: dot ?? this.dot,
      dotRadius: dotRadius ?? this.dotRadius,
      legendType: legendType ?? this.legendType,
      isAnimationActive: isAnimationActive ?? this.isAnimationActive,
      animationDuration: animationDuration ?? this.animationDuration,
    );
  }
}
