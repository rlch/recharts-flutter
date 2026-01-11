import 'dart:ui';

import '../../core/types/series_types.dart';

class LegendEntry {
  final String dataKey;
  final String name;
  final Color color;
  final LegendType iconType;
  final bool visible;

  const LegendEntry({
    required this.dataKey,
    required this.name,
    required this.color,
    this.iconType = LegendType.square,
    this.visible = true,
  });

  LegendEntry copyWith({
    String? dataKey,
    String? name,
    Color? color,
    LegendType? iconType,
    bool? visible,
  }) {
    return LegendEntry(
      dataKey: dataKey ?? this.dataKey,
      name: name ?? this.name,
      color: color ?? this.color,
      iconType: iconType ?? this.iconType,
      visible: visible ?? this.visible,
    );
  }

  LegendEntry toggleVisibility() {
    return copyWith(visible: !visible);
  }
}
