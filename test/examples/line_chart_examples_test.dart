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
  {'name': 'Page A', 'uv': 4000, 'pv': 2400, 'amt': 2400},
  {'name': 'Page B', 'uv': 3000, 'pv': 1398, 'amt': 2210},
  {'name': 'Page C', 'uv': 2000, 'pv': 9800, 'amt': 2290},
  {'name': 'Page D', 'uv': null, 'pv': 3908, 'amt': 2000},
  {'name': 'Page E', 'uv': 1890, 'pv': 4800, 'amt': 2181},
  {'name': 'Page F', 'uv': 2390, 'pv': 3800, 'amt': 2500},
  {'name': 'Page G', 'uv': 3490, 'pv': 4300, 'amt': 2100},
];

void main() {
  Widget wrapChart(Widget child, {double width = 400, double height = 300}) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(width: width, height: height, child: child),
      ),
    );
  }

  group('SimpleLineChart', () {
    testWidgets('renders with two line series', (tester) async {
      await tester.pumpWidget(
        wrapChart(
          CartesianChartWidget(
            data: pageData,
            xAxes: const [XAxis(dataKey: 'name')],
            yAxes: const [YAxis()],
            grid: const CartesianGrid(
              horizontal: true,
              vertical: true,
              strokeDasharray: [3, 3],
            ),
            isAnimationActive: false,
            lineSeries: const [
              LineSeries(
                dataKey: 'pv',
                name: 'Page Views',
                stroke: Color(0xFF8884D8),
                strokeWidth: 2,
                curveType: CurveType.monotone,
              ),
              LineSeries(
                dataKey: 'uv',
                name: 'Unique Visitors',
                stroke: Color(0xFF82CA9D),
                strokeWidth: 2,
                curveType: CurveType.monotone,
              ),
            ],
            tooltip: const ChartTooltip(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('renders with correct data', (tester) async {
      await tester.pumpWidget(
        wrapChart(
          CartesianChartWidget(
            data: pageData,
            xAxes: const [XAxis(dataKey: 'name')],
            yAxes: const [YAxis()],
            isAnimationActive: false,
            lineSeries: const [
              LineSeries(dataKey: 'pv', stroke: Color(0xFF8884D8)),
            ],
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });
  });

  group('BiaxialLineChart', () {
    testWidgets('renders with two Y axes', (tester) async {
      await tester.pumpWidget(
        wrapChart(
          CartesianChartWidget(
            data: pageData,
            xAxes: const [XAxis(dataKey: 'name')],
            yAxes: const [
              YAxis(id: 'left', orientation: AxisOrientation.left),
              YAxis(id: 'right', orientation: AxisOrientation.right),
            ],
            isAnimationActive: false,
            lineSeries: const [
              LineSeries(
                dataKey: 'pv',
                yAxisId: 'left',
                stroke: Color(0xFF8884D8),
              ),
              LineSeries(
                dataKey: 'uv',
                yAxisId: 'right',
                stroke: Color(0xFF82CA9D),
              ),
            ],
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });
  });

  group('VerticalLineChart', () {
    testWidgets('renders with linear X and category Y axes', (tester) async {
      await tester.pumpWidget(
        wrapChart(
          CartesianChartWidget(
            data: pageData,
            xAxes: const [XAxis(type: ScaleType.linear)],
            yAxes: const [YAxis(dataKey: 'name', type: ScaleType.category)],
            isAnimationActive: false,
            lineSeries: const [
              LineSeries(dataKey: 'pv', stroke: Color(0xFF8884D8)),
              LineSeries(dataKey: 'uv', stroke: Color(0xFF82CA9D)),
            ],
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    });
  });

  group('LineChartConnectNulls', () {
    testWidgets('renders with connectNulls: false (default)', (tester) async {
      await tester.pumpWidget(
        wrapChart(
          CartesianChartWidget(
            data: dataWithNulls,
            xAxes: const [XAxis(dataKey: 'name')],
            yAxes: const [YAxis()],
            isAnimationActive: false,
            lineSeries: const [
              LineSeries(
                dataKey: 'uv',
                stroke: Color(0xFF8884D8),
                connectNulls: false,
              ),
            ],
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });

    testWidgets('renders with connectNulls: true', (tester) async {
      await tester.pumpWidget(
        wrapChart(
          CartesianChartWidget(
            data: dataWithNulls,
            xAxes: const [XAxis(dataKey: 'name')],
            yAxes: const [YAxis()],
            isAnimationActive: false,
            lineSeries: const [
              LineSeries(
                dataKey: 'uv',
                stroke: Color(0xFF82CA9D),
                connectNulls: true,
              ),
            ],
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });
  });

  group('LineChartWithReferenceLines', () {
    testWidgets('renders with horizontal and vertical reference lines', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapChart(
          CartesianChartWidget(
            data: pageData,
            xAxes: const [XAxis(dataKey: 'name')],
            yAxes: const [YAxis()],
            isAnimationActive: false,
            lineSeries: const [
              LineSeries(dataKey: 'pv', stroke: Color(0xFF8884D8)),
              LineSeries(dataKey: 'uv', stroke: Color(0xFF82CA9D)),
            ],
            referenceLines: const [
              ReferenceLine(
                y: 1520,
                stroke: Color(0xFFE53935),
                strokeWidth: 2,
                strokeDasharray: [6, 4],
                label: 'Max Y (1520)',
                isFront: true,
              ),
              ReferenceLine(
                x: 'Page F',
                stroke: Color(0xFFE53935),
                strokeWidth: 2,
                strokeDasharray: [6, 4],
                label: 'Max X (Page F)',
                isFront: true,
              ),
            ],
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    });
  });

  group('LineChart edge cases', () {
    testWidgets('handles empty data', (tester) async {
      await tester.pumpWidget(
        wrapChart(
          CartesianChartWidget(
            data: const [],
            xAxes: const [XAxis(dataKey: 'name')],
            yAxes: const [YAxis()],
            isAnimationActive: false,
            lineSeries: const [
              LineSeries(dataKey: 'pv', stroke: Color(0xFF8884D8)),
            ],
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });

    testWidgets('handles single data point', (tester) async {
      await tester.pumpWidget(
        wrapChart(
          CartesianChartWidget(
            data: [pageData.first],
            xAxes: const [XAxis(dataKey: 'name')],
            yAxes: const [YAxis()],
            isAnimationActive: false,
            lineSeries: const [
              LineSeries(dataKey: 'pv', stroke: Color(0xFF8884D8)),
            ],
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });

    testWidgets('handles multiple curve types', (tester) async {
      for (final curveType in CurveType.values) {
        await tester.pumpWidget(
          wrapChart(
            CartesianChartWidget(
              data: pageData,
              xAxes: const [XAxis(dataKey: 'name')],
              yAxes: const [YAxis()],
              isAnimationActive: false,
              lineSeries: [
                LineSeries(
                  dataKey: 'pv',
                  stroke: const Color(0xFF8884D8),
                  curveType: curveType,
                ),
              ],
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(
          find.byType(CartesianChartWidget),
          findsOneWidget,
          reason: 'Failed with curveType: $curveType',
        );
      }
    });

    testWidgets('renders with dots enabled', (tester) async {
      await tester.pumpWidget(
        wrapChart(
          CartesianChartWidget(
            data: pageData,
            xAxes: const [XAxis(dataKey: 'name')],
            yAxes: const [YAxis()],
            isAnimationActive: false,
            lineSeries: const [
              LineSeries(
                dataKey: 'pv',
                stroke: Color(0xFF8884D8),
                dot: true,
                dotConfig: DotConfig(radius: 6),
              ),
            ],
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });

    testWidgets('renders with hide = true', (tester) async {
      await tester.pumpWidget(
        wrapChart(
          CartesianChartWidget(
            data: pageData,
            xAxes: const [XAxis(dataKey: 'name')],
            yAxes: const [YAxis()],
            isAnimationActive: false,
            lineSeries: const [
              LineSeries(dataKey: 'pv', stroke: Color(0xFF8884D8), hide: true),
              LineSeries(dataKey: 'uv', stroke: Color(0xFF82CA9D)),
            ],
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });

    testWidgets('renders with different stroke widths', (tester) async {
      await tester.pumpWidget(
        wrapChart(
          CartesianChartWidget(
            data: pageData,
            xAxes: const [XAxis(dataKey: 'name')],
            yAxes: const [YAxis()],
            isAnimationActive: false,
            lineSeries: const [
              LineSeries(
                dataKey: 'pv',
                stroke: Color(0xFF8884D8),
                strokeWidth: 1,
              ),
              LineSeries(
                dataKey: 'uv',
                stroke: Color(0xFF82CA9D),
                strokeWidth: 4,
              ),
            ],
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });
  });
}
