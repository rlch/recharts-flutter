import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:recharts_flutter/src/state/models/chart_layout.dart';
import 'package:recharts_flutter/src/state/providers/chart_layout_provider.dart';

void main() {
  group('ChartLayout', () {
    test('compute creates correct layout with default margins', () {
      final layout = ChartLayout.compute(
        width: 400,
        height: 300,
      );

      expect(layout.width, 400);
      expect(layout.height, 300);
      expect(layout.margin.top, 5);
      expect(layout.margin.right, 5);
      expect(layout.margin.bottom, 30);
      expect(layout.margin.left, 60);
      expect(layout.plotLeft, 60);
      expect(layout.plotTop, 5);
      expect(layout.plotRight, 395);
      expect(layout.plotBottom, 270);
      expect(layout.plotWidth, 335);
      expect(layout.plotHeight, 265);
    });

    test('compute creates correct layout with custom margins', () {
      final layout = ChartLayout.compute(
        width: 500,
        height: 400,
        margin: const ChartMargin(
          top: 10,
          right: 20,
          bottom: 40,
          left: 50,
        ),
      );

      expect(layout.plotLeft, 50);
      expect(layout.plotTop, 10);
      expect(layout.plotRight, 480);
      expect(layout.plotBottom, 360);
      expect(layout.plotWidth, 430);
      expect(layout.plotHeight, 350);
    });

    test('plotArea rect is computed correctly', () {
      final layout = ChartLayout.compute(
        width: 400,
        height: 300,
        margin: const ChartMargin.all(20),
      );

      expect(layout.plotArea, const Rect.fromLTWH(20, 20, 360, 260));
    });
  });

  group('ChartMargin', () {
    test('default values are correct', () {
      const margin = ChartMargin();
      expect(margin.top, 5);
      expect(margin.right, 5);
      expect(margin.bottom, 30);
      expect(margin.left, 60);
    });

    test('all constructor sets equal values', () {
      const margin = ChartMargin.all(10);
      expect(margin.top, 10);
      expect(margin.right, 10);
      expect(margin.bottom, 10);
      expect(margin.left, 10);
    });

    test('symmetric constructor sets correct values', () {
      const margin = ChartMargin.symmetric(horizontal: 20, vertical: 10);
      expect(margin.top, 10);
      expect(margin.right, 20);
      expect(margin.bottom, 10);
      expect(margin.left, 20);
    });

    test('copyWith preserves unchanged values', () {
      const original = ChartMargin(top: 5, right: 10, bottom: 15, left: 20);
      final copied = original.copyWith(top: 25);

      expect(copied.top, 25);
      expect(copied.right, 10);
      expect(copied.bottom, 15);
      expect(copied.left, 20);
    });
  });

  group('computeChartLayout', () {
    test('computes layout from Size', () {
      final layout = computeChartLayout(
        size: const Size(600, 400),
      );

      expect(layout.width, 600);
      expect(layout.height, 400);
      expect(layout.plotWidth, 535);
      expect(layout.plotHeight, 365);
    });

    test('accepts custom margin', () {
      final layout = computeChartLayout(
        size: const Size(600, 400),
        margin: const ChartMargin.all(50),
      );

      expect(layout.plotWidth, 500);
      expect(layout.plotHeight, 300);
    });
  });
}
