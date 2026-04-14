import 'package:flutter_test/flutter_test.dart';

import 'package:recharts_flutter/src/core/types/chart_data.dart';
import 'package:recharts_flutter/src/core/scale/band_scale.dart';
import 'package:recharts_flutter/src/core/scale/linear_scale.dart';
import 'package:recharts_flutter/src/cartesian/series/line_series.dart';
import 'package:recharts_flutter/src/state/providers/line_points_provider.dart';

void main() {
  group('computeLinePoints', () {
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

    test('computes correct number of points', () {
      final points = computeLinePoints(
        data: testData,
        series: const LineSeries(dataKey: 'value'),
        xScale: xScale,
        yScale: yScale,
        xDataKey: 'name',
      );

      expect(points.length, 4);
    });

    test('points have correct x positions', () {
      final points = computeLinePoints(
        data: testData,
        series: const LineSeries(dataKey: 'value'),
        xScale: xScale,
        yScale: yScale,
        xDataKey: 'name',
      );

      final bandwidth = xScale.bandwidth;
      expect(points[0].x, xScale('A') + bandwidth / 2);
      expect(points[1].x, xScale('B') + bandwidth / 2);
      expect(points[2].x, xScale('C') + bandwidth / 2);
      expect(points[3].x, xScale('D') + bandwidth / 2);
    });

    test('points have correct y positions', () {
      final points = computeLinePoints(
        data: testData,
        series: const LineSeries(dataKey: 'value'),
        xScale: xScale,
        yScale: yScale,
        xDataKey: 'name',
      );

      expect(points[0].y, yScale(100));
      expect(points[1].y, yScale(200));
      expect(points[2].y, yScale(150));
      expect(points[3].y, yScale(300));
    });

    test('marks null values as isNull', () {
      final dataWithNull = ChartDataSet([
        {'name': 'A', 'value': 100},
        {'name': 'B', 'value': null},
        {'name': 'C', 'value': 150},
      ]);

      final points = computeLinePoints(
        data: dataWithNull,
        series: const LineSeries(dataKey: 'value'),
        xScale: xScale,
        yScale: yScale,
        xDataKey: 'name',
      );

      expect(points[0].isNull, false);
      expect(points[1].isNull, true);
      expect(points[2].isNull, false);
    });

    test('uses index when xDataKey is null', () {
      final xScaleNumeric = BandScale<int>(
        domain: [0, 1, 2, 3],
        range: [0, 400],
      );

      final points = computeLinePoints(
        data: testData,
        series: const LineSeries(dataKey: 'value'),
        xScale: xScaleNumeric,
        yScale: yScale,
        xDataKey: null,
      );

      expect(points.length, 4);
      expect(points[0].index, 0);
      expect(points[1].index, 1);
    });

    test('points store original value', () {
      final points = computeLinePoints(
        data: testData,
        series: const LineSeries(dataKey: 'value'),
        xScale: xScale,
        yScale: yScale,
        xDataKey: 'name',
      );

      expect(points[0].value, 100);
      expect(points[1].value, 200);
      expect(points[2].value, 150);
      expect(points[3].value, 300);
    });

    test('computes vertical layout points with category Y and numeric X', () {
      final verticalYScale = BandScale<String>(
        domain: ['A', 'B', 'C', 'D'],
        range: [0, 400],
      );
      final verticalXScale = LinearScale(domain: [0, 300], range: [0, 600]);

      final points = computeLinePoints(
        data: testData,
        series: const LineSeries(dataKey: 'value'),
        xScale: verticalXScale,
        yScale: verticalYScale,
        yDataKey: 'name',
        verticalLayout: true,
      );

      final yBandwidth = verticalYScale.bandwidth;
      expect(points[0].x, verticalXScale(100));
      expect(points[0].y, verticalYScale('A') + yBandwidth / 2);
      expect(points[3].x, verticalXScale(300));
      expect(points[3].y, verticalYScale('D') + yBandwidth / 2);
    });
  });
}
