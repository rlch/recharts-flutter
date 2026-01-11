import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recharts_flutter/src/cartesian/cartesian_chart_widget.dart';
import 'package:recharts_flutter/src/cartesian/axis/x_axis.dart';
import 'package:recharts_flutter/src/cartesian/axis/y_axis.dart';
import 'package:recharts_flutter/src/cartesian/series/line_series.dart';
import 'package:recharts_flutter/src/cartesian/series/area_series.dart';
import 'package:recharts_flutter/src/cartesian/series/bar_series.dart';
import 'package:recharts_flutter/src/cartesian/grid/cartesian_grid.dart';

void main() {
  final testData = [
    {'name': 'Jan', 'value': 400, 'value2': 240},
    {'name': 'Feb', 'value': 300, 'value2': 139},
    {'name': 'Mar', 'value': 200, 'value2': 980},
    {'name': 'Apr', 'value': 278, 'value2': 390},
    {'name': 'May', 'value': 189, 'value2': 480},
    {'name': 'Jun', 'value': 239, 'value2': 380},
  ];

  Widget wrapWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: ProviderScope(
          child: child,
        ),
      ),
    );
  }

  group('CartesianChartWidget', () {
    testWidgets('renders with fixed size', (tester) async {
      await tester.pumpWidget(wrapWidget(
        CartesianChartWidget(
          width: 400,
          height: 300,
          data: testData,
          xAxes: [const XAxis(dataKey: 'name')],
          yAxes: [const YAxis()],
          lineSeries: [const LineSeries(dataKey: 'value')],
        ),
      ));

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });

    testWidgets('renders with LayoutBuilder when no size specified', (tester) async {
      await tester.pumpWidget(wrapWidget(
        SizedBox(
          width: 500,
          height: 400,
          child: CartesianChartWidget(
            data: testData,
            xAxes: [const XAxis(dataKey: 'name')],
            yAxes: [const YAxis()],
            lineSeries: [const LineSeries(dataKey: 'value')],
          ),
        ),
      ));

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });

    testWidgets('renders line chart', (tester) async {
      await tester.pumpWidget(wrapWidget(
        CartesianChartWidget(
          width: 400,
          height: 300,
          data: testData,
          xAxes: [const XAxis(dataKey: 'name')],
          yAxes: [const YAxis()],
          lineSeries: [
            const LineSeries(dataKey: 'value', stroke: Color(0xFF8884d8)),
          ],
        ),
      ));

      await tester.pump();
      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });

    testWidgets('renders area chart', (tester) async {
      await tester.pumpWidget(wrapWidget(
        CartesianChartWidget(
          width: 400,
          height: 300,
          data: testData,
          xAxes: [const XAxis(dataKey: 'name')],
          yAxes: [const YAxis()],
          areaSeries: [
            const AreaSeries(
              dataKey: 'value',
              fill: Color(0xFF82ca9d),
              stroke: Color(0xFF82ca9d),
            ),
          ],
        ),
      ));

      await tester.pump();
      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });

    testWidgets('renders bar chart', (tester) async {
      await tester.pumpWidget(wrapWidget(
        CartesianChartWidget(
          width: 400,
          height: 300,
          data: testData,
          xAxes: [const XAxis(dataKey: 'name')],
          yAxes: [const YAxis()],
          barSeries: [
            const BarSeries(dataKey: 'value', fill: Color(0xFF8884d8)),
          ],
        ),
      ));

      await tester.pump();
      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });

    testWidgets('renders multiple series', (tester) async {
      await tester.pumpWidget(wrapWidget(
        CartesianChartWidget(
          width: 400,
          height: 300,
          data: testData,
          xAxes: [const XAxis(dataKey: 'name')],
          yAxes: [const YAxis()],
          lineSeries: [
            const LineSeries(dataKey: 'value', stroke: Color(0xFF8884d8)),
            const LineSeries(dataKey: 'value2', stroke: Color(0xFF82ca9d)),
          ],
        ),
      ));

      await tester.pump();
      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });

    testWidgets('renders with grid', (tester) async {
      await tester.pumpWidget(wrapWidget(
        CartesianChartWidget(
          width: 400,
          height: 300,
          data: testData,
          xAxes: [const XAxis(dataKey: 'name')],
          yAxes: [const YAxis()],
          grid: const CartesianGrid(),
          lineSeries: [const LineSeries(dataKey: 'value')],
        ),
      ));

      await tester.pump();
      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });

    testWidgets('renders with dashed grid', (tester) async {
      await tester.pumpWidget(wrapWidget(
        CartesianChartWidget(
          width: 400,
          height: 300,
          data: testData,
          xAxes: [const XAxis(dataKey: 'name')],
          yAxes: [const YAxis()],
          grid: const CartesianGrid(strokeDasharray: [3, 3]),
          lineSeries: [const LineSeries(dataKey: 'value')],
        ),
      ));

      await tester.pump();
      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });

    testWidgets('handles empty data', (tester) async {
      await tester.pumpWidget(wrapWidget(
        CartesianChartWidget(
          width: 400,
          height: 300,
          data: const [],
          xAxes: [const XAxis(dataKey: 'name')],
          yAxes: [const YAxis()],
          lineSeries: [const LineSeries(dataKey: 'value')],
        ),
      ));

      await tester.pump();
      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });

    testWidgets('renders nothing when dimensions are zero', (tester) async {
      await tester.pumpWidget(wrapWidget(
        CartesianChartWidget(
          width: 0,
          height: 0,
          data: testData,
          lineSeries: [const LineSeries(dataKey: 'value')],
        ),
      ));

      await tester.pump();
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('applies background color', (tester) async {
      await tester.pumpWidget(wrapWidget(
        CartesianChartWidget(
          width: 400,
          height: 300,
          data: testData,
          backgroundColor: Colors.grey.shade100,
          xAxes: [const XAxis(dataKey: 'name')],
          yAxes: [const YAxis()],
          lineSeries: [const LineSeries(dataKey: 'value')],
        ),
      ));

      await tester.pump();
      
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(CartesianChartWidget),
          matching: find.byType(Container),
        ).first,
      );
      expect(container.color, Colors.grey.shade100);
    });

    testWidgets('combines line, area, and bar series', (tester) async {
      await tester.pumpWidget(wrapWidget(
        CartesianChartWidget(
          width: 400,
          height: 300,
          data: testData,
          xAxes: [const XAxis(dataKey: 'name')],
          yAxes: [const YAxis()],
          areaSeries: [
            const AreaSeries(dataKey: 'value2', fill: Color(0x4082ca9d)),
          ],
          barSeries: [
            const BarSeries(dataKey: 'value', fill: Color(0xFF8884d8)),
          ],
          lineSeries: [
            const LineSeries(dataKey: 'value2', stroke: Color(0xFF82ca9d)),
          ],
        ),
      ));

      await tester.pump();
      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });
  });
}
