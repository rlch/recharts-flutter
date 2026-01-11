import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:recharts_flutter/src/core/animation/geometry_interpolation.dart';

void main() {
  group('lerpOffset', () {
    test('returns start at t=0', () {
      final result = lerpOffset(const Offset(0, 0), const Offset(100, 100), 0);
      expect(result, equals(const Offset(0, 0)));
    });

    test('returns end at t=1', () {
      final result = lerpOffset(const Offset(0, 0), const Offset(100, 100), 1);
      expect(result, equals(const Offset(100, 100)));
    });

    test('returns midpoint at t=0.5', () {
      final result =
          lerpOffset(const Offset(0, 0), const Offset(100, 100), 0.5);
      expect(result, equals(const Offset(50, 50)));
    });
  });

  group('interpolatePoints', () {
    test('returns empty list for two empty lists', () {
      final result = interpolatePoints([], [], 0.5);
      expect(result, isEmpty);
    });

    test('animates from anchor when from is empty', () {
      final to = [const Offset(0, 0), const Offset(100, 0), const Offset(200, 0)];

      final resultStart = interpolatePoints([], to, 0);
      expect(resultStart[0], equals(const Offset(0, 0)));
      expect(resultStart[1], equals(const Offset(0, 0)));
      expect(resultStart[2], equals(const Offset(0, 0)));

      final resultEnd = interpolatePoints([], to, 1);
      expect(resultEnd[0], equals(const Offset(0, 0)));
      expect(resultEnd[1], equals(const Offset(100, 0)));
      expect(resultEnd[2], equals(const Offset(200, 0)));
    });

    test('collapses to anchor when to is empty', () {
      final from = [const Offset(0, 0), const Offset(100, 0), const Offset(200, 0)];

      final resultStart = interpolatePoints(from, [], 0);
      expect(resultStart[0], equals(const Offset(0, 0)));
      expect(resultStart[1], equals(const Offset(100, 0)));
      expect(resultStart[2], equals(const Offset(200, 0)));

      final resultEnd = interpolatePoints(from, [], 1);
      expect(resultEnd[0], equals(const Offset(200, 0)));
      expect(resultEnd[1], equals(const Offset(200, 0)));
      expect(resultEnd[2], equals(const Offset(200, 0)));
    });

    test('interpolates between equal length lists', () {
      final from = [const Offset(0, 0), const Offset(100, 0)];
      final to = [const Offset(0, 100), const Offset(100, 100)];

      final result = interpolatePoints(from, to, 0.5);
      expect(result.length, equals(2));
      expect(result[0], equals(const Offset(0, 50)));
      expect(result[1], equals(const Offset(100, 50)));
    });

    test('handles from list shorter than to list', () {
      final from = [const Offset(0, 0)];
      final to = [const Offset(0, 100), const Offset(100, 100)];

      final result = interpolatePoints(from, to, 1);
      expect(result.length, equals(2));
      expect(result[0], equals(const Offset(0, 100)));
      expect(result[1], equals(const Offset(100, 100)));
    });

    test('handles to list shorter than from list', () {
      final from = [const Offset(0, 0), const Offset(100, 0)];
      final to = [const Offset(0, 100)];

      final result = interpolatePoints(from, to, 1);
      expect(result.length, equals(2));
      expect(result[0], equals(const Offset(0, 100)));
      expect(result[1], equals(const Offset(0, 100)));
    });
  });

  group('lerpRect', () {
    test('returns start at t=0', () {
      final result = lerpRect(
        const Rect.fromLTWH(0, 0, 10, 10),
        const Rect.fromLTWH(100, 100, 50, 50),
        0,
      );
      expect(result, equals(const Rect.fromLTWH(0, 0, 10, 10)));
    });

    test('returns end at t=1', () {
      final result = lerpRect(
        const Rect.fromLTWH(0, 0, 10, 10),
        const Rect.fromLTWH(100, 100, 50, 50),
        1,
      );
      expect(result, equals(const Rect.fromLTWH(100, 100, 50, 50)));
    });

    test('returns midpoint at t=0.5', () {
      final result = lerpRect(
        const Rect.fromLTWH(0, 0, 10, 10),
        const Rect.fromLTWH(100, 100, 50, 50),
        0.5,
      );
      expect(result, equals(const Rect.fromLTWH(50, 50, 30, 30)));
    });
  });

  group('interpolateRects', () {
    test('returns empty list for two empty lists', () {
      final result = interpolateRects([], [], 0.5);
      expect(result, isEmpty);
    });

    test('animates bars from zero height when from is empty', () {
      final to = [
        const Rect.fromLTWH(0, 50, 10, 50),
        const Rect.fromLTWH(20, 30, 10, 70),
      ];

      final resultStart = interpolateRects([], to, 0);
      expect(resultStart[0].height, equals(0));
      expect(resultStart[0].bottom, equals(100));
      expect(resultStart[1].height, equals(0));
      expect(resultStart[1].bottom, equals(100));

      final resultEnd = interpolateRects([], to, 1);
      expect(resultEnd[0], equals(to[0]));
      expect(resultEnd[1], equals(to[1]));
    });

    test('collapses bars to zero height when to is empty', () {
      final from = [
        const Rect.fromLTWH(0, 50, 10, 50),
        const Rect.fromLTWH(20, 30, 10, 70),
      ];

      final resultStart = interpolateRects(from, [], 0);
      expect(resultStart[0], equals(from[0]));
      expect(resultStart[1], equals(from[1]));

      final resultEnd = interpolateRects(from, [], 1);
      expect(resultEnd[0].height, equals(0));
      expect(resultEnd[1].height, equals(0));
    });

    test('interpolates between equal length rect lists', () {
      final from = [const Rect.fromLTWH(0, 100, 10, 0)];
      final to = [const Rect.fromLTWH(0, 50, 10, 50)];

      final result = interpolateRects(from, to, 0.5);
      expect(result.length, equals(1));
      expect(result[0].top, closeTo(75, 0.1));
      expect(result[0].height, closeTo(25, 0.1));
    });

    test('handles different length lists', () {
      final from = [const Rect.fromLTWH(0, 50, 10, 50)];
      final to = [
        const Rect.fromLTWH(0, 50, 10, 50),
        const Rect.fromLTWH(20, 50, 10, 50),
      ];

      final result = interpolateRects(from, to, 1);
      expect(result.length, equals(2));
    });
  });

  group('AnimatedAreaData', () {
    test('stores top and bottom points', () {
      final data = AnimatedAreaData(
        topPoints: [const Offset(0, 0), const Offset(100, 0)],
        bottomPoints: [const Offset(0, 100), const Offset(100, 100)],
      );

      expect(data.topPoints.length, equals(2));
      expect(data.bottomPoints.length, equals(2));
    });
  });

  group('interpolateAreaPoints', () {
    test('interpolates both top and bottom points', () {
      final from = AnimatedAreaData(
        topPoints: [const Offset(0, 50)],
        bottomPoints: [const Offset(0, 100)],
      );
      final to = AnimatedAreaData(
        topPoints: [const Offset(0, 0)],
        bottomPoints: [const Offset(0, 100)],
      );

      final result = interpolateAreaPoints(from, to, 0.5);
      expect(result.topPoints[0].dy, equals(25));
      expect(result.bottomPoints[0].dy, equals(100));
    });
  });
}
