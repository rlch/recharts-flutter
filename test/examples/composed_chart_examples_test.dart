import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recharts_flutter/recharts_flutter.dart';

final pageData = [
  {'name': 'Page A', 'uv': 590, 'pv': 800, 'amt': 1400},
  {'name': 'Page B', 'uv': 590, 'pv': 800, 'amt': 1400},
  {'name': 'Page C', 'uv': 868, 'pv': 967, 'amt': 1506},
  {'name': 'Page D', 'uv': 1397, 'pv': 1098, 'amt': 989},
  {'name': 'Page E', 'uv': 1480, 'pv': 1200, 'amt': 1228},
  {'name': 'Page F', 'uv': 1520, 'pv': 1108, 'amt': 1100},
  {'name': 'Page G', 'uv': 1400, 'pv': 680, 'amt': 1700},
];

void main() {
  Widget wrapChart(Widget child, {double width = 400, double height = 300}) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: width,
          height: height,
          child: child,
        ),
      ),
    );
  }

  group('LineBarAreaComposed', () {
    testWidgets('renders composed chart with line, bar, and area', (tester) async {
      await tester.pumpWidget(wrapChart(
        CartesianChartWidget(
          data: pageData,
          xAxes: const [XAxis(dataKey: 'name')],
          yAxes: const [YAxis()],
          isAnimationActive: false,
          grid: const CartesianGrid(strokeDasharray: [3, 3]),
          areaSeries: const [
            AreaSeries(
              dataKey: 'amt',
              fill: Color(0xFF8884D8),
              stroke: Color(0xFF8884D8),
              fillOpacity: 0.3,
            ),
          ],
          barSeries: const [
            BarSeries(
              dataKey: 'pv',
              fill: Color(0xFF82CA9D),
            ),
          ],
          lineSeries: const [
            LineSeries(
              dataKey: 'uv',
              stroke: Color(0xFFFF7300),
              strokeWidth: 2,
            ),
          ],
          tooltip: const ChartTooltip(),
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });

    testWidgets('renders in correct z-order', (tester) async {
      await tester.pumpWidget(wrapChart(
        CartesianChartWidget(
          data: pageData,
          xAxes: const [XAxis(dataKey: 'name')],
          yAxes: const [YAxis()],
          isAnimationActive: false,
          areaSeries: const [
            AreaSeries(dataKey: 'amt', fill: Color(0xFF8884D8)),
          ],
          barSeries: const [
            BarSeries(dataKey: 'pv', fill: Color(0xFF82CA9D)),
          ],
          lineSeries: const [
            LineSeries(dataKey: 'uv', stroke: Color(0xFFFF7300)),
          ],
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });

    testWidgets('renders with stacked bars and line overlay', (tester) async {
      await tester.pumpWidget(wrapChart(
        CartesianChartWidget(
          data: pageData,
          xAxes: const [XAxis(dataKey: 'name')],
          yAxes: const [YAxis()],
          isAnimationActive: false,
          barSeries: const [
            BarSeries(
              dataKey: 'pv',
              stackId: 'stack',
              fill: Color(0xFF8884D8),
            ),
            BarSeries(
              dataKey: 'amt',
              stackId: 'stack',
              fill: Color(0xFF82CA9D),
            ),
          ],
          lineSeries: const [
            LineSeries(
              dataKey: 'uv',
              stroke: Color(0xFFFF7300),
              strokeWidth: 3,
            ),
          ],
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });
  });

  group('ComposedChart edge cases', () {
    testWidgets('handles mixed null values across series', (tester) async {
      final mixedData = [
        {'name': 'A', 'line': 100, 'bar': 200, 'area': 300},
        {'name': 'B', 'line': null, 'bar': 150, 'area': 250},
        {'name': 'C', 'line': 120, 'bar': null, 'area': 280},
        {'name': 'D', 'line': 140, 'bar': 180, 'area': null},
      ];

      await tester.pumpWidget(wrapChart(
        CartesianChartWidget(
          data: mixedData,
          xAxes: const [XAxis(dataKey: 'name')],
          yAxes: const [YAxis()],
          isAnimationActive: false,
          areaSeries: const [
            AreaSeries(dataKey: 'area', fill: Color(0xFF8884D8)),
          ],
          barSeries: const [
            BarSeries(dataKey: 'bar', fill: Color(0xFF82CA9D)),
          ],
          lineSeries: const [
            LineSeries(dataKey: 'line', stroke: Color(0xFFFF7300)),
          ],
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });

    testWidgets('renders with dual Y axes', (tester) async {
      await tester.pumpWidget(wrapChart(
        CartesianChartWidget(
          data: pageData,
          xAxes: const [XAxis(dataKey: 'name')],
          yAxes: const [
            YAxis(id: 'left', orientation: AxisOrientation.left),
            YAxis(id: 'right', orientation: AxisOrientation.right),
          ],
          isAnimationActive: false,
          barSeries: const [
            BarSeries(
              dataKey: 'pv',
              yAxisId: 'left',
              fill: Color(0xFF8884D8),
            ),
          ],
          lineSeries: const [
            LineSeries(
              dataKey: 'uv',
              yAxisId: 'right',
              stroke: Color(0xFFFF7300),
            ),
          ],
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });

    testWidgets('renders empty composed chart', (tester) async {
      await tester.pumpWidget(wrapChart(
        CartesianChartWidget(
          data: const [],
          xAxes: const [XAxis(dataKey: 'name')],
          yAxes: const [YAxis()],
          isAnimationActive: false,
          areaSeries: const [
            AreaSeries(dataKey: 'amt', fill: Color(0xFF8884D8)),
          ],
          barSeries: const [
            BarSeries(dataKey: 'pv', fill: Color(0xFF82CA9D)),
          ],
          lineSeries: const [
            LineSeries(dataKey: 'uv', stroke: Color(0xFFFF7300)),
          ],
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });
  });
}
