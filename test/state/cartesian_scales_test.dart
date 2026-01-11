import 'package:flutter_test/flutter_test.dart';

import 'package:recharts_flutter/src/core/types/chart_data.dart';
import 'package:recharts_flutter/src/core/scale/linear_scale.dart';
import 'package:recharts_flutter/src/core/scale/band_scale.dart';
import 'package:recharts_flutter/src/cartesian/axis/x_axis.dart';
import 'package:recharts_flutter/src/cartesian/axis/y_axis.dart';
import 'package:recharts_flutter/src/state/models/chart_layout.dart';
import 'package:recharts_flutter/src/state/providers/cartesian_scales_provider.dart';

void main() {
  final testData = ChartDataSet([
    {'name': 'A', 'value': 100, 'value2': 50},
    {'name': 'B', 'value': 200, 'value2': 80},
    {'name': 'C', 'value': 150, 'value2': 120},
    {'name': 'D', 'value': 300, 'value2': 90},
  ]);

  final layout = ChartLayout.compute(
    width: 400,
    height: 300,
  );

  group('buildCartesianScales', () {
    test('creates category X scale for default XAxis', () {
      final scales = buildCartesianScales(
        data: testData,
        layout: layout,
        xAxes: [const XAxis(dataKey: 'name')],
        yAxes: [const YAxis()],
        yDataKeys: ['value'],
      );

      expect(scales.xScale, isA<BandScale>());
      expect(scales.xScale.domain, ['A', 'B', 'C', 'D']);
    });

    test('creates linear Y scale with nice domain', () {
      final scales = buildCartesianScales(
        data: testData,
        layout: layout,
        xAxes: [const XAxis(dataKey: 'name')],
        yAxes: [const YAxis()],
        yDataKeys: ['value'],
      );

      expect(scales.yScale, isA<LinearScale>());
      expect(scales.yScale.domain.first, 0);
      expect(scales.yScale.domain.last, greaterThanOrEqualTo(300));
    });

    test('Y scale domain includes all yDataKeys', () {
      final scales = buildCartesianScales(
        data: testData,
        layout: layout,
        xAxes: [const XAxis(dataKey: 'name')],
        yAxes: [const YAxis()],
        yDataKeys: ['value', 'value2'],
      );

      expect(scales.yScale.domain.last, greaterThanOrEqualTo(300));
    });

    test('X scale range matches plot area', () {
      final scales = buildCartesianScales(
        data: testData,
        layout: layout,
        xAxes: [const XAxis(dataKey: 'name')],
        yAxes: [const YAxis()],
        yDataKeys: ['value'],
      );

      expect(scales.xScale.range.first, layout.plotLeft);
      expect(scales.xScale.range.last, layout.plotRight);
    });

    test('Y scale range is inverted (bottom to top)', () {
      final scales = buildCartesianScales(
        data: testData,
        layout: layout,
        xAxes: [const XAxis(dataKey: 'name')],
        yAxes: [const YAxis()],
        yDataKeys: ['value'],
      );

      expect(scales.yScale.range.first, layout.plotBottom);
      expect(scales.yScale.range.last, layout.plotTop);
    });

    test('multiple axes are stored in maps', () {
      final scales = buildCartesianScales(
        data: testData,
        layout: layout,
        xAxes: [
          const XAxis(id: '0', dataKey: 'name'),
          const XAxis(id: '1', dataKey: 'name'),
        ],
        yAxes: [
          const YAxis(id: '0'),
          const YAxis(id: '1'),
        ],
        yDataKeys: ['value'],
      );

      expect(scales.xScales.containsKey('0'), true);
      expect(scales.xScales.containsKey('1'), true);
      expect(scales.yScales.containsKey('0'), true);
      expect(scales.yScales.containsKey('1'), true);
    });

    test('getXScale returns correct scale by id', () {
      final scales = buildCartesianScales(
        data: testData,
        layout: layout,
        xAxes: [const XAxis(id: 'main', dataKey: 'name')],
        yAxes: [const YAxis()],
        yDataKeys: ['value'],
      );

      final mainScale = scales.getXScale('main');
      expect(mainScale, isNotNull);
    });

    test('getYScale returns default scale for missing id', () {
      final scales = buildCartesianScales(
        data: testData,
        layout: layout,
        xAxes: [const XAxis(dataKey: 'name')],
        yAxes: [const YAxis()],
        yDataKeys: ['value'],
      );

      final scale = scales.getYScale('nonexistent');
      expect(scale, scales.yScale);
    });
  });
}
