import 'dart:math' as math;
import 'dart:ui';

class PolarLayout {
  final double width;
  final double height;
  final double cx;
  final double cy;
  final double maxRadius;
  final double innerRadius;
  final double outerRadius;

  const PolarLayout({
    required this.width,
    required this.height,
    required this.cx,
    required this.cy,
    required this.maxRadius,
    required this.innerRadius,
    required this.outerRadius,
  });

  factory PolarLayout.compute({
    required double width,
    required double height,
    double padding = 20,
    double? innerRadiusPercent,
    double? outerRadiusPercent,
  }) {
    final cx = width / 2;
    final cy = height / 2;
    final maxRadius = math.min(width, height) / 2 - padding;

    final outerRadius = maxRadius * (outerRadiusPercent ?? 0.8);
    final innerRadius = outerRadius * (innerRadiusPercent ?? 0);

    return PolarLayout(
      width: width,
      height: height,
      cx: cx,
      cy: cy,
      maxRadius: maxRadius,
      innerRadius: innerRadius,
      outerRadius: outerRadius,
    );
  }

  Offset get center => Offset(cx, cy);

  Rect get bounds => Rect.fromCenter(
        center: center,
        width: outerRadius * 2,
        height: outerRadius * 2,
      );
}
