import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:recharts_flutter/src/cartesian/cartesian_chart_widget.dart';
import 'package:recharts_flutter/src/cartesian/axis/x_axis.dart';
import 'package:recharts_flutter/src/cartesian/axis/y_axis.dart';
import 'package:recharts_flutter/src/cartesian/series/line_series.dart';
import 'package:recharts_flutter/src/components/tooltip/tooltip.dart';

void main() {
  final testData = [
    {'name': 'Jan', 'value': 400},
    {'name': 'Feb', 'value': 300},
    {'name': 'Mar', 'value': 200},
    {'name': 'Apr', 'value': 278},
    {'name': 'May', 'value': 189},
    {'name': 'Jun', 'value': 239},
  ];

  Widget wrapWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(body: child),
    );
  }

  group('CartesianChartWidget Tooltip Integration', () {
    testWidgets('renders with tooltip enabled', (tester) async {
      await tester.pumpWidget(wrapWidget(
        CartesianChartWidget(
          width: 400,
          height: 300,
          data: testData,
          xAxes: [const XAxis(dataKey: 'name')],
          yAxes: [const YAxis()],
          lineSeries: [const LineSeries(dataKey: 'value')],
          tooltip: const ChartTooltip(),
        ),
      ));

      expect(find.byType(CartesianChartWidget), findsOneWidget);
      expect(find.byType(MouseRegion), findsWidgets);
    });

    testWidgets('wraps with GestureDetector when trigger is click',
        (tester) async {
      await tester.pumpWidget(wrapWidget(
        CartesianChartWidget(
          width: 400,
          height: 300,
          data: testData,
          xAxes: [const XAxis(dataKey: 'name')],
          yAxes: [const YAxis()],
          lineSeries: [const LineSeries(dataKey: 'value')],
          tooltip: const ChartTooltip(trigger: TooltipTrigger.click),
        ),
      ));

      expect(find.byType(GestureDetector), findsOneWidget);
    });

    testWidgets('no interaction wrapper when trigger is none', (tester) async {
      await tester.pumpWidget(wrapWidget(
        CartesianChartWidget(
          width: 400,
          height: 300,
          data: testData,
          xAxes: [const XAxis(dataKey: 'name')],
          yAxes: [const YAxis()],
          lineSeries: [const LineSeries(dataKey: 'value')],
          tooltip: const ChartTooltip(trigger: TooltipTrigger.none),
        ),
      ));

      final mouseRegionFinder = find.byWidgetPredicate(
        (widget) => widget is MouseRegion && widget.onHover != null,
      );
      expect(mouseRegionFinder, findsNothing);
    });

    testWidgets('shows tooltip on hover', (tester) async {
      await tester.pumpWidget(wrapWidget(
        CartesianChartWidget(
          width: 400,
          height: 300,
          data: testData,
          xAxes: [const XAxis(dataKey: 'name')],
          yAxes: [const YAxis()],
          lineSeries: [const LineSeries(dataKey: 'value')],
          tooltip: const ChartTooltip(),
        ),
      ));

      final chartFinder = find.byType(CartesianChartWidget);
      final chartBox = tester.getRect(chartFinder);

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(Offset(
        chartBox.left + 100,
        chartBox.top + 100,
      ));
      await tester.pumpAndSettle();

      expect(find.byType(TooltipOverlay), findsOneWidget);
    });

    testWidgets('hides tooltip on pointer exit', (tester) async {
      await tester.pumpWidget(wrapWidget(
        CartesianChartWidget(
          width: 400,
          height: 300,
          data: testData,
          xAxes: [const XAxis(dataKey: 'name')],
          yAxes: [const YAxis()],
          lineSeries: [const LineSeries(dataKey: 'value')],
          tooltip: const ChartTooltip(),
        ),
      ));

      final chartFinder = find.byType(CartesianChartWidget);
      final chartBox = tester.getRect(chartFinder);

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(Offset(
        chartBox.left + 100,
        chartBox.top + 100,
      ));
      await tester.pumpAndSettle();

      await gesture.moveTo(Offset(
        chartBox.left - 50,
        chartBox.top - 50,
      ));
      await tester.pumpAndSettle();

      expect(find.byType(DefaultTooltipContent), findsNothing);
    });

    testWidgets('tooltip shows series values', (tester) async {
      await tester.pumpWidget(wrapWidget(
        CartesianChartWidget(
          width: 400,
          height: 300,
          data: testData,
          xAxes: [const XAxis(dataKey: 'name')],
          yAxes: [const YAxis()],
          lineSeries: [
            const LineSeries(dataKey: 'value', name: 'Sales'),
          ],
          tooltip: const ChartTooltip(),
        ),
      ));

      final chartFinder = find.byType(CartesianChartWidget);
      final chartBox = tester.getRect(chartFinder);

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(Offset(
        chartBox.left + 100,
        chartBox.top + 100,
      ));
      await tester.pumpAndSettle();

      expect(find.text('Sales'), findsOneWidget);
    });

    testWidgets('renders without tooltip when disabled', (tester) async {
      await tester.pumpWidget(wrapWidget(
        CartesianChartWidget(
          width: 400,
          height: 300,
          data: testData,
          xAxes: [const XAxis(dataKey: 'name')],
          yAxes: [const YAxis()],
          lineSeries: [const LineSeries(dataKey: 'value')],
          tooltip: const ChartTooltip(enabled: false),
        ),
      ));

      final mouseRegionFinder = find.byWidgetPredicate(
        (widget) => widget is MouseRegion && widget.onHover != null,
      );
      expect(mouseRegionFinder, findsNothing);
    });

    testWidgets('updates tooltip on pointer move', (tester) async {
      await tester.pumpWidget(wrapWidget(
        CartesianChartWidget(
          width: 600,
          height: 300,
          data: testData,
          xAxes: [const XAxis(dataKey: 'name')],
          yAxes: [const YAxis()],
          lineSeries: [const LineSeries(dataKey: 'value')],
          tooltip: const ChartTooltip(),
        ),
      ));

      final chartFinder = find.byType(CartesianChartWidget);
      final chartBox = tester.getRect(chartFinder);

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(Offset(
        chartBox.left + 80,
        chartBox.top + 100,
      ));
      await tester.pumpAndSettle();

      await gesture.moveTo(Offset(
        chartBox.left + 400,
        chartBox.top + 100,
      ));
      await tester.pumpAndSettle();

      expect(find.byType(TooltipOverlay), findsOneWidget);
    });
  });
}
