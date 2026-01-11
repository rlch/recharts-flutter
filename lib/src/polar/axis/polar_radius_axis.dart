import 'dart:ui';

class PolarRadiusAxis {
  final String id;
  final double angle;
  final List<num>? domain;
  final int tickCount;
  final double tickSize;
  final Color tickColor;
  final double tickStrokeWidth;
  final bool hide;
  final Color labelColor;
  final double labelFontSize;
  final Color axisLineColor;
  final double axisLineWidth;
  final bool showAxisLine;

  const PolarRadiusAxis({
    this.id = '0',
    this.angle = 90,
    this.domain,
    this.tickCount = 5,
    this.tickSize = 6,
    this.tickColor = const Color(0xFF666666),
    this.tickStrokeWidth = 1,
    this.hide = false,
    this.labelColor = const Color(0xFF666666),
    this.labelFontSize = 12,
    this.axisLineColor = const Color(0xFF666666),
    this.axisLineWidth = 1,
    this.showAxisLine = true,
  });

  PolarRadiusAxis copyWith({
    String? id,
    double? angle,
    List<num>? domain,
    int? tickCount,
    double? tickSize,
    Color? tickColor,
    double? tickStrokeWidth,
    bool? hide,
    Color? labelColor,
    double? labelFontSize,
    Color? axisLineColor,
    double? axisLineWidth,
    bool? showAxisLine,
  }) {
    return PolarRadiusAxis(
      id: id ?? this.id,
      angle: angle ?? this.angle,
      domain: domain ?? this.domain,
      tickCount: tickCount ?? this.tickCount,
      tickSize: tickSize ?? this.tickSize,
      tickColor: tickColor ?? this.tickColor,
      tickStrokeWidth: tickStrokeWidth ?? this.tickStrokeWidth,
      hide: hide ?? this.hide,
      labelColor: labelColor ?? this.labelColor,
      labelFontSize: labelFontSize ?? this.labelFontSize,
      axisLineColor: axisLineColor ?? this.axisLineColor,
      axisLineWidth: axisLineWidth ?? this.axisLineWidth,
      showAxisLine: showAxisLine ?? this.showAxisLine,
    );
  }
}
