import 'dart:ui';

import '../../core/types/series_types.dart';

class BarSeries {
  final String dataKey;
  final String? name;
  final Color fill;
  final double fillOpacity;
  final Color? stroke;
  final double strokeWidth;
  final double? barSize;
  final double? maxBarSize;
  final double? minPointSize;
  final String? barCategoryGap;
  final String? barGap;
  final double? radius;
  final String? stackId;
  final bool background;
  final Color? backgroundFill;
  final String layout;
  final String? xAxisId;
  final String? yAxisId;
  final bool hide;
  final int? zIndex;
  final LegendType legendType;
  final bool isAnimationActive;
  final int animationDuration;

  const BarSeries({
    required this.dataKey,
    this.name,
    this.fill = const Color(0xFF8884d8),
    this.fillOpacity = 1,
    this.stroke,
    this.strokeWidth = 0,
    this.barSize,
    this.maxBarSize,
    this.minPointSize,
    this.barCategoryGap,
    this.barGap,
    this.radius,
    this.stackId,
    this.background = false,
    this.backgroundFill,
    this.layout = 'horizontal',
    this.xAxisId,
    this.yAxisId,
    this.hide = false,
    this.zIndex,
    this.legendType = LegendType.rect,
    this.isAnimationActive = true,
    this.animationDuration = 1500,
  });

  BarSeries copyWith({
    String? dataKey,
    String? name,
    Color? fill,
    double? fillOpacity,
    Color? stroke,
    double? strokeWidth,
    double? barSize,
    double? maxBarSize,
    double? minPointSize,
    String? barCategoryGap,
    String? barGap,
    double? radius,
    String? stackId,
    bool? background,
    Color? backgroundFill,
    String? layout,
    String? xAxisId,
    String? yAxisId,
    bool? hide,
    int? zIndex,
    LegendType? legendType,
    bool? isAnimationActive,
    int? animationDuration,
  }) {
    return BarSeries(
      dataKey: dataKey ?? this.dataKey,
      name: name ?? this.name,
      fill: fill ?? this.fill,
      fillOpacity: fillOpacity ?? this.fillOpacity,
      stroke: stroke ?? this.stroke,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      barSize: barSize ?? this.barSize,
      maxBarSize: maxBarSize ?? this.maxBarSize,
      minPointSize: minPointSize ?? this.minPointSize,
      barCategoryGap: barCategoryGap ?? this.barCategoryGap,
      barGap: barGap ?? this.barGap,
      radius: radius ?? this.radius,
      stackId: stackId ?? this.stackId,
      background: background ?? this.background,
      backgroundFill: backgroundFill ?? this.backgroundFill,
      layout: layout ?? this.layout,
      xAxisId: xAxisId ?? this.xAxisId,
      yAxisId: yAxisId ?? this.yAxisId,
      hide: hide ?? this.hide,
      zIndex: zIndex ?? this.zIndex,
      legendType: legendType ?? this.legendType,
      isAnimationActive: isAnimationActive ?? this.isAnimationActive,
      animationDuration: animationDuration ?? this.animationDuration,
    );
  }
}
