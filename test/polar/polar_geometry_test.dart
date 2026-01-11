import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:recharts_flutter/src/core/types/chart_data.dart';
import 'package:recharts_flutter/src/polar/polar_layout.dart';
import 'package:recharts_flutter/src/polar/series/pie_series.dart';
import 'package:recharts_flutter/src/polar/series/radial_bar_series.dart';
import 'package:recharts_flutter/src/polar/series/radar_series.dart';
import 'package:recharts_flutter/src/state/providers/polar_geometry_provider.dart';

void main() {
  group('computePieSectors', () {
    late ChartDataSet dataSet;
    late PolarLayout layout;

    setUp(() {
      dataSet = ChartDataSet([
        {'name': 'A', 'value': 100},
        {'name': 'B', 'value': 200},
        {'name': 'C', 'value': 100},
      ]);
      layout = PolarLayout.compute(width: 400, height: 400);
    });

    test('computes correct number of sectors', () {
      final sectors = computePieSectors(
        data: dataSet,
        series: const PieSeries(dataKey: 'value'),
        layout: layout,
      );
      expect(sectors.length, equals(3));
    });

    test('computes correct percentages', () {
      final sectors = computePieSectors(
        data: dataSet,
        series: const PieSeries(dataKey: 'value'),
        layout: layout,
      );
      expect(sectors[0].percent, closeTo(0.25, 0.0001));
      expect(sectors[1].percent, closeTo(0.5, 0.0001));
      expect(sectors[2].percent, closeTo(0.25, 0.0001));
    });

    test('computes correct angle spans', () {
      final sectors = computePieSectors(
        data: dataSet,
        series: const PieSeries(dataKey: 'value', startAngle: 0, endAngle: 360),
        layout: layout,
      );
      final totalAngle = sectors
          .map((s) => (s.endAngle - s.startAngle).abs())
          .fold<double>(0, (a, b) => a + b);
      expect(totalAngle, closeTo(360, 0.1));
    });

    test('applies paddingAngle correctly', () {
      final sectors = computePieSectors(
        data: dataSet,
        series: const PieSeries(dataKey: 'value', paddingAngle: 2),
        layout: layout,
      );
      
      for (int i = 1; i < sectors.length; i++) {
        final gap = sectors[i].startAngle - sectors[i - 1].endAngle;
        expect(gap, closeTo(2, 0.1));
      }
    });

    test('sets center coordinates correctly', () {
      final sectors = computePieSectors(
        data: dataSet,
        series: const PieSeries(dataKey: 'value'),
        layout: layout,
      );
      for (final sector in sectors) {
        expect(sector.cx, equals(layout.cx));
        expect(sector.cy, equals(layout.cy));
      }
    });

    test('assigns colors from palette', () {
      final sectors = computePieSectors(
        data: dataSet,
        series: const PieSeries(dataKey: 'value'),
        layout: layout,
      );
      expect(sectors[0].color, equals(defaultPieColors[0]));
      expect(sectors[1].color, equals(defaultPieColors[1]));
      expect(sectors[2].color, equals(defaultPieColors[2]));
    });

    test('uses custom colors when provided', () {
      final customColors = [
        const Color(0xFFFF0000),
        const Color(0xFF00FF00),
        const Color(0xFF0000FF),
      ];
      final sectors = computePieSectors(
        data: dataSet,
        series: PieSeries(dataKey: 'value', colors: customColors),
        layout: layout,
      );
      expect(sectors[0].color, equals(customColors[0]));
      expect(sectors[1].color, equals(customColors[1]));
      expect(sectors[2].color, equals(customColors[2]));
    });

    test('handles inner radius for donut chart', () {
      final sectors = computePieSectors(
        data: dataSet,
        series: const PieSeries(dataKey: 'value', innerRadius: 0.5),
        layout: layout,
      );
      for (final sector in sectors) {
        expect(sector.innerRadius, greaterThan(0));
        expect(sector.innerRadius, lessThan(sector.outerRadius));
      }
    });

    test('returns empty list for all-zero data', () {
      final zeroData = ChartDataSet([
        {'name': 'A', 'value': 0},
        {'name': 'B', 'value': 0},
      ]);
      final sectors = computePieSectors(
        data: zeroData,
        series: const PieSeries(dataKey: 'value'),
        layout: layout,
      );
      expect(sectors, isEmpty);
    });

    test('extracts names from nameKey', () {
      final sectors = computePieSectors(
        data: dataSet,
        series: const PieSeries(dataKey: 'value', nameKey: 'name'),
        layout: layout,
      );
      expect(sectors[0].name, equals('A'));
      expect(sectors[1].name, equals('B'));
      expect(sectors[2].name, equals('C'));
    });
  });

  group('computeRadialBars', () {
    late ChartDataSet dataSet;
    late PolarLayout layout;

    setUp(() {
      dataSet = ChartDataSet([
        {'name': 'A', 'value': 80},
        {'name': 'B', 'value': 65},
        {'name': 'C', 'value': 40},
      ]);
      layout = PolarLayout.compute(width: 400, height: 400);
    });

    test('computes correct number of bars', () {
      final bars = computeRadialBars(
        data: dataSet,
        series: const RadialBarSeries(dataKey: 'value'),
        layout: layout,
      );
      expect(bars.length, equals(3));
    });

    test('stacks bars with different radii', () {
      final bars = computeRadialBars(
        data: dataSet,
        series: const RadialBarSeries(dataKey: 'value'),
        layout: layout,
      );
      expect(bars[0].innerRadius, lessThan(bars[1].innerRadius));
      expect(bars[1].innerRadius, lessThan(bars[2].innerRadius));
    });

    test('angle span proportional to value', () {
      final bars = computeRadialBars(
        data: dataSet,
        series: const RadialBarSeries(dataKey: 'value'),
        layout: layout,
      );
      final angle0 = (bars[0].endAngle - bars[0].startAngle).abs();
      final angle1 = (bars[1].endAngle - bars[1].startAngle).abs();
      expect(angle0, greaterThan(angle1));
    });

    test('assigns colors correctly', () {
      final bars = computeRadialBars(
        data: dataSet,
        series: const RadialBarSeries(dataKey: 'value'),
        layout: layout,
      );
      expect(bars[0].color, equals(defaultRadialBarColors[0]));
      expect(bars[1].color, equals(defaultRadialBarColors[1]));
      expect(bars[2].color, equals(defaultRadialBarColors[2]));
    });

    test('returns empty list for all-zero data', () {
      final zeroData = ChartDataSet([
        {'name': 'A', 'value': 0},
        {'name': 'B', 'value': 0},
      ]);
      final bars = computeRadialBars(
        data: zeroData,
        series: const RadialBarSeries(dataKey: 'value'),
        layout: layout,
      );
      expect(bars, isEmpty);
    });
  });

  group('computeRadarPoints', () {
    late ChartDataSet dataSet;
    late PolarLayout layout;

    setUp(() {
      dataSet = ChartDataSet([
        {'subject': 'Math', 'A': 120},
        {'subject': 'Chinese', 'A': 98},
        {'subject': 'English', 'A': 86},
        {'subject': 'Geography', 'A': 99},
        {'subject': 'Physics', 'A': 85},
        {'subject': 'History', 'A': 65},
      ]);
      layout = PolarLayout.compute(width: 400, height: 400);
    });

    test('computes correct number of points', () {
      final points = computeRadarPoints(
        data: dataSet,
        series: const RadarSeries(dataKey: 'A'),
        layout: layout,
        angleDataKey: 'subject',
      );
      expect(points.length, equals(6));
    });

    test('points are evenly distributed by angle', () {
      final points = computeRadarPoints(
        data: dataSet,
        series: const RadarSeries(dataKey: 'A'),
        layout: layout,
        angleDataKey: 'subject',
      );
      
      final angles = points.map((p) => p.angle).toList();
      for (int i = 1; i < angles.length; i++) {
        final diff = angles[i - 1] - angles[i];
        expect(diff, closeTo(60, 0.1));
      }
    });

    test('radius is proportional to value', () {
      final points = computeRadarPoints(
        data: dataSet,
        series: const RadarSeries(dataKey: 'A'),
        layout: layout,
        angleDataKey: 'subject',
        maxValue: 120,
      );
      
      expect(points[0].radius, closeTo(layout.outerRadius, 0.1));
      expect(points[5].radius, closeTo(layout.outerRadius * 65 / 120, 1));
    });

    test('points have correct cartesian coordinates', () {
      final points = computeRadarPoints(
        data: dataSet,
        series: const RadarSeries(dataKey: 'A'),
        layout: layout,
        angleDataKey: 'subject',
        maxValue: 100,
      );
      
      expect(points[0].x, closeTo(layout.cx, 1));
      expect(points[0].y, lessThan(layout.cy));
    });

    test('extracts names from angle data key', () {
      final points = computeRadarPoints(
        data: dataSet,
        series: const RadarSeries(dataKey: 'A'),
        layout: layout,
        angleDataKey: 'subject',
      );
      expect(points[0].name, equals('Math'));
      expect(points[1].name, equals('Chinese'));
    });

    test('returns empty list for empty data', () {
      final emptyData = ChartDataSet([]);
      final points = computeRadarPoints(
        data: emptyData,
        series: const RadarSeries(dataKey: 'A'),
        layout: layout,
        angleDataKey: 'subject',
      );
      expect(points, isEmpty);
    });
  });

  group('PolarLayout', () {
    test('computes center correctly', () {
      final layout = PolarLayout.compute(width: 400, height: 300);
      expect(layout.cx, equals(200));
      expect(layout.cy, equals(150));
    });

    test('computes max radius from min dimension', () {
      final layout = PolarLayout.compute(width: 400, height: 300, padding: 20);
      expect(layout.maxRadius, equals(130));
    });

    test('applies outer radius percent', () {
      final layout = PolarLayout.compute(
        width: 400,
        height: 400,
        padding: 0,
        outerRadiusPercent: 0.5,
      );
      expect(layout.outerRadius, equals(100));
    });

    test('applies inner radius percent', () {
      final layout = PolarLayout.compute(
        width: 400,
        height: 400,
        padding: 0,
        outerRadiusPercent: 1.0,
        innerRadiusPercent: 0.5,
      );
      expect(layout.innerRadius, equals(100));
    });
  });
}
