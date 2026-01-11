import 'dart:ui';

import '../../core/types/series_types.dart';
import 'line_series.dart';

class AreaSeries {
  final String dataKey;
  final String? name;
  final Color stroke;
  final double strokeWidth;
  final Color fill;
  final double fillOpacity;
  final CurveType curveType;
  final bool connectNulls;
  final bool dot;
  final DotConfig? dotConfig;
  final bool activeDot;
  final DotConfig? activeDotConfig;
  final String? stackId;
  final dynamic baseValue;
  final String? xAxisId;
  final String? yAxisId;
  final bool hide;
  final int? zIndex;
  final LegendType legendType;
  final bool isAnimationActive;
  final int animationDuration;

  const AreaSeries({
    required this.dataKey,
    this.name,
    this.stroke = const Color(0xFF8884d8),
    this.strokeWidth = 2,
    this.fill = const Color(0xFF8884d8),
    this.fillOpacity = 0.6,
    this.curveType = CurveType.linear,
    this.connectNulls = false,
    this.dot = false,
    this.dotConfig,
    this.activeDot = true,
    this.activeDotConfig,
    this.stackId,
    this.baseValue,
    this.xAxisId,
    this.yAxisId,
    this.hide = false,
    this.zIndex,
    this.legendType = LegendType.line,
    this.isAnimationActive = true,
    this.animationDuration = 1500,
  });

  AreaSeries copyWith({
    String? dataKey,
    String? name,
    Color? stroke,
    double? strokeWidth,
    Color? fill,
    double? fillOpacity,
    CurveType? curveType,
    bool? connectNulls,
    bool? dot,
    DotConfig? dotConfig,
    bool? activeDot,
    DotConfig? activeDotConfig,
    String? stackId,
    dynamic baseValue,
    String? xAxisId,
    String? yAxisId,
    bool? hide,
    int? zIndex,
    LegendType? legendType,
    bool? isAnimationActive,
    int? animationDuration,
  }) {
    return AreaSeries(
      dataKey: dataKey ?? this.dataKey,
      name: name ?? this.name,
      stroke: stroke ?? this.stroke,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      fill: fill ?? this.fill,
      fillOpacity: fillOpacity ?? this.fillOpacity,
      curveType: curveType ?? this.curveType,
      connectNulls: connectNulls ?? this.connectNulls,
      dot: dot ?? this.dot,
      dotConfig: dotConfig ?? this.dotConfig,
      activeDot: activeDot ?? this.activeDot,
      activeDotConfig: activeDotConfig ?? this.activeDotConfig,
      stackId: stackId ?? this.stackId,
      baseValue: baseValue ?? this.baseValue,
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
