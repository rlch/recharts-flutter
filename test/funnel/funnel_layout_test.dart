import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:recharts_flutter/src/funnel/funnel_series.dart';
import 'package:recharts_flutter/src/funnel/funnel_geometry.dart';

void main() {
  group('FunnelSeries', () {
    test('creates with required parameters', () {
      const series = FunnelSeries(dataKey: 'value');

      expect(series.dataKey, 'value');
      expect(series.shape, FunnelShape.trapezoid);
      expect(series.reversed, false);
      expect(series.gap, 4);
    });

    test('creates with rectangle shape', () {
      const series = FunnelSeries(
        dataKey: 'value',
        shape: FunnelShape.rectangle,
      );

      expect(series.shape, FunnelShape.rectangle);
    });

    test('copyWith updates values correctly', () {
      const original = FunnelSeries(dataKey: 'value');

      final updated = original.copyWith(
        reversed: true,
        gap: 8,
      );

      expect(updated.reversed, true);
      expect(updated.gap, 8);
      expect(updated.dataKey, 'value');
    });
  });

  group('TrapezoidGeometry', () {
    test('creates correct path for trapezoid', () {
      const geo = TrapezoidGeometry(
        index: 0,
        x: 0,
        y: 0,
        width: 100,
        height: 50,
        upperWidth: 80,
        lowerWidth: 60,
        color: Color(0xFF8884d8),
      );

      final path = geo.toPath();
      final bounds = path.getBounds();

      expect(bounds.width, greaterThan(0));
      expect(bounds.height, closeTo(50, 0.1));
    });

    test('center is calculated correctly', () {
      const geo = TrapezoidGeometry(
        index: 0,
        x: 10,
        y: 20,
        width: 100,
        height: 50,
        upperWidth: 80,
        lowerWidth: 60,
        color: Color(0xFF8884d8),
      );

      expect(geo.center.dx, closeTo(60, 0.1));
      expect(geo.center.dy, closeTo(45, 0.1));
    });
  });

  group('FunnelLayout', () {
    test('computes layout with padding', () {
      final layout = FunnelLayout.compute(
        chartWidth: 400,
        chartHeight: 300,
        padding: 20,
      );

      expect(layout.x, 20);
      expect(layout.y, 20);
      expect(layout.width, 360);
      expect(layout.height, 260);
    });
  });
}
