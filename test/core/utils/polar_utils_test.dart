import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:recharts_flutter/src/core/utils/polar_utils.dart';
import 'package:recharts_flutter/src/core/utils/cartesian_utils.dart';

void main() {
  group('radian constant', () {
    test('equals pi/180', () {
      expect(radian, math.pi / 180);
    });
  });

  group('degreeToRadian', () {
    test('converts degrees to radians', () {
      expect(degreeToRadian(0), 0);
      expect(degreeToRadian(90), closeTo(math.pi / 2, 0.0001));
      expect(degreeToRadian(180), closeTo(math.pi, 0.0001));
      expect(degreeToRadian(360), closeTo(2 * math.pi, 0.0001));
    });

    test('handles negative angles', () {
      expect(degreeToRadian(-90), closeTo(-math.pi / 2, 0.0001));
    });
  });

  group('radianToDegree', () {
    test('converts radians to degrees', () {
      expect(radianToDegree(0), 0);
      expect(radianToDegree(math.pi / 2), closeTo(90, 0.0001));
      expect(radianToDegree(math.pi), closeTo(180, 0.0001));
      expect(radianToDegree(2 * math.pi), closeTo(360, 0.0001));
    });
  });

  group('polarToCartesian', () {
    test('converts polar coordinates at 0 degrees', () {
      final result = polarToCartesian(0, 0, 100, 0);
      expect(result.x, closeTo(100, 0.0001));
      expect(result.y, closeTo(0, 0.0001));
    });

    test('converts polar coordinates at 90 degrees', () {
      final result = polarToCartesian(0, 0, 100, 90);
      expect(result.x, closeTo(0, 0.0001));
      expect(result.y, closeTo(-100, 0.0001));
    });

    test('handles center offset', () {
      final result = polarToCartesian(50, 50, 100, 0);
      expect(result.x, closeTo(150, 0.0001));
      expect(result.y, closeTo(50, 0.0001));
    });
  });

  group('ChartOffset', () {
    test('creates with default values', () {
      const offset = ChartOffset();
      expect(offset.top, 0);
      expect(offset.right, 0);
      expect(offset.bottom, 0);
      expect(offset.left, 0);
    });

    test('creates with custom values', () {
      const offset = ChartOffset(top: 10, right: 20, bottom: 30, left: 40);
      expect(offset.top, 10);
      expect(offset.right, 20);
      expect(offset.bottom, 30);
      expect(offset.left, 40);
    });
  });

  group('getMaxRadius', () {
    test('returns half of smaller dimension', () {
      expect(getMaxRadius(200, 100), 50);
      expect(getMaxRadius(100, 200), 50);
      expect(getMaxRadius(100, 100), 50);
    });

    test('accounts for offset', () {
      const offset = ChartOffset(top: 10, right: 10, bottom: 10, left: 10);
      expect(getMaxRadius(200, 100, offset), 40);
    });
  });

  group('distanceBetweenPoints', () {
    test('calculates distance correctly', () {
      expect(
        distanceBetweenPoints(
          const Coordinate(0, 0),
          const Coordinate(3, 4),
        ),
        5,
      );

      expect(
        distanceBetweenPoints(
          const Coordinate(1, 1),
          const Coordinate(4, 5),
        ),
        5,
      );
    });

    test('returns 0 for same point', () {
      expect(
        distanceBetweenPoints(
          const Coordinate(5, 5),
          const Coordinate(5, 5),
        ),
        0,
      );
    });
  });

  group('GeometrySector', () {
    test('creates sector with all properties', () {
      const sector = GeometrySector(
        cx: 100,
        cy: 100,
        innerRadius: 50,
        outerRadius: 100,
        startAngle: 0,
        endAngle: 90,
      );

      expect(sector.cx, 100);
      expect(sector.cy, 100);
      expect(sector.innerRadius, 50);
      expect(sector.outerRadius, 100);
      expect(sector.startAngle, 0);
      expect(sector.endAngle, 90);
    });

    test('copyWith updates specified properties', () {
      const sector = GeometrySector(
        cx: 100,
        cy: 100,
        innerRadius: 50,
        outerRadius: 100,
        startAngle: 0,
        endAngle: 90,
      );

      final updated = sector.copyWith(cx: 200, endAngle: 180);
      expect(updated.cx, 200);
      expect(updated.cy, 100);
      expect(updated.endAngle, 180);
    });
  });

  group('getAngleOfPoint', () {
    test('returns radius 0 for center point', () {
      const sector = GeometrySector(
        cx: 100,
        cy: 100,
        innerRadius: 0,
        outerRadius: 100,
        startAngle: 0,
        endAngle: 360,
      );

      final result = getAngleOfPoint(const Coordinate(100, 100), sector);
      expect(result.radius, 0);
      expect(result.angle, isNull);
    });

    test('calculates angle for point on right', () {
      const sector = GeometrySector(
        cx: 100,
        cy: 100,
        innerRadius: 0,
        outerRadius: 100,
        startAngle: 0,
        endAngle: 360,
      );

      final result = getAngleOfPoint(const Coordinate(200, 100), sector);
      expect(result.radius, closeTo(100, 0.0001));
      expect(result.angle, closeTo(0, 0.0001));
    });
  });

  group('formatAngleOfSector', () {
    test('normalizes angles', () {
      const sector = GeometrySector(
        cx: 0,
        cy: 0,
        innerRadius: 0,
        outerRadius: 100,
        startAngle: 400,
        endAngle: 450,
      );

      final result = formatAngleOfSector(sector);
      expect(result.startAngle, closeTo(40, 0.0001));
      expect(result.endAngle, closeTo(90, 0.0001));
    });
  });

  group('inRangeOfSector', () {
    test('returns null for point outside radius', () {
      const sector = GeometrySector(
        cx: 100,
        cy: 100,
        innerRadius: 20,
        outerRadius: 50,
        startAngle: 0,
        endAngle: 90,
      );

      expect(inRangeOfSector(const Coordinate(100, 100), sector), isNull);
      expect(inRangeOfSector(const Coordinate(200, 100), sector), isNull);
    });

    test('returns result for point in sector', () {
      const sector = GeometrySector(
        cx: 100,
        cy: 100,
        innerRadius: 0,
        outerRadius: 50,
        startAngle: 0,
        endAngle: 360,
      );

      final result = inRangeOfSector(const Coordinate(130, 100), sector);
      expect(result, isNotNull);
      expect(result!.radius, closeTo(30, 0.0001));
    });

    test('returns result with angle for center with full circle', () {
      const sector = GeometrySector(
        cx: 100,
        cy: 100,
        innerRadius: 0,
        outerRadius: 50,
        startAngle: 0,
        endAngle: 360,
      );

      final result = inRangeOfSector(const Coordinate(100, 100), sector);
      expect(result, isNotNull);
      expect(result!.radius, 0);
    });
  });
}
