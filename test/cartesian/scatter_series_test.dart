import 'package:flutter_test/flutter_test.dart';

import 'package:recharts_flutter/src/cartesian/series/scatter_series.dart';
import 'package:recharts_flutter/src/cartesian/painters/scatter_series_painter.dart';

void main() {
  group('ScatterSeries', () {
    test('creates with required parameters', () {
      const series = ScatterSeries(
        xDataKey: 'x',
        yDataKey: 'y',
      );

      expect(series.xDataKey, 'x');
      expect(series.yDataKey, 'y');
      expect(series.shape, ScatterShape.circle);
      expect(series.size, 10);
    });

    test('creates with zDataKey for size mapping', () {
      const series = ScatterSeries(
        xDataKey: 'x',
        yDataKey: 'y',
        zDataKey: 'z',
        zAxis: ZAxis(dataKey: 'z', minSize: 5, maxSize: 30),
      );

      expect(series.zDataKey, 'z');
      expect(series.zAxis, isNotNull);
      expect(series.zAxis!.minSize, 5);
      expect(series.zAxis!.maxSize, 30);
    });

    test('copyWith creates new instance with updated values', () {
      const original = ScatterSeries(
        xDataKey: 'x',
        yDataKey: 'y',
      );

      final updated = original.copyWith(
        shape: ScatterShape.star,
        size: 20,
      );

      expect(updated.shape, ScatterShape.star);
      expect(updated.size, 20);
      expect(updated.xDataKey, 'x');
    });
  });

  group('ScatterSeriesPainter', () {
    test('creates shape paths for all shapes', () {
      const center = Offset(50, 50);
      const size = 20.0;

      for (final shape in ScatterShape.values) {
        final path = ScatterSeriesPainter.createShapePath(center, size, shape);
        expect(path, isNotNull);
        expect(path.getBounds().width, greaterThan(0));
        expect(path.getBounds().height, greaterThan(0));
      }
    });

    test('circle shape is approximately circular', () {
      final path = ScatterSeriesPainter.createShapePath(
        const Offset(50, 50),
        20,
        ScatterShape.circle,
      );

      final bounds = path.getBounds();
      expect((bounds.width - bounds.height).abs(), lessThan(0.1));
    });

    test('square shape has equal width and height', () {
      final path = ScatterSeriesPainter.createShapePath(
        const Offset(50, 50),
        20,
        ScatterShape.square,
      );

      final bounds = path.getBounds();
      expect((bounds.width - bounds.height).abs(), lessThan(0.1));
    });

    test('diamond shape has correct proportions', () {
      final path = ScatterSeriesPainter.createShapePath(
        const Offset(50, 50),
        20,
        ScatterShape.diamond,
      );

      final bounds = path.getBounds();
      expect(bounds.width, closeTo(20, 0.1));
      expect(bounds.height, closeTo(20, 0.1));
    });

    test('star shape has 10 points', () {
      final path = ScatterSeriesPainter.createShapePath(
        const Offset(50, 50),
        20,
        ScatterShape.star,
      );

      expect(path, isNotNull);
      expect(path.getBounds().width, greaterThan(0));
    });
  });
}
