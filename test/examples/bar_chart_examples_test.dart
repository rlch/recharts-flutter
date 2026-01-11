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

final pageDataWithNegativeNumbers = [
  {'name': 'Page A', 'uv': 4000, 'pv': 2400, 'amt': 2400},
  {'name': 'Page B', 'uv': -3000, 'pv': 1398, 'amt': 2210},
  {'name': 'Page C', 'uv': -2000, 'pv': -9800, 'amt': 2290},
  {'name': 'Page D', 'uv': 2780, 'pv': 3908, 'amt': 2000},
  {'name': 'Page E', 'uv': -1890, 'pv': 4800, 'amt': 2181},
  {'name': 'Page F', 'uv': 2390, 'pv': -3800, 'amt': 2500},
  {'name': 'Page G', 'uv': 3490, 'pv': 4300, 'amt': 2100},
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

  group('SimpleBarChart', () {
    testWidgets('renders with two bar series', (tester) async {
      await tester.pumpWidget(wrapChart(
        CartesianChartWidget(
          data: pageData,
          xAxes: const [XAxis(dataKey: 'name')],
          yAxes: const [YAxis()],
          isAnimationActive: false,
          grid: const CartesianGrid(
            horizontal: true,
            vertical: false,
            strokeDasharray: [3, 3],
          ),
          barSeries: const [
            BarSeries(
              dataKey: 'pv',
              name: 'Page Views',
              fill: Color(0xFF8884D8),
            ),
            BarSeries(
              dataKey: 'uv',
              name: 'Unique Visitors',
              fill: Color(0xFF82CA9D),
            ),
          ],
          tooltip: const ChartTooltip(),
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });

    testWidgets('renders single bar series', (tester) async {
      await tester.pumpWidget(wrapChart(
        CartesianChartWidget(
          data: pageData,
          xAxes: const [XAxis(dataKey: 'name')],
          yAxes: const [YAxis()],
          isAnimationActive: false,
          barSeries: const [
            BarSeries(dataKey: 'pv', fill: Color(0xFF8884D8)),
          ],
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });
  });

  group('StackedBarChart', () {
    testWidgets('renders with stacked bars', (tester) async {
      await tester.pumpWidget(wrapChart(
        CartesianChartWidget(
          data: pageData,
          xAxes: const [XAxis(dataKey: 'name')],
          yAxes: const [YAxis()],
          isAnimationActive: false,
          barSeries: const [
            BarSeries(
              dataKey: 'pv',
              stackId: 'stack1',
              fill: Color(0xFF8884D8),
            ),
            BarSeries(
              dataKey: 'uv',
              stackId: 'stack1',
              fill: Color(0xFF82CA9D),
            ),
          ],
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });

    testWidgets('renders multiple stacks', (tester) async {
      await tester.pumpWidget(wrapChart(
        CartesianChartWidget(
          data: pageData,
          xAxes: const [XAxis(dataKey: 'name')],
          yAxes: const [YAxis()],
          isAnimationActive: false,
          barSeries: const [
            BarSeries(
              dataKey: 'pv',
              stackId: 'stack1',
              fill: Color(0xFF8884D8),
            ),
            BarSeries(
              dataKey: 'amt',
              stackId: 'stack1',
              fill: Color(0xFF82CA9D),
            ),
            BarSeries(
              dataKey: 'uv',
              stackId: 'stack2',
              fill: Color(0xFFFFC658),
            ),
          ],
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });
  });

  group('MixBarChart', () {
    testWidgets('renders mixed stacked and grouped bars', (tester) async {
      await tester.pumpWidget(wrapChart(
        CartesianChartWidget(
          data: pageData,
          xAxes: const [XAxis(dataKey: 'name')],
          yAxes: const [YAxis()],
          isAnimationActive: false,
          barSeries: const [
            BarSeries(
              dataKey: 'pv',
              stackId: 'a',
              fill: Color(0xFF8884D8),
            ),
            BarSeries(
              dataKey: 'amt',
              stackId: 'a',
              fill: Color(0xFF82CA9D),
            ),
            BarSeries(
              dataKey: 'uv',
              fill: Color(0xFFFFC658),
            ),
          ],
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });
  });

  group('PositiveNegativeBarChart', () {
    testWidgets('renders with positive and negative values', (tester) async {
      await tester.pumpWidget(wrapChart(
        CartesianChartWidget(
          data: pageDataWithNegativeNumbers,
          xAxes: const [XAxis(dataKey: 'name')],
          yAxes: const [YAxis()],
          isAnimationActive: false,
          barSeries: const [
            BarSeries(
              dataKey: 'pv',
              fill: Color(0xFF8884D8),
            ),
            BarSeries(
              dataKey: 'uv',
              fill: Color(0xFF82CA9D),
            ),
          ],
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });
  });

  group('BarChart edge cases', () {
    testWidgets('handles empty data', (tester) async {
      await tester.pumpWidget(wrapChart(
        CartesianChartWidget(
          data: const [],
          xAxes: const [XAxis(dataKey: 'name')],
          yAxes: const [YAxis()],
          isAnimationActive: false,
          barSeries: const [
            BarSeries(dataKey: 'pv', fill: Color(0xFF8884D8)),
          ],
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });

    testWidgets('handles single data point', (tester) async {
      await tester.pumpWidget(wrapChart(
        CartesianChartWidget(
          data: [pageData.first],
          xAxes: const [XAxis(dataKey: 'name')],
          yAxes: const [YAxis()],
          isAnimationActive: false,
          barSeries: const [
            BarSeries(dataKey: 'pv', fill: Color(0xFF8884D8)),
          ],
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });

    testWidgets('renders with radius (rounded bars)', (tester) async {
      await tester.pumpWidget(wrapChart(
        CartesianChartWidget(
          data: pageData,
          xAxes: const [XAxis(dataKey: 'name')],
          yAxes: const [YAxis()],
          isAnimationActive: false,
          barSeries: const [
            BarSeries(
              dataKey: 'pv',
              fill: Color(0xFF8884D8),
              radius: 8,
            ),
          ],
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });

    testWidgets('renders with background', (tester) async {
      await tester.pumpWidget(wrapChart(
        CartesianChartWidget(
          data: pageData,
          xAxes: const [XAxis(dataKey: 'name')],
          yAxes: const [YAxis()],
          isAnimationActive: false,
          barSeries: const [
            BarSeries(
              dataKey: 'pv',
              fill: Color(0xFF8884D8),
              background: true,
              backgroundFill: Color(0xFFEEEEEE),
            ),
          ],
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });

    testWidgets('renders with hide = true', (tester) async {
      await tester.pumpWidget(wrapChart(
        CartesianChartWidget(
          data: pageData,
          xAxes: const [XAxis(dataKey: 'name')],
          yAxes: const [YAxis()],
          isAnimationActive: false,
          barSeries: const [
            BarSeries(dataKey: 'pv', fill: Color(0xFF8884D8), hide: true),
            BarSeries(dataKey: 'uv', fill: Color(0xFF82CA9D)),
          ],
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });
  });
}
