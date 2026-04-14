import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:recharts_flutter/src/core/types/chart_data.dart';
import 'package:recharts_flutter/src/core/scale/band_scale.dart';
import 'package:recharts_flutter/src/core/scale/linear_scale.dart';
import 'package:recharts_flutter/src/state/models/chart_layout.dart';
import 'package:recharts_flutter/src/state/models/interaction_state.dart';
import 'package:recharts_flutter/src/state/controllers/chart_interaction_controller.dart';

void main() {
  group('ChartInteractionController', () {
    late ChartDataSet testData;
    late ChartLayout layout;
    late BandScale<String> xScale;
    late LinearScale yScale;
    late List<SeriesInfo> seriesInfoList;

    setUp(() {
      testData = ChartDataSet([
        {'name': 'A', 'value': 100, 'value2': 50},
        {'name': 'B', 'value': 200, 'value2': 150},
        {'name': 'C', 'value': 150, 'value2': 100},
        {'name': 'D', 'value': 300, 'value2': 200},
      ]);

      layout = ChartLayout.compute(
        width: 400,
        height: 300,
        margin: const ChartMargin(left: 60, right: 10, top: 10, bottom: 30),
      );

      xScale = BandScale<String>(
        domain: ['A', 'B', 'C', 'D'],
        range: [layout.plotLeft, layout.plotRight],
      );

      yScale = LinearScale(
        domain: [0, 300],
        range: [layout.plotBottom, layout.plotTop],
      );

      seriesInfoList = [
        const SeriesInfo(
          dataKey: 'value',
          name: 'Value 1',
          color: Color(0xFF8884d8),
        ),
        const SeriesInfo(
          dataKey: 'value2',
          name: 'Value 2',
          color: Color(0xFF82ca9d),
        ),
      ];
    });

    ChartInteractionController createController({
      ChartDataSet? data,
      void Function(ChartInteractionState)? onStateChanged,
    }) {
      return ChartInteractionController(
        data: data ?? testData,
        layout: layout,
        xScale: xScale,
        yScale: yScale,
        xDataKey: 'name',
        seriesInfoList: seriesInfoList,
        onStateChanged: onStateChanged ?? (_) {},
      );
    }

    group('findNearestIndex', () {
      test('finds correct index for band scale', () {
        final controller = createController();

        final bandwidth = xScale.bandwidth;
        final firstBandCenter = xScale('A') + bandwidth / 2;

        final index = controller.findNearestIndex(Offset(firstBandCenter, 150));
        expect(index, 0);
      });

      test('finds nearest index when pointer is between bands', () {
        final controller = createController();

        final bandwidth = xScale.bandwidth;
        final betweenAB = xScale('A') + bandwidth + 5;

        final index = controller.findNearestIndex(Offset(betweenAB, 150));
        expect(index, isNotNull);
        expect(index, lessThan(4));
      });

      test('returns null for empty data with empty scale', () {
        final emptyData = ChartDataSet([]);
        final emptyXScale = BandScale<String>(
          domain: [],
          range: [layout.plotLeft, layout.plotRight],
        );

        final controller = ChartInteractionController(
          data: emptyData,
          layout: layout,
          xScale: emptyXScale,
          yScale: yScale,
          xDataKey: 'name',
          seriesInfoList: seriesInfoList,
          onStateChanged: (_) {},
        );

        final index = controller.findNearestIndex(const Offset(100, 150));
        expect(index, isNull);
      });
    });

    group('findNearestIndex with linear scale', () {
      test('finds nearest index for numeric x values', () {
        final numericData = ChartDataSet([
          {'x': 0, 'y': 100},
          {'x': 50, 'y': 200},
          {'x': 100, 'y': 150},
        ]);

        final linearXScale = LinearScale(
          domain: [0, 100],
          range: [layout.plotLeft, layout.plotRight],
        );

        final controller = ChartInteractionController(
          data: numericData,
          layout: layout,
          xScale: linearXScale,
          yScale: yScale,
          xDataKey: 'x',
          seriesInfoList: [
            const SeriesInfo(dataKey: 'y', color: Color(0xFF8884d8)),
          ],
          onStateChanged: (_) {},
        );

        final x50 = linearXScale(50);
        final index = controller.findNearestIndex(Offset(x50, 150));
        expect(index, 1);
      });

      test('finds nearest when pointer is between points', () {
        final numericData = ChartDataSet([
          {'x': 0, 'y': 100},
          {'x': 100, 'y': 200},
        ]);

        final linearXScale = LinearScale(
          domain: [0, 100],
          range: [layout.plotLeft, layout.plotRight],
        );

        final controller = ChartInteractionController(
          data: numericData,
          layout: layout,
          xScale: linearXScale,
          yScale: yScale,
          xDataKey: 'x',
          seriesInfoList: [
            const SeriesInfo(dataKey: 'y', color: Color(0xFF8884d8)),
          ],
          onStateChanged: (_) {},
        );

        final x25 = linearXScale(25);
        final index = controller.findNearestIndex(Offset(x25, 150));
        expect(index, 0);

        final x75 = linearXScale(75);
        final index2 = controller.findNearestIndex(Offset(x75, 150));
        expect(index2, 1);
      });
    });

    group('buildTooltipPayload', () {
      test('creates payload with correct index and label', () {
        final controller = createController();

        final payload = controller.buildTooltipPayload(
          0,
          const Offset(100, 150),
        );

        expect(payload.index, 0);
        expect(payload.label, 'A');
        expect(payload.coordinate, const Offset(100, 150));
      });

      test('includes entries for all series', () {
        final controller = createController();

        final payload = controller.buildTooltipPayload(
          0,
          const Offset(100, 150),
        );

        expect(payload.entries.length, 2);
        expect(payload.entries[0].name, 'Value 1');
        expect(payload.entries[0].value, 100);
        expect(payload.entries[0].color, const Color(0xFF8884d8));
        expect(payload.entries[1].name, 'Value 2');
        expect(payload.entries[1].value, 50);
      });

      test('includes percent value when provided by series info', () {
        final controller = ChartInteractionController(
          data: testData,
          layout: layout,
          xScale: xScale,
          yScale: yScale,
          xDataKey: 'name',
          seriesInfoList: const [
            SeriesInfo(
              dataKey: 'value',
              name: 'Value 1',
              color: Color(0xFF8884d8),
              percentValueForIndex: _percentAtQuarter,
            ),
          ],
          onStateChanged: (_) {},
        );

        final payload = controller.buildTooltipPayload(
          0,
          const Offset(100, 150),
        );

        expect(payload.entries.single.percentValue, 0.25);
      });

      test('skips null values', () {
        final dataWithNull = ChartDataSet([
          {'name': 'A', 'value': 100, 'value2': null},
        ]);

        final controller = createController(data: dataWithNull);

        final payload = controller.buildTooltipPayload(
          0,
          const Offset(100, 150),
        );

        expect(payload.entries.length, 1);
        expect(payload.entries[0].name, 'Value 1');
      });
    });

    group('onPointerMove', () {
      test('updates state when pointer is in plot area', () {
        ChartInteractionState? capturedState;
        final controller = createController(
          onStateChanged: (state) => capturedState = state,
        );

        final inPlotArea = Offset(layout.plotLeft + 50, layout.plotTop + 50);

        controller.onPointerMove(inPlotArea);

        expect(capturedState, isNotNull);
        expect(capturedState!.isActive, true);
        expect(capturedState!.activeIndex, isNotNull);
        expect(capturedState!.tooltipPayload, isNotNull);
        expect(
          capturedState!.activeCoordinate,
          controller.getTooltipAnchorCoordinate(capturedState!.activeIndex!),
        );
      });

      test('calls onPointerExit when pointer leaves plot area', () {
        ChartInteractionState? capturedState;
        final controller = createController(
          onStateChanged: (state) => capturedState = state,
        );

        controller.onPointerMove(
          Offset(layout.plotLeft + 50, layout.plotTop + 50),
        );
        expect(capturedState!.isActive, true);

        controller.onPointerMove(const Offset(0, 0));
        expect(capturedState!.isActive, false);
      });
    });

    group('onPointerExit', () {
      test('resets state to inactive', () {
        ChartInteractionState? capturedState;
        final controller = createController(
          onStateChanged: (state) => capturedState = state,
        );

        controller.onPointerMove(
          Offset(layout.plotLeft + 50, layout.plotTop + 50),
        );
        expect(capturedState!.isActive, true);

        controller.onPointerExit();

        expect(capturedState!.isActive, false);
        expect(capturedState!.activeIndex, isNull);
        expect(capturedState!.tooltipPayload, isNull);
      });
    });

    group('getPointCoordinate', () {
      test('returns correct coordinate for valid index and dataKey', () {
        final controller = createController();

        final coord = controller.getPointCoordinate(0, 'value');

        expect(coord, isNotNull);
        final bandwidth = xScale.bandwidth;
        expect(coord!.dx, xScale('A') + bandwidth / 2);
        expect(coord.dy, yScale(100));
      });

      test('returns null for invalid index', () {
        final controller = createController();

        final coord = controller.getPointCoordinate(-1, 'value');
        expect(coord, isNull);

        final coord2 = controller.getPointCoordinate(10, 'value');
        expect(coord2, isNull);
      });

      test('returns null for null value', () {
        final dataWithNull = ChartDataSet([
          {'name': 'A', 'value': null},
        ]);

        final controller = createController(data: dataWithNull);

        final coord = controller.getPointCoordinate(0, 'value');
        expect(coord, isNull);
      });

      test('returns correct coordinate for vertical layout', () {
        final verticalYScale = BandScale<String>(
          domain: ['A', 'B', 'C', 'D'],
          range: [layout.plotTop, layout.plotBottom],
        );
        final verticalXScale = LinearScale(
          domain: [0, 300],
          range: [layout.plotLeft, layout.plotRight],
        );

        final controller = ChartInteractionController(
          data: testData,
          layout: layout,
          xScale: verticalXScale,
          yScale: verticalYScale,
          xDataKey: 'value',
          categoryDataKey: 'name',
          verticalLayout: true,
          seriesInfoList: seriesInfoList,
          onStateChanged: (_) {},
        );

        final coord = controller.getPointCoordinate(0, 'value');

        expect(coord, isNotNull);
        expect(coord!.dx, verticalXScale(100));
        expect(coord.dy, verticalYScale('A') + (verticalYScale.bandwidth / 2));
      });
    });

    group('getTooltipAnchorCoordinate', () {
      test('returns first non-null series coordinate', () {
        final controller = createController();

        final coord = controller.getTooltipAnchorCoordinate(0);

        expect(coord, controller.getPointCoordinate(0, 'value'));
      });

      test('returns null when no series has a value at index', () {
        final dataWithNulls = ChartDataSet([
          {'name': 'A', 'value': null, 'value2': null},
        ]);

        final controller = createController(data: dataWithNulls);

        final coord = controller.getTooltipAnchorCoordinate(0);
        expect(coord, isNull);
      });
    });

    group('vertical layout interaction', () {
      test('finds nearest index by Y position', () {
        final verticalYScale = BandScale<String>(
          domain: ['A', 'B', 'C', 'D'],
          range: [layout.plotTop, layout.plotBottom],
        );
        final verticalXScale = LinearScale(
          domain: [0, 300],
          range: [layout.plotLeft, layout.plotRight],
        );

        final controller = ChartInteractionController(
          data: testData,
          layout: layout,
          xScale: verticalXScale,
          yScale: verticalYScale,
          xDataKey: 'value',
          categoryDataKey: 'name',
          verticalLayout: true,
          seriesInfoList: seriesInfoList,
          onStateChanged: (_) {},
        );

        final y = verticalYScale('C') + verticalYScale.bandwidth / 2;
        final index = controller.findNearestIndex(
          Offset(layout.plotLeft + 10, y),
        );

        expect(index, 2);
      });

      test('uses category axis key for tooltip label', () {
        final verticalYScale = BandScale<String>(
          domain: ['A', 'B', 'C', 'D'],
          range: [layout.plotTop, layout.plotBottom],
        );
        final verticalXScale = LinearScale(
          domain: [0, 300],
          range: [layout.plotLeft, layout.plotRight],
        );

        final controller = ChartInteractionController(
          data: testData,
          layout: layout,
          xScale: verticalXScale,
          yScale: verticalYScale,
          xDataKey: 'value',
          categoryDataKey: 'name',
          verticalLayout: true,
          seriesInfoList: seriesInfoList,
          onStateChanged: (_) {},
        );

        final payload = controller.buildTooltipPayload(
          1,
          const Offset(100, 120),
        );
        expect(payload.label, 'B');
      });
    });
  });
}

double _percentAtQuarter(int _) => 0.25;
