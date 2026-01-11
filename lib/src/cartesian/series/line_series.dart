import 'dart:ui';

import '../../core/types/series_types.dart';

class DotConfig {
  final double radius;
  final Color? fill;
  final Color? stroke;
  final double strokeWidth;

  const DotConfig({
    this.radius = 4,
    this.fill,
    this.stroke,
    this.strokeWidth = 1,
  });
}

class LineSeries {
  final String dataKey;
  final String? name;
  final Color stroke;
  final double strokeWidth;
  final CurveType curveType;
  final bool connectNulls;
  final bool dot;
  final DotConfig? dotConfig;
  final bool activeDot;
  final DotConfig? activeDotConfig;
  final String? xAxisId;
  final String? yAxisId;
  final bool hide;
  final int? zIndex;
  final LegendType legendType;
  final bool isAnimationActive;
  final int animationDuration;

  const LineSeries({
    required this.dataKey,
    this.name,
    this.stroke = const Color(0xFF8884d8),
    this.strokeWidth = 2,
    this.curveType = CurveType.linear,
    this.connectNulls = false,
    this.dot = true,
    this.dotConfig,
    this.activeDot = true,
    this.activeDotConfig,
    this.xAxisId,
    this.yAxisId,
    this.hide = false,
    this.zIndex,
    this.legendType = LegendType.line,
    this.isAnimationActive = true,
    this.animationDuration = 1500,
  });

  LineSeries copyWith({
    String? dataKey,
    String? name,
    Color? stroke,
    double? strokeWidth,
    CurveType? curveType,
    bool? connectNulls,
    bool? dot,
    DotConfig? dotConfig,
    bool? activeDot,
    DotConfig? activeDotConfig,
    String? xAxisId,
    String? yAxisId,
    bool? hide,
    int? zIndex,
    LegendType? legendType,
    bool? isAnimationActive,
    int? animationDuration,
  }) {
    return LineSeries(
      dataKey: dataKey ?? this.dataKey,
      name: name ?? this.name,
      stroke: stroke ?? this.stroke,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      curveType: curveType ?? this.curveType,
      connectNulls: connectNulls ?? this.connectNulls,
      dot: dot ?? this.dot,
      dotConfig: dotConfig ?? this.dotConfig,
      activeDot: activeDot ?? this.activeDot,
      activeDotConfig: activeDotConfig ?? this.activeDotConfig,
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
