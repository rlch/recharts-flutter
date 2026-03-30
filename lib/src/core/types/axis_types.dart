enum AxisType { xAxis, yAxis, angleAxis, radiusAxis }

enum AxisOrientation { top, bottom, left, right }

enum AxisDomain { auto, dataMin, dataMax }

enum ScaleType {
  auto,
  linear,
  log,
  pow,
  sqrt,
  identity,
  time,
  band,
  point,
  ordinal,
  sequential,
  category,
}

enum TicksType { number, category }

typedef AxisTickFormatter = String Function(dynamic value);

class AxisConfig {
  final String? dataKey;
  final AxisType type;
  final AxisOrientation orientation;
  final ScaleType scaleType;
  final List<dynamic>? domain;
  final List<double>? range;
  final int? tickCount;
  final List<dynamic>? ticks;
  final bool hide;
  final bool allowDecimals;
  final bool allowDuplicatedCategory;
  final bool allowDataOverflow;
  final double? minTickGap;
  final double? angle;
  final String? unit;
  final String? name;
  final bool mirror;
  final bool reversed;
  final double? width;
  final double? height;
  final AxisPadding? padding;

  const AxisConfig({
    this.dataKey,
    this.type = AxisType.xAxis,
    this.orientation = AxisOrientation.bottom,
    this.scaleType = ScaleType.auto,
    this.domain,
    this.range,
    this.tickCount,
    this.ticks,
    this.hide = false,
    this.allowDecimals = true,
    this.allowDuplicatedCategory = true,
    this.allowDataOverflow = false,
    this.minTickGap,
    this.angle,
    this.unit,
    this.name,
    this.mirror = false,
    this.reversed = false,
    this.width,
    this.height,
    this.padding,
  });

  AxisConfig copyWith({
    String? dataKey,
    AxisType? type,
    AxisOrientation? orientation,
    ScaleType? scaleType,
    List<dynamic>? domain,
    List<double>? range,
    int? tickCount,
    List<dynamic>? ticks,
    bool? hide,
    bool? allowDecimals,
    bool? allowDuplicatedCategory,
    bool? allowDataOverflow,
    double? minTickGap,
    double? angle,
    String? unit,
    String? name,
    bool? mirror,
    bool? reversed,
    double? width,
    double? height,
    AxisPadding? padding,
  }) {
    return AxisConfig(
      dataKey: dataKey ?? this.dataKey,
      type: type ?? this.type,
      orientation: orientation ?? this.orientation,
      scaleType: scaleType ?? this.scaleType,
      domain: domain ?? this.domain,
      range: range ?? this.range,
      tickCount: tickCount ?? this.tickCount,
      ticks: ticks ?? this.ticks,
      hide: hide ?? this.hide,
      allowDecimals: allowDecimals ?? this.allowDecimals,
      allowDuplicatedCategory:
          allowDuplicatedCategory ?? this.allowDuplicatedCategory,
      allowDataOverflow: allowDataOverflow ?? this.allowDataOverflow,
      minTickGap: minTickGap ?? this.minTickGap,
      angle: angle ?? this.angle,
      unit: unit ?? this.unit,
      name: name ?? this.name,
      mirror: mirror ?? this.mirror,
      reversed: reversed ?? this.reversed,
      width: width ?? this.width,
      height: height ?? this.height,
      padding: padding ?? this.padding,
    );
  }
}

class AxisPadding {
  final double left;
  final double right;
  final double top;
  final double bottom;

  const AxisPadding({
    this.left = 0,
    this.right = 0,
    this.top = 0,
    this.bottom = 0,
  });

  const AxisPadding.all(double value)
    : left = value,
      right = value,
      top = value,
      bottom = value;

  const AxisPadding.symmetric({double horizontal = 0, double vertical = 0})
    : left = horizontal,
      right = horizontal,
      top = vertical,
      bottom = vertical;
}
