import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recharts_flutter/recharts_flutter.dart';

import 'package:recharts_flutter/src/components/tooltip/tooltip_overlay.dart';

void main() {
  setUp(() {
    ChartSyncBus.instance.reset();
  });

  group('Chart Synchronization', () {
    testWidgets('synced charts share hover state', (tester) async {
      final data1 = [
        {'name': 'A', 'value': 100},
        {'name': 'B', 'value': 200},
        {'name': 'C', 'value': 150},
      ];

      final data2 = [
        {'name': 'A', 'users': 1000},
        {'name': 'B', 'users': 1500},
        {'name': 'C', 'users': 1200},
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: CartesianChartWidget(
                    syncId: 'testSync',
                    data: data1,
                    xAxes: const [XAxis(dataKey: 'name')],
                    yAxes: const [YAxis()],
                    lineSeries: const [LineSeries(dataKey: 'value')],
                    tooltip: const ChartTooltip(),
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: CartesianChartWidget(
                    syncId: 'testSync',
                    data: data2,
                    xAxes: const [XAxis(dataKey: 'name')],
                    yAxes: const [YAxis()],
                    lineSeries: const [LineSeries(dataKey: 'users')],
                    tooltip: const ChartTooltip(),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsNWidgets(2));
    });

    testWidgets('synced target tooltip snaps to corresponding point center', (
      tester,
    ) async {
      final data1 = [
        {'name': 'A', 'value': 100},
        {'name': 'B', 'value': 200},
        {'name': 'C', 'value': 150},
      ];

      final data2 = [
        {'name': 'A', 'users': 1000},
        {'name': 'B', 'users': 1500},
        {'name': 'C', 'users': 1200},
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: CartesianChartWidget(
                    syncId: 'testSync',
                    data: data1,
                    xAxes: const [XAxis(dataKey: 'name')],
                    yAxes: const [YAxis()],
                    lineSeries: const [LineSeries(dataKey: 'value')],
                    tooltip: const ChartTooltip(),
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: CartesianChartWidget(
                    syncId: 'testSync',
                    data: data2,
                    xAxes: const [XAxis(dataKey: 'name')],
                    yAxes: const [YAxis()],
                    lineSeries: const [LineSeries(dataKey: 'users')],
                    tooltip: const ChartTooltip(),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final firstChart = find.byType(CartesianChartWidget).first;
      final firstChartBox = tester.getRect(firstChart);

      final secondChart = find.byType(CartesianChartWidget).last;
      final secondChartBox = tester.getRect(secondChart);
      final secondOverlayFinder = find
          .descendant(of: secondChart, matching: find.byType(TooltipOverlay))
          .first;

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(
        Offset(firstChartBox.left + 100, firstChartBox.top + 140),
      );
      await tester.pumpAndSettle();

      final secondOverlayRect = tester.getRect(secondOverlayFinder);

      final secondPlotWidth = secondChartBox.width - 60 - 5;
      final firstBandCenterX =
          secondChartBox.left + 60 + (secondPlotWidth / 3) / 2;
      expect(
        secondOverlayRect.left,
        moreOrLessEquals(firstBandCenterX + 10, epsilon: 0.5),
      );
    });

    testWidgets('synced target chart hides tooltip when no point exists', (
      tester,
    ) async {
      final sourceData = [
        {'name': 'A', 'value': 100},
        {'name': 'B', 'value': 200},
      ];

      final targetData = [
        {'name': 'A', 'users': null},
        {'name': 'B', 'users': null},
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: CartesianChartWidget(
                    syncId: 'testSync',
                    data: sourceData,
                    xAxes: const [XAxis(dataKey: 'name')],
                    yAxes: const [YAxis()],
                    lineSeries: const [LineSeries(dataKey: 'value')],
                    tooltip: const ChartTooltip(),
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: CartesianChartWidget(
                    syncId: 'testSync',
                    data: targetData,
                    xAxes: const [XAxis(dataKey: 'name')],
                    yAxes: const [YAxis()],
                    lineSeries: const [LineSeries(dataKey: 'users')],
                    tooltip: const ChartTooltip(),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final firstChart = find.byType(CartesianChartWidget).first;
      final firstChartBox = tester.getRect(firstChart);

      final secondChart = find.byType(CartesianChartWidget).last;

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(
        Offset(firstChartBox.left + 100, firstChartBox.top + 140),
      );
      await tester.pumpAndSettle();

      expect(
        find.descendant(of: secondChart, matching: find.byType(TooltipOverlay)),
        findsNothing,
      );
    });

    testWidgets('charts without syncId work independently', (tester) async {
      final data = [
        {'name': 'A', 'value': 100},
        {'name': 'B', 'value': 200},
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: CartesianChartWidget(
                    data: data,
                    xAxes: const [XAxis(dataKey: 'name')],
                    lineSeries: const [LineSeries(dataKey: 'value')],
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: CartesianChartWidget(
                    data: data,
                    xAxes: const [XAxis(dataKey: 'name')],
                    lineSeries: const [LineSeries(dataKey: 'value')],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsNWidgets(2));
    });

    testWidgets('polar charts support syncId', (tester) async {
      final data = [
        {'name': 'A', 'value': 100},
        {'name': 'B', 'value': 200},
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 300,
              width: 300,
              child: PolarChartWidget(
                syncId: 'polarSync',
                data: data,
                pieSeries: const [PieSeries(dataKey: 'value')],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(PolarChartWidget), findsOneWidget);
    });

    test('sync bus notifies all listeners in group', () {
      final received1 = <SyncHoverPayload?>[];
      final received2 = <SyncHoverPayload?>[];

      ChartSyncBus.instance.register('group', (p) => received1.add(p));
      ChartSyncBus.instance.register('group', (p) => received2.add(p));

      ChartSyncBus.instance.notifyHover(
        const SyncHoverPayload(syncId: 'group', index: 2),
      );

      expect(received1.length, 1);
      expect(received2.length, 1);
      expect(received1.first?.index, 2);
      expect(received2.first?.index, 2);
    });

    test('different sync groups are isolated', () {
      final groupA = <SyncHoverPayload?>[];
      final groupB = <SyncHoverPayload?>[];

      ChartSyncBus.instance.register('groupA', (p) => groupA.add(p));
      ChartSyncBus.instance.register('groupB', (p) => groupB.add(p));

      ChartSyncBus.instance.notifyHover(
        const SyncHoverPayload(syncId: 'groupA', index: 5),
      );

      expect(groupA.length, 1);
      expect(groupB.length, 0);
    });
  });
}
