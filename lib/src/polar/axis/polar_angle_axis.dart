import 'dart:ui';

class PolarAngleAxis {
  final String? dataKey;
  final String id;
  final double tickSize;
  final Color tickColor;
  final double tickStrokeWidth;
  final bool hide;
  final Color labelColor;
  final double labelFontSize;
  final double labelOffset;
  final bool allowDuplicatedCategory;

  const PolarAngleAxis({
    this.dataKey,
    this.id = '0',
    this.tickSize = 8,
    this.tickColor = const Color(0xFF666666),
    this.tickStrokeWidth = 1,
    this.hide = false,
    this.labelColor = const Color(0xFF666666),
    this.labelFontSize = 12,
    this.labelOffset = 5,
    this.allowDuplicatedCategory = true,
  });

  PolarAngleAxis copyWith({
    String? dataKey,
    String? id,
    double? tickSize,
    Color? tickColor,
    double? tickStrokeWidth,
    bool? hide,
    Color? labelColor,
    double? labelFontSize,
    double? labelOffset,
    bool? allowDuplicatedCategory,
  }) {
    return PolarAngleAxis(
      dataKey: dataKey ?? this.dataKey,
      id: id ?? this.id,
      tickSize: tickSize ?? this.tickSize,
      tickColor: tickColor ?? this.tickColor,
      tickStrokeWidth: tickStrokeWidth ?? this.tickStrokeWidth,
      hide: hide ?? this.hide,
      labelColor: labelColor ?? this.labelColor,
      labelFontSize: labelFontSize ?? this.labelFontSize,
      labelOffset: labelOffset ?? this.labelOffset,
      allowDuplicatedCategory:
          allowDuplicatedCategory ?? this.allowDuplicatedCategory,
    );
  }
}
