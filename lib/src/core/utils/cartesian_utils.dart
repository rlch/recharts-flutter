import 'dart:math' as math;
import 'dart:ui';

class Coordinate {
  final double x;
  final double y;

  const Coordinate(this.x, this.y);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Coordinate && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'Coordinate($x, $y)';
}

Rect rectWithPoints(Coordinate p1, Coordinate p2) {
  return Rect.fromLTWH(
    math.min(p1.x, p2.x),
    math.min(p1.y, p2.y),
    (p2.x - p1.x).abs(),
    (p2.y - p1.y).abs(),
  );
}

Rect rectWithCoords({
  required double x1,
  required double y1,
  required double x2,
  required double y2,
}) {
  return rectWithPoints(Coordinate(x1, y1), Coordinate(x2, y2));
}

double normalizeAngle(double angle) {
  return ((angle % 180) + 180) % 180;
}

double getAngledRectangleWidth(Size size, [double angle = 0]) {
  final normalizedAngle = normalizeAngle(angle);
  final angleRadians = normalizedAngle * math.pi / 180;

  final angleThreshold = math.atan(size.height / size.width);

  final angledWidth =
      angleRadians > angleThreshold && angleRadians < math.pi - angleThreshold
          ? size.height / math.sin(angleRadians)
          : size.width / math.cos(angleRadians);

  return angledWidth.abs();
}

class ScaleHelper {
  static const double eps = 1e-4;

  final dynamic _scale;

  ScaleHelper(this._scale);

  static ScaleHelper create(dynamic scale) => ScaleHelper(scale);

  List<num> get domain => _scale.domain;
  List<num> get range => _scale.range;
  num get rangeMin => range[0];
  num get rangeMax => range[range.length - 1];
  double? get bandwidth => _scale.bandwidth;

  double? apply(
    dynamic value, {
    bool bandAware = false,
    String? position,
  }) {
    if (value == null) return null;

    if (position != null) {
      switch (position) {
        case 'start':
          return _scale.call(value);
        case 'middle':
          final offset = bandwidth != null ? bandwidth! / 2 : 0.0;
          return _scale.call(value) + offset;
        case 'end':
          final offset = bandwidth ?? 0.0;
          return _scale.call(value) + offset;
        default:
          return _scale.call(value);
      }
    }

    if (bandAware) {
      final offset = bandwidth != null ? bandwidth! / 2 : 0.0;
      return _scale.call(value) + offset;
    }

    return _scale.call(value);
  }

  bool isInRange(num value) {
    final first = range[0];
    final last = range[range.length - 1];
    return first <= last
        ? value >= first && value <= last
        : value >= last && value <= first;
  }
}
