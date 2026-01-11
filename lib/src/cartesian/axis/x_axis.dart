import '../../core/types/axis_types.dart';

export '../../core/types/axis_types.dart' show AxisOrientation;

class XAxis {
  final String id;
  final String? dataKey;
  final ScaleType type;
  final AxisOrientation orientation;
  final List<dynamic>? domain;
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
  final double? height;
  final AxisPadding? padding;
  final double? tickMargin;
  final int? interval;

  const XAxis({
    this.id = '0',
    this.dataKey,
    this.type = ScaleType.category,
    this.orientation = AxisOrientation.bottom,
    this.domain,
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
    this.height,
    this.padding,
    this.tickMargin,
    this.interval,
  });

  XAxis copyWith({
    String? id,
    String? dataKey,
    ScaleType? type,
    AxisOrientation? orientation,
    List<dynamic>? domain,
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
    double? height,
    AxisPadding? padding,
    double? tickMargin,
    int? interval,
  }) {
    return XAxis(
      id: id ?? this.id,
      dataKey: dataKey ?? this.dataKey,
      type: type ?? this.type,
      orientation: orientation ?? this.orientation,
      domain: domain ?? this.domain,
      tickCount: tickCount ?? this.tickCount,
      ticks: ticks ?? this.ticks,
      hide: hide ?? this.hide,
      allowDecimals: allowDecimals ?? this.allowDecimals,
      allowDuplicatedCategory: allowDuplicatedCategory ?? this.allowDuplicatedCategory,
      allowDataOverflow: allowDataOverflow ?? this.allowDataOverflow,
      minTickGap: minTickGap ?? this.minTickGap,
      angle: angle ?? this.angle,
      unit: unit ?? this.unit,
      name: name ?? this.name,
      mirror: mirror ?? this.mirror,
      reversed: reversed ?? this.reversed,
      height: height ?? this.height,
      padding: padding ?? this.padding,
      tickMargin: tickMargin ?? this.tickMargin,
      interval: interval ?? this.interval,
    );
  }
}
