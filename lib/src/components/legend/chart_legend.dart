import 'dart:ui';

import '../../core/types/series_types.dart';

enum LegendLayout { horizontal, vertical }

enum LegendAlign { left, center, right }

enum LegendVerticalAlign { top, middle, bottom }

class ChartLegend {
  final bool enabled;
  final LegendLayout layout;
  final LegendAlign align;
  final LegendVerticalAlign verticalAlign;
  final LegendType iconType;
  final double iconSize;
  final double itemGap;
  final double wrapperMargin;
  final Color? textColor;
  final double textSize;
  final FontWeight textWeight;
  final bool interactive;

  const ChartLegend({
    this.enabled = true,
    this.layout = LegendLayout.horizontal,
    this.align = LegendAlign.center,
    this.verticalAlign = LegendVerticalAlign.bottom,
    this.iconType = LegendType.square,
    this.iconSize = 14,
    this.itemGap = 10,
    this.wrapperMargin = 8,
    this.textColor,
    this.textSize = 12,
    this.textWeight = FontWeight.normal,
    this.interactive = true,
  });

  ChartLegend copyWith({
    bool? enabled,
    LegendLayout? layout,
    LegendAlign? align,
    LegendVerticalAlign? verticalAlign,
    LegendType? iconType,
    double? iconSize,
    double? itemGap,
    double? wrapperMargin,
    Color? textColor,
    double? textSize,
    FontWeight? textWeight,
    bool? interactive,
  }) {
    return ChartLegend(
      enabled: enabled ?? this.enabled,
      layout: layout ?? this.layout,
      align: align ?? this.align,
      verticalAlign: verticalAlign ?? this.verticalAlign,
      iconType: iconType ?? this.iconType,
      iconSize: iconSize ?? this.iconSize,
      itemGap: itemGap ?? this.itemGap,
      wrapperMargin: wrapperMargin ?? this.wrapperMargin,
      textColor: textColor ?? this.textColor,
      textSize: textSize ?? this.textSize,
      textWeight: textWeight ?? this.textWeight,
      interactive: interactive ?? this.interactive,
    );
  }
}
