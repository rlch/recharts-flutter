import 'package:flutter_test/flutter_test.dart';
import 'package:recharts_flutter/src/core/utils/polar_utils.dart';
import 'package:recharts_flutter/src/core/utils/cartesian_utils.dart';

void main() {
  group('PolarUtils', () {
    group('degreeToRadian', () {
      test('converts 0 degrees to 0 radians', () {
        expect(degreeToRadian(0), equals(0));
      });

      test('converts 90 degrees to pi/2 radians', () {
        expect(degreeToRadian(90), closeTo(1.5707963267948966, 0.0001));
      });

      test('converts 180 degrees to pi radians', () {
        expect(degreeToRadian(180), closeTo(3.141592653589793, 0.0001));
      });

      test('converts 360 degrees to 2*pi radians', () {
        expect(degreeToRadian(360), closeTo(6.283185307179586, 0.0001));
      });
    });

    group('radianToDegree', () {
      test('converts 0 radians to 0 degrees', () {
        expect(radianToDegree(0), equals(0));
      });

      test('converts pi/2 radians to 90 degrees', () {
        expect(radianToDegree(1.5707963267948966), closeTo(90, 0.0001));
      });

      test('converts pi radians to 180 degrees', () {
        expect(radianToDegree(3.141592653589793), closeTo(180, 0.0001));
      });
    });

    group('polarToCartesian', () {
      test('converts center point correctly', () {
        final result = polarToCartesian(100, 100, 0, 0);
        expect(result.x, closeTo(100, 0.0001));
        expect(result.y, closeTo(100, 0.0001));
      });

      test('converts point at 0 degrees correctly', () {
        final result = polarToCartesian(100, 100, 50, 0);
        expect(result.x, closeTo(150, 0.0001));
        expect(result.y, closeTo(100, 0.0001));
      });

      test('converts point at 90 degrees correctly', () {
        final result = polarToCartesian(100, 100, 50, 90);
        expect(result.x, closeTo(100, 0.0001));
        expect(result.y, closeTo(50, 0.0001));
      });

      test('converts point at 180 degrees correctly', () {
        final result = polarToCartesian(100, 100, 50, 180);
        expect(result.x, closeTo(50, 0.0001));
        expect(result.y, closeTo(100, 0.0001));
      });

      test('converts point at 270 degrees correctly', () {
        final result = polarToCartesian(100, 100, 50, 270);
        expect(result.x, closeTo(100, 0.0001));
        expect(result.y, closeTo(150, 0.0001));
      });
    });

    group('getMaxRadius', () {
      test('returns half of min dimension for square', () {
        final result = getMaxRadius(200, 200);
        expect(result, equals(100));
      });

      test('returns half of min dimension for rectangle', () {
        final result = getMaxRadius(300, 200);
        expect(result, equals(100));
      });

      test('accounts for offset', () {
        final result = getMaxRadius(
            200, 200, const ChartOffset(left: 20, right: 20, top: 10, bottom: 10));
        expect(result, equals(80));
      });
    });

    group('distanceBetweenPoints', () {
      test('returns 0 for same point', () {
        final result = distanceBetweenPoints(
          const Coordinate(100, 100),
          const Coordinate(100, 100),
        );
        expect(result, equals(0));
      });

      test('returns correct distance for horizontal', () {
        final result = distanceBetweenPoints(
          const Coordinate(0, 0),
          const Coordinate(3, 0),
        );
        expect(result, equals(3));
      });

      test('returns correct distance for vertical', () {
        final result = distanceBetweenPoints(
          const Coordinate(0, 0),
          const Coordinate(0, 4),
        );
        expect(result, equals(4));
      });

      test('returns correct distance for diagonal (3-4-5 triangle)', () {
        final result = distanceBetweenPoints(
          const Coordinate(0, 0),
          const Coordinate(3, 4),
        );
        expect(result, equals(5));
      });
    });

    group('getAngleOfPoint', () {
      test('returns null angle for center point', () {
        final result = getAngleOfPoint(
          const Coordinate(100, 100),
          const GeometrySector(
            cx: 100,
            cy: 100,
            innerRadius: 0,
            outerRadius: 50,
            startAngle: 0,
            endAngle: 360,
          ),
        );
        expect(result.radius, equals(0));
        expect(result.angle, isNull);
      });

      test('returns 0 degrees for point to the right', () {
        final result = getAngleOfPoint(
          const Coordinate(150, 100),
          const GeometrySector(
            cx: 100,
            cy: 100,
            innerRadius: 0,
            outerRadius: 50,
            startAngle: 0,
            endAngle: 360,
          ),
        );
        expect(result.radius, equals(50));
        expect(result.angle, closeTo(0, 0.0001));
      });

      test('returns 90 degrees for point above', () {
        final result = getAngleOfPoint(
          const Coordinate(100, 50),
          const GeometrySector(
            cx: 100,
            cy: 100,
            innerRadius: 0,
            outerRadius: 50,
            startAngle: 0,
            endAngle: 360,
          ),
        );
        expect(result.radius, equals(50));
        expect(result.angle, closeTo(90, 0.0001));
      });
    });
  });

  group('inRangeOfSector', () {
    test('returns null for point outside outer radius', () {
      final result = inRangeOfSector(
        const Coordinate(200, 100),
        const GeometrySector(
          cx: 100,
          cy: 100,
          innerRadius: 20,
          outerRadius: 50,
          startAngle: 0,
          endAngle: 90,
        ),
      );
      expect(result, isNull);
    });

    test('returns null for point inside inner radius', () {
      final result = inRangeOfSector(
        const Coordinate(110, 100),
        const GeometrySector(
          cx: 100,
          cy: 100,
          innerRadius: 20,
          outerRadius: 50,
          startAngle: 0,
          endAngle: 90,
        ),
      );
      expect(result, isNull);
    });

    test('returns null for point outside angle range', () {
      final result = inRangeOfSector(
        const Coordinate(100, 150),
        const GeometrySector(
          cx: 100,
          cy: 100,
          innerRadius: 20,
          outerRadius: 80,
          startAngle: 0,
          endAngle: 90,
        ),
      );
      expect(result, isNull);
    });

    test('returns sector info for point inside sector', () {
      final result = inRangeOfSector(
        const Coordinate(130, 80),
        const GeometrySector(
          cx: 100,
          cy: 100,
          innerRadius: 20,
          outerRadius: 50,
          startAngle: 0,
          endAngle: 90,
        ),
      );
      expect(result, isNotNull);
      expect(result!.cx, equals(100));
      expect(result.cy, equals(100));
    });

    test('handles full circle sector', () {
      final result = inRangeOfSector(
        const Coordinate(130, 100),
        const GeometrySector(
          cx: 100,
          cy: 100,
          innerRadius: 0,
          outerRadius: 50,
          startAngle: 0,
          endAngle: 360,
        ),
      );
      expect(result, isNotNull);
    });

    test('handles negative angle range', () {
      final result = inRangeOfSector(
        const Coordinate(100, 130),
        const GeometrySector(
          cx: 100,
          cy: 100,
          innerRadius: 20,
          outerRadius: 50,
          startAngle: 90,
          endAngle: -90,
        ),
      );
      expect(result, isNotNull);
    });
  });

  group('formatAngleOfSector', () {
    test('normalizes angles greater than 360', () {
      final result = formatAngleOfSector(const GeometrySector(
        cx: 0,
        cy: 0,
        innerRadius: 0,
        outerRadius: 50,
        startAngle: 400,
        endAngle: 500,
      ));
      expect(result.startAngle, closeTo(40, 0.0001));
      expect(result.endAngle, closeTo(140, 0.0001));
    });

    test('handles negative angles', () {
      final result = formatAngleOfSector(const GeometrySector(
        cx: 0,
        cy: 0,
        innerRadius: 0,
        outerRadius: 50,
        startAngle: -90,
        endAngle: 90,
      ));
      expect(result.startAngle, closeTo(270, 0.0001));
      expect(result.endAngle, closeTo(450, 0.0001));
    });
  });
}
