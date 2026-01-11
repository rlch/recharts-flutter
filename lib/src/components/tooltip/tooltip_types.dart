import 'dart:ui';

class TooltipEntry {
  final String name;
  final dynamic value;
  final Color color;
  final String? unit;

  const TooltipEntry({
    required this.name,
    required this.value,
    required this.color,
    this.unit,
  });

  String get formattedValue {
    if (value == null) return '';
    if (value is double) {
      return value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2);
    }
    return value.toString();
  }

  @override
  String toString() => 'TooltipEntry(name: $name, value: $value, color: $color)';
}

class TooltipPayload {
  final int index;
  final String label;
  final List<TooltipEntry> entries;
  final Offset coordinate;

  const TooltipPayload({
    required this.index,
    required this.label,
    required this.entries,
    required this.coordinate,
  });

  bool get isEmpty => entries.isEmpty;
  bool get isNotEmpty => entries.isNotEmpty;

  @override
  String toString() =>
      'TooltipPayload(index: $index, label: $label, entries: $entries)';
}

enum TooltipTrigger {
  hover,
  click,
  none,
}

class CursorConfig {
  final bool show;
  final Color color;
  final double strokeWidth;
  final List<double>? dashPattern;
  final double activeDotRadius;
  final Color? activeDotStroke;
  final double activeDotStrokeWidth;

  const CursorConfig({
    this.show = true,
    this.color = const Color(0xFF999999),
    this.strokeWidth = 1,
    this.dashPattern = const [4, 4],
    this.activeDotRadius = 6,
    this.activeDotStroke,
    this.activeDotStrokeWidth = 2,
  });

  CursorConfig copyWith({
    bool? show,
    Color? color,
    double? strokeWidth,
    List<double>? dashPattern,
    double? activeDotRadius,
    Color? activeDotStroke,
    double? activeDotStrokeWidth,
  }) {
    return CursorConfig(
      show: show ?? this.show,
      color: color ?? this.color,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      dashPattern: dashPattern ?? this.dashPattern,
      activeDotRadius: activeDotRadius ?? this.activeDotRadius,
      activeDotStroke: activeDotStroke ?? this.activeDotStroke,
      activeDotStrokeWidth: activeDotStrokeWidth ?? this.activeDotStrokeWidth,
    );
  }
}
