import 'dart:ui';

enum SeriesType {
  line,
  area,
  bar,
  scatter,
  pie,
  radar,
  radialBar,
  funnel,
  treemap,
}

enum CurveType {
  linear,
  linearClosed,
  basis,
  basisClosed,
  basisOpen,
  monotone,
  monotoneX,
  monotoneY,
  natural,
  step,
  stepAfter,
  stepBefore,
  cardinal,
  cardinalClosed,
  cardinalOpen,
  catmullRom,
  catmullRomClosed,
  catmullRomOpen,
}

enum LegendType {
  line,
  square,
  rect,
  circle,
  cross,
  diamond,
  star,
  triangle,
  wye,
  plainline,
  none,
}

enum StackOffsetType {
  expand,
  none,
  silhouette,
  wiggle,
  sign,
  positive,
}

class SeriesConfig {
  final String? dataKey;
  final String? name;
  final SeriesType type;
  final Color? stroke;
  final double strokeWidth;
  final Color? fill;
  final double fillOpacity;
  final bool hide;
  final String? stackId;
  final int? zIndex;
  final LegendType legendType;
  final bool connectNulls;
  final bool isAnimationActive;
  final int animationDuration;
  final String animationEasing;

  const SeriesConfig({
    this.dataKey,
    this.name,
    required this.type,
    this.stroke,
    this.strokeWidth = 1,
    this.fill,
    this.fillOpacity = 1,
    this.hide = false,
    this.stackId,
    this.zIndex,
    this.legendType = LegendType.line,
    this.connectNulls = false,
    this.isAnimationActive = true,
    this.animationDuration = 1500,
    this.animationEasing = 'ease',
  });
}

class LineSeriesConfig extends SeriesConfig {
  final CurveType curveType;
  final bool dot;
  final bool activeDot;

  const LineSeriesConfig({
    super.dataKey,
    super.name,
    super.stroke,
    super.strokeWidth = 2,
    super.hide,
    super.stackId,
    super.zIndex,
    super.legendType = LegendType.line,
    super.connectNulls,
    super.isAnimationActive,
    super.animationDuration,
    super.animationEasing,
    this.curveType = CurveType.linear,
    this.dot = true,
    this.activeDot = true,
  }) : super(type: SeriesType.line, fill: null, fillOpacity: 0);
}

class AreaSeriesConfig extends SeriesConfig {
  final CurveType curveType;
  final bool dot;
  final bool activeDot;
  final dynamic baseValue;

  const AreaSeriesConfig({
    super.dataKey,
    super.name,
    super.stroke,
    super.strokeWidth = 2,
    super.fill,
    super.fillOpacity = 0.6,
    super.hide,
    super.stackId,
    super.zIndex,
    super.legendType = LegendType.line,
    super.connectNulls,
    super.isAnimationActive,
    super.animationDuration,
    super.animationEasing,
    this.curveType = CurveType.linear,
    this.dot = false,
    this.activeDot = true,
    this.baseValue,
  }) : super(type: SeriesType.area);
}

class BarSeriesConfig extends SeriesConfig {
  final double? barSize;
  final double? maxBarSize;
  final double? minPointSize;
  final String? barCategoryGap;
  final String? barGap;
  final double? radius;
  final bool background;
  final String layout;

  const BarSeriesConfig({
    super.dataKey,
    super.name,
    super.stroke,
    super.strokeWidth = 0,
    super.fill,
    super.fillOpacity = 1,
    super.hide,
    super.stackId,
    super.zIndex,
    super.legendType = LegendType.rect,
    super.isAnimationActive,
    super.animationDuration,
    super.animationEasing,
    this.barSize,
    this.maxBarSize,
    this.minPointSize,
    this.barCategoryGap,
    this.barGap,
    this.radius,
    this.background = false,
    this.layout = 'horizontal',
  }) : super(type: SeriesType.bar, connectNulls: false);
}

class ScatterSeriesConfig extends SeriesConfig {
  final String? xDataKey;
  final String? yDataKey;
  final String? zDataKey;
  final String shape;

  const ScatterSeriesConfig({
    super.dataKey,
    super.name,
    super.stroke,
    super.strokeWidth = 0,
    super.fill,
    super.fillOpacity = 1,
    super.hide,
    super.zIndex,
    super.legendType = LegendType.circle,
    super.isAnimationActive,
    super.animationDuration,
    super.animationEasing,
    this.xDataKey,
    this.yDataKey,
    this.zDataKey,
    this.shape = 'circle',
  }) : super(type: SeriesType.scatter, stackId: null, connectNulls: false);
}

class PieSeriesConfig extends SeriesConfig {
  final double? cx;
  final double? cy;
  final double innerRadius;
  final double outerRadius;
  final double startAngle;
  final double endAngle;
  final double? paddingAngle;
  final double cornerRadius;
  final String? nameKey;
  final bool label;

  const PieSeriesConfig({
    super.dataKey,
    super.name,
    super.stroke,
    super.strokeWidth = 1,
    super.fill,
    super.fillOpacity = 1,
    super.hide,
    super.zIndex,
    super.legendType = LegendType.rect,
    super.isAnimationActive,
    super.animationDuration,
    super.animationEasing,
    this.cx,
    this.cy,
    this.innerRadius = 0,
    this.outerRadius = 80,
    this.startAngle = 0,
    this.endAngle = 360,
    this.paddingAngle,
    this.cornerRadius = 0,
    this.nameKey,
    this.label = false,
  }) : super(type: SeriesType.pie, stackId: null, connectNulls: false);
}
