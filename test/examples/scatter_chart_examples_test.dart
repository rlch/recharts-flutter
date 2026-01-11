import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recharts_flutter/recharts_flutter.dart';

final scatterData01 = [
  {'x': 100, 'y': 200, 'z': 200},
  {'x': 120, 'y': 100, 'z': 260},
  {'x': 170, 'y': 300, 'z': 400},
  {'x': 140, 'y': 250, 'z': 280},
  {'x': 150, 'y': 400, 'z': 500},
  {'x': 110, 'y': 280, 'z': 200},
];

void main() {
  group('ScatterSeries', () {
    test('ScatterSeries class exists with correct properties', () {
      const series = ScatterSeries(
        xDataKey: 'x',
        yDataKey: 'y',
        fill: Color(0xFF8884D8),
      );

      expect(series.xDataKey, equals('x'));
      expect(series.yDataKey, equals('y'));
      expect(series.fill, equals(const Color(0xFF8884D8)));
      expect(series.shape, equals(ScatterShape.circle));
      expect(series.size, equals(10));
    });

    test('ScatterSeries supports z-axis for bubble size', () {
      const series = ScatterSeries(
        xDataKey: 'x',
        yDataKey: 'y',
        zDataKey: 'z',
        fill: Color(0xFF8884D8),
      );

      expect(series.zDataKey, equals('z'));
    });

    test('ScatterSeries supports different shapes', () {
      for (final shape in ScatterShape.values) {
        final series = ScatterSeries(
          xDataKey: 'x',
          yDataKey: 'y',
          shape: shape,
        );

        expect(series.shape, equals(shape));
      }
    });

    test('ScatterSeries copyWith works correctly', () {
      const original = ScatterSeries(
        xDataKey: 'x',
        yDataKey: 'y',
        fill: Color(0xFF8884D8),
      );

      final copied = original.copyWith(
        fill: const Color(0xFF82CA9D),
        size: 20,
      );

      expect(copied.xDataKey, equals('x'));
      expect(copied.yDataKey, equals('y'));
      expect(copied.fill, equals(const Color(0xFF82CA9D)));
      expect(copied.size, equals(20));
    });

    test('ScatterSeries supports ZAxis configuration', () {
      const zAxis = ZAxis(
        dataKey: 'z',
        minSize: 4,
        maxSize: 60,
      );

      const series = ScatterSeries(
        xDataKey: 'x',
        yDataKey: 'y',
        zAxis: zAxis,
      );

      expect(series.zAxis?.dataKey, equals('z'));
      expect(series.zAxis?.minSize, equals(4));
      expect(series.zAxis?.maxSize, equals(60));
    });
  });

  group('ScatterSeriesPainter', () {
    test('ScatterSeriesPainter can be created', () {
      const series = ScatterSeries(
        xDataKey: 'x',
        yDataKey: 'y',
        fill: Color(0xFF8884D8),
      );

      final painter = ScatterSeriesPainter(
        series: series,
        points: const [
          ScatterPoint(index: 0, x: 100, y: 200, size: 10),
        ],
      );

      expect(painter.series, equals(series));
      expect(painter.points.length, equals(1));
    });
  });

  group('ScatterPoint', () {
    test('ScatterPoint offset is calculated correctly', () {
      const point = ScatterPoint(
        index: 0,
        x: 100,
        y: 200,
        size: 10,
      );

      expect(point.offset, equals(const Offset(100, 200)));
    });
  });
}
