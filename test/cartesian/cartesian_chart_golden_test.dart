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
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: ProviderScope(
          child: Center(child: child),
        ),
      ),
    );
  }

  group('Golden Tests', () {
    testWidgets('line chart golden', (tester) async {
      await tester.pumpWidget(wrapWidget(
        RepaintBoundary(
          child: CartesianChartWidget(
            width: 400,
            height: 300,
            data: testData,
            backgroundColor: Colors.white,
            xAxes: [const XAxis(dataKey: 'name')],
            yAxes: [const YAxis()],
            grid: const CartesianGrid(strokeDasharray: [3, 3]),
            lineSeries: [
              const LineSeries(
                dataKey: 'value',
                stroke: Color(0xFF8884d8),
                strokeWidth: 2,
              ),
            ],
          ),
        ),
      ));

      await tester.pump();

      await expectLater(
        find.byType(CartesianChartWidget),
        matchesGoldenFile('goldens/line_chart.png'),
      );
    });

    testWidgets('multi-line chart golden', (tester) async {
      await tester.pumpWidget(wrapWidget(
        RepaintBoundary(
          child: CartesianChartWidget(
            width: 400,
            height: 300,
            data: testData,
            backgroundColor: Colors.white,
            xAxes: [const XAxis(dataKey: 'name')],
            yAxes: [const YAxis()],
            grid: const CartesianGrid(strokeDasharray: [3, 3]),
            lineSeries: [
              const LineSeries(
                dataKey: 'value',
                stroke: Color(0xFF8884d8),
                strokeWidth: 2,
              ),
              const LineSeries(
                dataKey: 'value2',
                stroke: Color(0xFF82ca9d),
                strokeWidth: 2,
              ),
            ],
          ),
        ),
      ));

      await tester.pump();

      await expectLater(
        find.byType(CartesianChartWidget),
        matchesGoldenFile('goldens/multi_line_chart.png'),
      );
    });

    testWidgets('area chart golden', (tester) async {
      await tester.pumpWidget(wrapWidget(
        RepaintBoundary(
          child: CartesianChartWidget(
            width: 400,
            height: 300,
            data: testData,
            backgroundColor: Colors.white,
            xAxes: [const XAxis(dataKey: 'name')],
            yAxes: [const YAxis()],
            grid: const CartesianGrid(strokeDasharray: [3, 3]),
            areaSeries: [
              const AreaSeries(
                dataKey: 'value',
                fill: Color(0xFF8884d8),
                stroke: Color(0xFF8884d8),
                fillOpacity: 0.3,
              ),
            ],
          ),
        ),
      ));

      await tester.pump();

      await expectLater(
        find.byType(CartesianChartWidget),
        matchesGoldenFile('goldens/area_chart.png'),
      );
    });

    testWidgets('bar chart golden', (tester) async {
      await tester.pumpWidget(wrapWidget(
        RepaintBoundary(
          child: CartesianChartWidget(
            width: 400,
            height: 300,
            data: testData,
            backgroundColor: Colors.white,
            xAxes: [const XAxis(dataKey: 'name')],
            yAxes: [const YAxis()],
            grid: const CartesianGrid(strokeDasharray: [3, 3]),
            barSeries: [
              const BarSeries(
                dataKey: 'value',
                fill: Color(0xFF8884d8),
              ),
            ],
          ),
        ),
      ));

      await tester.pump();

      await expectLater(
        find.byType(CartesianChartWidget),
        matchesGoldenFile('goldens/bar_chart.png'),
      );
    });

    testWidgets('grouped bar chart golden', (tester) async {
      await tester.pumpWidget(wrapWidget(
        RepaintBoundary(
          child: CartesianChartWidget(
            width: 400,
            height: 300,
            data: testData,
            backgroundColor: Colors.white,
            xAxes: [const XAxis(dataKey: 'name')],
            yAxes: [const YAxis()],
            grid: const CartesianGrid(strokeDasharray: [3, 3]),
            barSeries: [
              const BarSeries(
                dataKey: 'value',
                fill: Color(0xFF8884d8),
              ),
              const BarSeries(
                dataKey: 'value2',
                fill: Color(0xFF82ca9d),
              ),
            ],
          ),
        ),
      ));

      await tester.pump();

      await expectLater(
        find.byType(CartesianChartWidget),
        matchesGoldenFile('goldens/grouped_bar_chart.png'),
      );
    });

    testWidgets('combined chart golden', (tester) async {
      await tester.pumpWidget(wrapWidget(
        RepaintBoundary(
          child: CartesianChartWidget(
            width: 400,
            height: 300,
            data: testData,
            backgroundColor: Colors.white,
            xAxes: [const XAxis(dataKey: 'name')],
            yAxes: [const YAxis()],
            grid: const CartesianGrid(strokeDasharray: [3, 3]),
            areaSeries: [
              const AreaSeries(
                dataKey: 'value2',
                fill: Color(0xFF82ca9d),
                stroke: Color(0xFF82ca9d),
                fillOpacity: 0.2,
              ),
            ],
            barSeries: [
              const BarSeries(
                dataKey: 'value',
                fill: Color(0xFF8884d8),
              ),
            ],
            lineSeries: [
              const LineSeries(
                dataKey: 'value2',
                stroke: Color(0xFF82ca9d),
                strokeWidth: 2,
              ),
            ],
          ),
        ),
      ));

      await tester.pump();

      await expectLater(
        find.byType(CartesianChartWidget),
        matchesGoldenFile('goldens/combined_chart.png'),
      );
    });
  });
}
