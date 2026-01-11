import 'package:flutter/material.dart';

import 'tooltip_types.dart';

typedef TooltipBuilder = Widget Function(
  BuildContext context,
  TooltipPayload payload,
);

class ChartTooltip {
  final bool enabled;
  final TooltipTrigger trigger;
  final CursorConfig cursor;
  final EdgeInsets contentPadding;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final TooltipBuilder? contentBuilder;
  final Duration animationDuration;
  final Offset offset;
  final bool followCursor;
  final String? separator;
  final bool showLabel;
  final bool showSeriesName;

  const ChartTooltip({
    this.enabled = true,
    this.trigger = TooltipTrigger.hover,
    this.cursor = const CursorConfig(),
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 8,
    ),
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.borderColor = const Color(0xFFCCCCCC),
    this.borderWidth = 1,
    this.borderRadius = 4,
    this.labelStyle,
    this.valueStyle,
    this.contentBuilder,
    this.animationDuration = const Duration(milliseconds: 150),
    this.offset = const Offset(10, 10),
    this.followCursor = true,
    this.separator = ' : ',
    this.showLabel = true,
    this.showSeriesName = true,
  });

  ChartTooltip copyWith({
    bool? enabled,
    TooltipTrigger? trigger,
    CursorConfig? cursor,
    EdgeInsets? contentPadding,
    Color? backgroundColor,
    Color? borderColor,
    double? borderWidth,
    double? borderRadius,
    TextStyle? labelStyle,
    TextStyle? valueStyle,
    TooltipBuilder? contentBuilder,
    Duration? animationDuration,
    Offset? offset,
    bool? followCursor,
    String? separator,
    bool? showLabel,
    bool? showSeriesName,
  }) {
    return ChartTooltip(
      enabled: enabled ?? this.enabled,
      trigger: trigger ?? this.trigger,
      cursor: cursor ?? this.cursor,
      contentPadding: contentPadding ?? this.contentPadding,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      labelStyle: labelStyle ?? this.labelStyle,
      valueStyle: valueStyle ?? this.valueStyle,
      contentBuilder: contentBuilder ?? this.contentBuilder,
      animationDuration: animationDuration ?? this.animationDuration,
      offset: offset ?? this.offset,
      followCursor: followCursor ?? this.followCursor,
      separator: separator ?? this.separator,
      showLabel: showLabel ?? this.showLabel,
      showSeriesName: showSeriesName ?? this.showSeriesName,
    );
  }
}
