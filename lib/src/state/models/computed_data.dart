import 'dart:ui';

class LinePoint {
  final int index;
  final double x;
  final double y;
  final dynamic value;
  final bool isNull;

  const LinePoint({
    required this.index,
    required this.x,
    required this.y,
    this.value,
    this.isNull = false,
  });

  Offset get offset => Offset(x, y);
}

class AreaPoint {
  final int index;
  final double x;
  final double y;
  final double? baseX;
  final double baseY;
  final dynamic value;
  final bool isNull;

  const AreaPoint({
    required this.index,
    required this.x,
    required this.y,
    this.baseX,
    required this.baseY,
    this.value,
    this.isNull = false,
  });

  Offset get topOffset => Offset(x, y);
  Offset get bottomOffset => Offset(baseX ?? x, baseY);
}

class BarRect {
  final int index;
  final Rect rect;
  final dynamic value;
  final String dataKey;

  const BarRect({
    required this.index,
    required this.rect,
    this.value,
    required this.dataKey,
  });
}

class ComputedSeriesData {
  final String dataKey;
  final List<LinePoint>? linePoints;
  final List<AreaPoint>? areaPoints;
  final List<BarRect>? barRects;

  const ComputedSeriesData({
    required this.dataKey,
    this.linePoints,
    this.areaPoints,
    this.barRects,
  });
}
