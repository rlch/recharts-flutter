import 'package:flutter_test/flutter_test.dart';

import 'package:recharts_flutter/src/core/types/chart_data.dart';
import 'package:recharts_flutter/src/core/scale/band_scale.dart';
import 'package:recharts_flutter/src/core/scale/linear_scale.dart';
import 'package:recharts_flutter/src/cartesian/series/bar_series.dart';
import 'package:recharts_flutter/src/state/providers/bar_rects_provider.dart';

void main() {
  group('computeBarRects', () {
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

    final yScale = LinearScale(
      domain: [0, 300],
      range: [300, 0],
    );

    const baseY = 300.0;

    test('computes correct number of rects', () {
      final rects = computeBarRects(
        data: testData,
        series: const BarSeries(dataKey: 'value'),
        xScale: xScale,
        yScale: yScale,
        xDataKey: 'name',
        baseY: baseY,
      );

      expect(rects.length, 4);
    });

    test('rects have correct heights', () {
      final rects = computeBarRects(
        data: testData,
        series: const BarSeries(dataKey: 'value'),
        xScale: xScale,
        yScale: yScale,
        xDataKey: 'name',
        baseY: baseY,
      );

      final expectedHeight0 = (baseY - yScale(100)).abs();
      final expectedHeight1 = (baseY - yScale(200)).abs();

      expect(rects[0].rect.height, expectedHeight0);
      expect(rects[1].rect.height, expectedHeight1);
    });

    test('rects top is at y value for positive values', () {
      final rects = computeBarRects(
        data: testData,
        series: const BarSeries(dataKey: 'value'),
        xScale: xScale,
        yScale: yScale,
        xDataKey: 'name',
        baseY: baseY,
      );

      expect(rects[0].rect.top, yScale(100));
      expect(rects[1].rect.top, yScale(200));
    });

    test('skips null values', () {
      final dataWithNull = ChartDataSet([
        {'name': 'A', 'value': 100},
        {'name': 'B', 'value': null},
        {'name': 'C', 'value': 150},
      ]);

      final rects = computeBarRects(
        data: dataWithNull,
        series: const BarSeries(dataKey: 'value'),
        xScale: xScale,
        yScale: yScale,
        xDataKey: 'name',
        baseY: baseY,
      );

      expect(rects.length, 2);
      expect(rects[0].index, 0);
      expect(rects[1].index, 2);
    });

    test('multiple bars are offset correctly', () {
      final rects1 = computeBarRects(
        data: testData,
        series: const BarSeries(dataKey: 'value'),
        xScale: xScale,
        yScale: yScale,
        xDataKey: 'name',
        baseY: baseY,
        barIndex: 0,
        totalBars: 2,
      );

      final rects2 = computeBarRects(
        data: testData,
        series: const BarSeries(dataKey: 'value'),
        xScale: xScale,
        yScale: yScale,
        xDataKey: 'name',
        baseY: baseY,
        barIndex: 1,
        totalBars: 2,
      );

      expect(rects1[0].rect.left, lessThan(rects2[0].rect.left));
    });

    test('custom barSize is used', () {
      final rects = computeBarRects(
        data: testData,
        series: const BarSeries(dataKey: 'value', barSize: 30),
        xScale: xScale,
        yScale: yScale,
        xDataKey: 'name',
        baseY: baseY,
      );

      expect(rects[0].rect.width, 30);
    });

    test('rects store dataKey', () {
      final rects = computeBarRects(
        data: testData,
        series: const BarSeries(dataKey: 'value'),
        xScale: xScale,
        yScale: yScale,
        xDataKey: 'name',
        baseY: baseY,
      );

      expect(rects[0].dataKey, 'value');
    });
  });
}
