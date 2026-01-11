import 'dart:ui';

class SectorGeometry {
  final int index;
  final double cx;
  final double cy;
  final double innerRadius;
  final double outerRadius;
  final double startAngle;
  final double endAngle;
  final double value;
  final double percent;
  final String? name;
  final Color color;

  const SectorGeometry({
    required this.index,
    required this.cx,
    required this.cy,
    required this.innerRadius,
    required this.outerRadius,
    required this.startAngle,
    required this.endAngle,
    required this.value,
    required this.percent,
    this.name,
    required this.color,
  });

  double get midAngle => (startAngle + endAngle) / 2;
  double get angleSpan => (endAngle - startAngle).abs();

  SectorGeometry copyWith({
    int? index,
    double? cx,
    double? cy,
    double? innerRadius,
    double? outerRadius,
    double? startAngle,
    double? endAngle,
    double? value,
    double? percent,
    String? name,
    Color? color,
  }) {
    return SectorGeometry(
      index: index ?? this.index,
      cx: cx ?? this.cx,
      cy: cy ?? this.cy,
      innerRadius: innerRadius ?? this.innerRadius,
      outerRadius: outerRadius ?? this.outerRadius,
      startAngle: startAngle ?? this.startAngle,
      endAngle: endAngle ?? this.endAngle,
      value: value ?? this.value,
      percent: percent ?? this.percent,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }
}

class RadarPoint {
  final int index;
  final double x;
  final double y;
  final double angle;
  final double radius;
  final double value;
  final String? name;

  const RadarPoint({
    required this.index,
    required this.x,
    required this.y,
    required this.angle,
    required this.radius,
    required this.value,
    this.name,
  });

  Offset get offset => Offset(x, y);
}

class RadialBarGeometry {
  final int index;
  final double cx;
  final double cy;
  final double innerRadius;
  final double outerRadius;
  final double startAngle;
  final double endAngle;
  final double value;
  final double maxValue;
  final String? name;
  final Color color;

  const RadialBarGeometry({
    required this.index,
    required this.cx,
    required this.cy,
    required this.innerRadius,
    required this.outerRadius,
    required this.startAngle,
    required this.endAngle,
    required this.value,
    required this.maxValue,
    this.name,
    required this.color,
  });

  double get midAngle => (startAngle + endAngle) / 2;
  double get percent => maxValue > 0 ? value / maxValue : 0;
}
