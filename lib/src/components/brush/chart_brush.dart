import 'dart:ui';

class ChartBrush {
  final bool enabled;
  final double height;
  final Color stroke;
  final Color fill;
  final Color handleStroke;
  final Color handleFill;
  final double handleWidth;
  final String? dataKey;
  final double gap;
  final int? startIndex;
  final int? endIndex;
  final double travellerWidth;
  final Color? travelerStroke;
  final Color? travelerFill;

  const ChartBrush({
    this.enabled = true,
    this.height = 40,
    this.stroke = const Color(0xFF8884d8),
    this.fill = const Color(0xFFd0d1e6),
    this.handleStroke = const Color(0xFF8884d8),
    this.handleFill = const Color(0xFFFFFFFF),
    this.handleWidth = 8,
    this.dataKey,
    this.gap = 10,
    this.startIndex,
    this.endIndex,
    this.travellerWidth = 8,
    this.travelerStroke,
    this.travelerFill,
  });

  ChartBrush copyWith({
    bool? enabled,
    double? height,
    Color? stroke,
    Color? fill,
    Color? handleStroke,
    Color? handleFill,
    double? handleWidth,
    String? dataKey,
    double? gap,
    int? startIndex,
    int? endIndex,
    double? travellerWidth,
    Color? travelerStroke,
    Color? travelerFill,
  }) {
    return ChartBrush(
      enabled: enabled ?? this.enabled,
      height: height ?? this.height,
      stroke: stroke ?? this.stroke,
      fill: fill ?? this.fill,
      handleStroke: handleStroke ?? this.handleStroke,
      handleFill: handleFill ?? this.handleFill,
      handleWidth: handleWidth ?? this.handleWidth,
      dataKey: dataKey ?? this.dataKey,
      gap: gap ?? this.gap,
      startIndex: startIndex ?? this.startIndex,
      endIndex: endIndex ?? this.endIndex,
      travellerWidth: travellerWidth ?? this.travellerWidth,
      travelerStroke: travelerStroke ?? this.travelerStroke,
      travelerFill: travelerFill ?? this.travelerFill,
    );
  }
}
