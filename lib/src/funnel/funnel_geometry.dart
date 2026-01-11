import 'dart:ui';

class TrapezoidGeometry {
  final int index;
  final double x;
  final double y;
  final double width;
  final double height;
  final double upperWidth;
  final double lowerWidth;
  final Color color;
  final String? label;
  final dynamic value;

  const TrapezoidGeometry({
    required this.index,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.upperWidth,
    required this.lowerWidth,
    required this.color,
    this.label,
    this.value,
  });

  Path toPath() {
    final path = Path();
    final centerX = x + width / 2;
    final top = y;
    final bottom = y + height;
    final halfUpper = upperWidth / 2;
    final halfLower = lowerWidth / 2;

    path.moveTo(centerX - halfUpper, top);
    path.lineTo(centerX + halfUpper, top);
    path.lineTo(centerX + halfLower, bottom);
    path.lineTo(centerX - halfLower, bottom);
    path.close();

    return path;
  }

  Offset get center => Offset(x + width / 2, y + height / 2);
}

class FunnelLayout {
  final double x;
  final double y;
  final double width;
  final double height;

  const FunnelLayout({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  factory FunnelLayout.compute({
    required double chartWidth,
    required double chartHeight,
    double padding = 20,
  }) {
    return FunnelLayout(
      x: padding,
      y: padding,
      width: chartWidth - padding * 2,
      height: chartHeight - padding * 2,
    );
  }
}
