import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:recharts_flutter/src/core/utils/cartesian_utils.dart';

void main() {
  group('Coordinate', () {
    test('creates coordinate with x and y', () {
      const coord = Coordinate(10, 20);
      expect(coord.x, 10);
      expect(coord.y, 20);
    });

    test('equality works correctly', () {
      const coord1 = Coordinate(10, 20);
      const coord2 = Coordinate(10, 20);
      const coord3 = Coordinate(10, 30);

      expect(coord1, equals(coord2));
      expect(coord1, isNot(equals(coord3)));
    });
  });

  group('rectWithPoints', () {
    test('creates rect from two points', () {
      final rect = rectWithPoints(
        const Coordinate(10, 20),
        const Coordinate(50, 60),
      );

      expect(rect.left, 10);
      expect(rect.top, 20);
      expect(rect.width, 40);
      expect(rect.height, 40);
    });

    test('handles reversed points', () {
      final rect = rectWithPoints(
        const Coordinate(50, 60),
        const Coordinate(10, 20),
      );

      expect(rect.left, 10);
      expect(rect.top, 20);
      expect(rect.width, 40);
      expect(rect.height, 40);
    });

    test('handles same x or y coordinates', () {
      final rect = rectWithPoints(
        const Coordinate(10, 20),
        const Coordinate(10, 60),
      );

      expect(rect.left, 10);
      expect(rect.width, 0);
      expect(rect.height, 40);
    });
  });

  group('rectWithCoords', () {
    test('creates rect from coordinates', () {
      final rect = rectWithCoords(x1: 10, y1: 20, x2: 50, y2: 60);

      expect(rect.left, 10);
      expect(rect.top, 20);
      expect(rect.width, 40);
      expect(rect.height, 40);
    });

    test('handles reversed coordinates', () {
      final rect = rectWithCoords(x1: 50, y1: 60, x2: 10, y2: 20);

      expect(rect.left, 10);
      expect(rect.top, 20);
      expect(rect.width, 40);
      expect(rect.height, 40);
    });
  });

  group('normalizeAngle', () {
    test('normalizes angles to 0-180 range', () {
      expect(normalizeAngle(0), 0);
      expect(normalizeAngle(90), 90);
      expect(normalizeAngle(180), 0);
      expect(normalizeAngle(270), 90);
      expect(normalizeAngle(360), 0);
    });

    test('handles negative angles', () {
      expect(normalizeAngle(-90), 90);
      expect(normalizeAngle(-180), 0);
    });
  });

  group('getAngledRectangleWidth', () {
    test('returns width for 0 degrees', () {
      final result = getAngledRectangleWidth(const Size(100, 50), 0);
      expect(result, 100);
    });

    test('returns height/sin(angle) for 90 degrees', () {
      final result = getAngledRectangleWidth(const Size(100, 50), 90);
      expect(result, closeTo(50, 0.0001));
    });

    test('handles negative angles', () {
      final result1 = getAngledRectangleWidth(const Size(100, 50), 45);
      final result2 = getAngledRectangleWidth(const Size(100, 50), -45);
      expect(result1, closeTo(result2, 0.0001));
    });
  });

  group('ScaleHelper', () {
    test('creates helper from scale', () {
      final mockScale = _MockScale([0, 100], [0, 1000]);
      final helper = ScaleHelper.create(mockScale);

      expect(helper.domain, [0, 100]);
      expect(helper.range, [0, 1000]);
      expect(helper.rangeMin, 0);
      expect(helper.rangeMax, 1000);
    });

    test('applies scale with position=middle', () {
      final mockScale = _MockScaleWithBandwidth([0, 100], [0, 1000], 50);
      final helper = ScaleHelper(mockScale);

      final result = helper.apply(50, position: 'middle');
      expect(result, closeTo(500 + 25, 0.0001));
    });

    test('checks if value is in range', () {
      final mockScale = _MockScale([0, 100], [0, 1000]);
      final helper = ScaleHelper(mockScale);

      expect(helper.isInRange(500), true);
      expect(helper.isInRange(0), true);
      expect(helper.isInRange(1000), true);
      expect(helper.isInRange(-1), false);
      expect(helper.isInRange(1001), false);
    });
  });
}

class _MockScale {
  final List<num> domain;
  final List<num> range;

  _MockScale(this.domain, this.range);

  double? get bandwidth => null;

  double call(num value) {
    final d0 = domain.first;
    final d1 = domain.last;
    final r0 = range.first;
    final r1 = range.last;
    final t = (value - d0) / (d1 - d0);
    return (r0 + t * (r1 - r0)).toDouble();
  }
}

class _MockScaleWithBandwidth extends _MockScale {
  @override
  final double bandwidth;

  _MockScaleWithBandwidth(super.domain, super.range, this.bandwidth);
}
