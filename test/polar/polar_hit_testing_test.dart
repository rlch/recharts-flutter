import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:recharts_flutter/src/state/controllers/polar_hit_testing.dart';
import 'package:recharts_flutter/src/state/models/polar_data.dart';

void main() {
  group('findPieSectorAtPoint', () {
    late List<SectorGeometry> sectors;

    setUp(() {
      sectors = [
        const SectorGeometry(
          index: 0,
          cx: 200,
          cy: 200,
          innerRadius: 0,
          outerRadius: 100,
          startAngle: 0,
          endAngle: 120,
          value: 100,
          percent: 0.333,
          name: 'A',
          color: Color(0xFFFF0000),
        ),
        const SectorGeometry(
          index: 1,
          cx: 200,
          cy: 200,
          innerRadius: 0,
          outerRadius: 100,
          startAngle: 120,
          endAngle: 240,
          value: 100,
          percent: 0.333,
          name: 'B',
          color: Color(0xFF00FF00),
        ),
        const SectorGeometry(
          index: 2,
          cx: 200,
          cy: 200,
          innerRadius: 0,
          outerRadius: 100,
          startAngle: 240,
          endAngle: 360,
          value: 100,
          percent: 0.333,
          name: 'C',
          color: Color(0xFF0000FF),
        ),
      ];
    });

    test('returns null for point outside chart', () {
      final result = findPieSectorAtPoint(const Offset(400, 400), sectors);
      expect(result, isNull);
    });

    test('returns null for point at center of donut', () {
      final donutSectors = sectors.map((s) => s.copyWith(innerRadius: 50)).toList();
      final result = findPieSectorAtPoint(const Offset(200, 200), donutSectors);
      expect(result, isNull);
    });

    test('finds correct sector for point in first slice', () {
      final result = findPieSectorAtPoint(const Offset(250, 180), sectors);
      expect(result, equals(0));
    });

    test('finds correct sector for point in second slice', () {
      final result = findPieSectorAtPoint(const Offset(150, 250), sectors);
      expect(result, equals(1));
    });

    test('finds correct sector for point in third slice', () {
      final result = findPieSectorAtPoint(const Offset(250, 250), sectors);
      expect(result, equals(2));
    });

    test('returns null for empty sectors list', () {
      final result = findPieSectorAtPoint(const Offset(200, 200), []);
      expect(result, isNull);
    });
  });

  group('findRadialBarAtPoint', () {
    late List<RadialBarGeometry> bars;

    setUp(() {
      bars = [
        const RadialBarGeometry(
          index: 0,
          cx: 200,
          cy: 200,
          innerRadius: 30,
          outerRadius: 50,
          startAngle: 90,
          endAngle: -90,
          value: 100,
          maxValue: 100,
          name: 'A',
          color: Color(0xFFFF0000),
        ),
        const RadialBarGeometry(
          index: 1,
          cx: 200,
          cy: 200,
          innerRadius: 60,
          outerRadius: 80,
          startAngle: 90,
          endAngle: -45,
          value: 75,
          maxValue: 100,
          name: 'B',
          color: Color(0xFF00FF00),
        ),
      ];
    });

    test('returns null for point outside all bars', () {
      final result = findRadialBarAtPoint(const Offset(400, 400), bars);
      expect(result, isNull);
    });

    test('finds correct bar for point in inner bar', () {
      final result = findRadialBarAtPoint(const Offset(200, 160), bars);
      expect(result, equals(0));
    });

    test('finds correct bar for point in outer bar', () {
      final result = findRadialBarAtPoint(const Offset(200, 130), bars);
      expect(result, equals(1));
    });

    test('returns null for point between bars', () {
      final result = findRadialBarAtPoint(const Offset(200, 145), bars);
      expect(result, isNull);
    });
  });

  group('findRadarPointAtPoint', () {
    late List<RadarPoint> points;

    setUp(() {
      points = [
        const RadarPoint(
          index: 0,
          x: 200,
          y: 100,
          angle: 90,
          radius: 100,
          value: 100,
          name: 'A',
        ),
        const RadarPoint(
          index: 1,
          x: 280,
          y: 150,
          angle: 30,
          radius: 80,
          value: 80,
          name: 'B',
        ),
        const RadarPoint(
          index: 2,
          x: 120,
          y: 150,
          angle: 150,
          radius: 80,
          value: 80,
          name: 'C',
        ),
      ];
    });

    test('returns null for point far from all points', () {
      final result = findRadarPointAtPoint(const Offset(400, 400), points);
      expect(result, isNull);
    });

    test('finds nearest point within hit radius', () {
      final result = findRadarPointAtPoint(const Offset(205, 102), points);
      expect(result, equals(0));
    });

    test('respects custom hit radius', () {
      final result = findRadarPointAtPoint(
        const Offset(215, 100),
        points,
        hitRadius: 20,
      );
      expect(result, equals(0));
    });

    test('returns null if outside hit radius', () {
      final result = findRadarPointAtPoint(
        const Offset(220, 100),
        points,
        hitRadius: 10,
      );
      expect(result, isNull);
    });

    test('returns null for empty points list', () {
      final result = findRadarPointAtPoint(const Offset(200, 100), []);
      expect(result, isNull);
    });
  });

  group('isPointInPolygon', () {
    late List<RadarPoint> triangle;

    setUp(() {
      triangle = [
        const RadarPoint(
          index: 0,
          x: 200,
          y: 100,
          angle: 90,
          radius: 100,
          value: 100,
        ),
        const RadarPoint(
          index: 1,
          x: 280,
          y: 250,
          angle: 330,
          radius: 100,
          value: 100,
        ),
        const RadarPoint(
          index: 2,
          x: 120,
          y: 250,
          angle: 210,
          radius: 100,
          value: 100,
        ),
      ];
    });

    test('returns true for point inside polygon', () {
      final result = isPointInPolygon(const Offset(200, 180), triangle);
      expect(result, isTrue);
    });

    test('returns false for point outside polygon', () {
      final result = isPointInPolygon(const Offset(100, 100), triangle);
      expect(result, isFalse);
    });

    test('returns false for polygon with less than 3 points', () {
      final result = isPointInPolygon(
        const Offset(200, 200),
        triangle.sublist(0, 2),
      );
      expect(result, isFalse);
    });
  });
}
