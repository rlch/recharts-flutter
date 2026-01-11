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

final dataWithNulls = [
  {'name': 'Page A', 'uv': 4000, 'pv': 2400},
  {'name': 'Page B', 'uv': 3000, 'pv': 1398},
  {'name': 'Page C', 'uv': 2000, 'pv': 9800},
  {'name': 'Page D', 'uv': null, 'pv': 3908},
  {'name': 'Page E', 'uv': 1890, 'pv': 4800},
  {'name': 'Page F', 'uv': 2390, 'pv': 3800},
  {'name': 'Page G', 'uv': 3490, 'pv': 4300},
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

  group('SimpleAreaChart', () {
    testWidgets('renders with single area series', (tester) async {
      await tester.pumpWidget(wrapChart(
        CartesianChartWidget(
          data: pageData,
          xAxes: const [XAxis(dataKey: 'name')],
          yAxes: const [YAxis()],
          grid: const CartesianGrid(strokeDasharray: [3, 3]),
          isAnimationActive: false,
          areaSeries: const [
            AreaSeries(
              dataKey: 'uv',
              fill: Color(0xFF8884D8),
              stroke: Color(0xFF8884D8),
              fillOpacity: 0.3,
              isAnimationActive: false,
            ),
          ],
          tooltip: const ChartTooltip(),
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });

    testWidgets('renders with custom fill opacity', (tester) async {
      await tester.pumpWidget(wrapChart(
        CartesianChartWidget(
          data: pageData,
          xAxes: const [XAxis(dataKey: 'name')],
          yAxes: const [YAxis()],
          isAnimationActive: false,
          areaSeries: const [
            AreaSeries(
              dataKey: 'uv',
              fill: Color(0xFF8884D8),
              stroke: Color(0xFF8884D8),
              fillOpacity: 0.6,
            ),
          ],
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });
  });

  group('StackedAreaChart', () {
    testWidgets('renders with stacked areas', (tester) async {
      await tester.pumpWidget(wrapChart(
        CartesianChartWidget(
          data: pageData,
          xAxes: const [XAxis(dataKey: 'name')],
          yAxes: const [YAxis()],
          isAnimationActive: false,
          areaSeries: const [
            AreaSeries(
              dataKey: 'uv',
              stackId: 'stack1',
              fill: Color(0xFF8884D8),
              stroke: Color(0xFF8884D8),
            ),
            AreaSeries(
              dataKey: 'pv',
              stackId: 'stack1',
              fill: Color(0xFF82CA9D),
              stroke: Color(0xFF82CA9D),
            ),
            AreaSeries(
              dataKey: 'amt',
              stackId: 'stack1',
              fill: Color(0xFFFFC658),
              stroke: Color(0xFFFFC658),
            ),
          ],
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });
  });

  group('AreaChartConnectNulls', () {
    testWidgets('renders with connectNulls: false', (tester) async {
      await tester.pumpWidget(wrapChart(
        CartesianChartWidget(
          data: dataWithNulls,
          xAxes: const [XAxis(dataKey: 'name')],
          yAxes: const [YAxis()],
          areaSeries: const [
            AreaSeries(
              dataKey: 'uv',
              fill: Color(0xFF8884D8),
              stroke: Color(0xFF8884D8),
              connectNulls: false,
              isAnimationActive: false,
            ),
          ],
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });

    testWidgets('renders with connectNulls: true', (tester) async {
      await tester.pumpWidget(wrapChart(
        CartesianChartWidget(
          data: dataWithNulls,
          xAxes: const [XAxis(dataKey: 'name')],
          yAxes: const [YAxis()],
          isAnimationActive: false,
          areaSeries: const [
            AreaSeries(
              dataKey: 'uv',
              fill: Color(0xFF82CA9D),
              stroke: Color(0xFF82CA9D),
              connectNulls: true,
              isAnimationActive: false,
            ),
          ],
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });
  });

  group('AreaChart edge cases', () {
    testWidgets('handles empty data', (tester) async {
      await tester.pumpWidget(wrapChart(
        CartesianChartWidget(
          data: const [],
          xAxes: const [XAxis(dataKey: 'name')],
          yAxes: const [YAxis()],
          isAnimationActive: false,
          areaSeries: const [
            AreaSeries(dataKey: 'uv', fill: Color(0xFF8884D8)),
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
          areaSeries: const [
            AreaSeries(dataKey: 'uv', fill: Color(0xFF8884D8)),
          ],
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });

    testWidgets('renders with custom base value', (tester) async {
      await tester.pumpWidget(wrapChart(
        CartesianChartWidget(
          data: pageData,
          xAxes: const [XAxis(dataKey: 'name')],
          yAxes: const [YAxis()],
          isAnimationActive: false,
          areaSeries: const [
            AreaSeries(
              dataKey: 'uv',
              fill: Color(0xFF8884D8),
              baseValue: 500,
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
          areaSeries: const [
            AreaSeries(dataKey: 'uv', fill: Color(0xFF8884D8), hide: true),
            AreaSeries(dataKey: 'pv', fill: Color(0xFF82CA9D)),
          ],
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });

    testWidgets('renders with dots enabled', (tester) async {
      await tester.pumpWidget(wrapChart(
        CartesianChartWidget(
          data: pageData,
          xAxes: const [XAxis(dataKey: 'name')],
          yAxes: const [YAxis()],
          isAnimationActive: false,
          areaSeries: const [
            AreaSeries(
              dataKey: 'uv',
              fill: Color(0xFF8884D8),
              dot: true,
            ),
          ],
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });
  });
}
