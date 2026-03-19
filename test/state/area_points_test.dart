import 'package:flutter_test/flutter_test.dart';

import 'package:recharts_flutter/src/core/types/chart_data.dart';
import 'package:recharts_flutter/src/core/scale/band_scale.dart';
import 'package:recharts_flutter/src/core/scale/linear_scale.dart';
import 'package:recharts_flutter/src/cartesian/series/area_series.dart';
import 'package:recharts_flutter/src/state/providers/area_points_provider.dart';

void main() {
  group('computeAreaPoints', () {
    final testData = ChartDataSet([
      {'name': 'A', 'value': 100},
      {'name': 'B', 'value': 200},
      {'name': 'C', 'value': 150},
      {'name': 'D', 'value': 300},
    ]);

    final xScale = BandScale<String>(
      domain: ['A', 'B', 'C', 'D'],
      range: [0, 400],
    );

    final yScale = LinearScale(domain: [0, 300], range: [300, 0]);

    const baseY = 300.0;

    test('computes correct number of points', () {
      final points = computeAreaPoints(
        data: testData,
        series: const AreaSeries(dataKey: 'value'),
        xScale: xScale,
        yScale: yScale,
        xDataKey: 'name',
        baseY: baseY,
      );

      expect(points.length, 4);
    });

    test('points have correct baseY', () {
      final points = computeAreaPoints(
        data: testData,
        series: const AreaSeries(dataKey: 'value'),
        xScale: xScale,
        yScale: yScale,
        xDataKey: 'name',
        baseY: baseY,
      );

      for (final point in points) {
        expect(point.baseY, baseY);
      }
    });

    test('points have correct y values', () {
      final points = computeAreaPoints(
        data: testData,
        series: const AreaSeries(dataKey: 'value'),
        xScale: xScale,
        yScale: yScale,
        xDataKey: 'name',
        baseY: baseY,
      );

      expect(points[0].y, yScale(100));
      expect(points[1].y, yScale(200));
      expect(points[2].y, yScale(150));
      expect(points[3].y, yScale(300));
    });

    test('topOffset and bottomOffset are correct', () {
      final points = computeAreaPoints(
        data: testData,
        series: const AreaSeries(dataKey: 'value'),
        xScale: xScale,
        yScale: yScale,
        xDataKey: 'name',
        baseY: baseY,
      );

      final point = points[0];
      expect(point.topOffset.dx, point.x);
      expect(point.topOffset.dy, point.y);
      expect(point.bottomOffset.dx, point.x);
      expect(point.bottomOffset.dy, baseY);
    });

    test('handles null values', () {
      final dataWithNull = ChartDataSet([
        {'name': 'A', 'value': 100},
        {'name': 'B', 'value': null},
        {'name': 'C', 'value': 150},
      ]);

      final points = computeAreaPoints(
        data: dataWithNull,
        series: const AreaSeries(dataKey: 'value'),
        xScale: xScale,
        yScale: yScale,
        xDataKey: 'name',
        baseY: baseY,
      );

      expect(points[1].isNull, true);
    });

    test('supports vertical layout area points', () {
      final verticalYScale = BandScale<String>(
        domain: ['A', 'B', 'C', 'D'],
        range: [0, 400],
      );
      final verticalXScale = LinearScale(domain: [0, 300], range: [0, 600]);

      final points = computeAreaPoints(
        data: testData,
        series: const AreaSeries(dataKey: 'value'),
        xScale: verticalXScale,
        yScale: verticalYScale,
        yDataKey: 'name',
        baseX: verticalXScale(0),
        verticalLayout: true,
      );

      final yBandwidth = verticalYScale.bandwidth;
      expect(points[0].x, verticalXScale(100));
      expect(points[0].y, verticalYScale('A') + yBandwidth / 2);
      expect(points[0].bottomOffset.dx, verticalXScale(0));
      expect(points[0].bottomOffset.dy, points[0].y);
    });
  });
}
