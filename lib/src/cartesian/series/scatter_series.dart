import 'dart:ui';

import '../../core/types/series_types.dart';

enum ScatterShape {
  circle,
  cross,
  diamond,
  square,
  star,
  triangle,
  wye,
}

class ZAxis {
  final String dataKey;
  final double minSize;
  final double maxSize;
  final double? domain0;
  final double? domain1;

  const ZAxis({
    required this.dataKey,
    this.minSize = 4,
    this.maxSize = 20,
    this.domain0,
    this.domain1,
  });
}

class ScatterSeries {
  final String xDataKey;
  final String yDataKey;
  final String? zDataKey;
  final ZAxis? zAxis;
  final String? name;
  final ScatterShape shape;
  final Color fill;
  final Color? stroke;
  final double strokeWidth;
  final double size;
  final String? xAxisId;
  final String? yAxisId;
  final bool hide;
  final int? zIndex;
  final LegendType legendType;
  final bool isAnimationActive;
  final int animationDuration;

  const ScatterSeries({
    required this.xDataKey,
    required this.yDataKey,
    this.zDataKey,
    this.zAxis,
    this.name,
    this.shape = ScatterShape.circle,
    this.fill = const Color(0xFF8884d8),
    this.stroke,
    this.strokeWidth = 1,
    this.size = 10,
    this.xAxisId,
    this.yAxisId,
    this.hide = false,
    this.zIndex,
    this.legendType = LegendType.circle,
    this.isAnimationActive = true,
    this.animationDuration = 400,
  });

  ScatterSeries copyWith({
    String? xDataKey,
    String? yDataKey,
    String? zDataKey,
    ZAxis? zAxis,
    String? name,
    ScatterShape? shape,
    Color? fill,
    Color? stroke,
    double? strokeWidth,
    double? size,
    String? xAxisId,
    String? yAxisId,
    bool? hide,
    int? zIndex,
    LegendType? legendType,
    bool? isAnimationActive,
    int? animationDuration,
  }) {
    return ScatterSeries(
      xDataKey: xDataKey ?? this.xDataKey,
      yDataKey: yDataKey ?? this.yDataKey,
      zDataKey: zDataKey ?? this.zDataKey,
      zAxis: zAxis ?? this.zAxis,
      name: name ?? this.name,
      shape: shape ?? this.shape,
      fill: fill ?? this.fill,
      stroke: stroke ?? this.stroke,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      size: size ?? this.size,
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
