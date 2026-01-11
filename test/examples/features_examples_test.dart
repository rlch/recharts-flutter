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

  group('CustomTooltip', () {
    testWidgets('renders with default tooltip', (tester) async {
      await tester.pumpWidget(wrapChart(
        CartesianChartWidget(
          data: pageData,
          xAxes: const [XAxis(dataKey: 'name')],
          yAxes: const [YAxis()],
          lineSeries: const [
            LineSeries(dataKey: 'pv', stroke: Color(0xFF8884D8)),
          ],
          tooltip: const ChartTooltip(),
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });

    testWidgets('renders with custom tooltip trigger', (tester) async {
      await tester.pumpWidget(wrapChart(
        CartesianChartWidget(
          data: pageData,
          xAxes: const [XAxis(dataKey: 'name')],
          yAxes: const [YAxis()],
          lineSeries: const [
            LineSeries(dataKey: 'pv', stroke: Color(0xFF8884D8)),
          ],
          tooltip: const ChartTooltip(trigger: TooltipTrigger.click),
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });

    testWidgets('tooltip disabled', (tester) async {
      await tester.pumpWidget(wrapChart(
        CartesianChartWidget(
          data: pageData,
          xAxes: const [XAxis(dataKey: 'name')],
          yAxes: const [YAxis()],
          lineSeries: const [
            LineSeries(dataKey: 'pv', stroke: Color(0xFF8884D8)),
          ],
          tooltip: const ChartTooltip(enabled: false),
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });
  });

  group('LegendToggle', () {
    testWidgets('renders chart with toggleable legend', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 400,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        color: const Color(0xFF8884D8),
                      ),
                      const SizedBox(width: 8),
                      const Text('Series 1'),
                    ],
                  ),
                  Expanded(
                    child: CartesianChartWidget(
                      data: pageData,
                      xAxes: const [XAxis(dataKey: 'name')],
                      yAxes: const [YAxis()],
                      lineSeries: const [
                        LineSeries(
                          dataKey: 'pv',
                          stroke: Color(0xFF8884D8),
                          hide: false,
                        ),
                        LineSeries(
                          dataKey: 'uv',
                          stroke: Color(0xFF82CA9D),
                          hide: false,
                        ),
                      ],
                      isAnimationActive: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });

    testWidgets('series can be hidden', (tester) async {
      await tester.pumpWidget(wrapChart(
        CartesianChartWidget(
          data: pageData,
          xAxes: const [XAxis(dataKey: 'name')],
          yAxes: const [YAxis()],
          lineSeries: const [
            LineSeries(
              dataKey: 'pv',
              stroke: Color(0xFF8884D8),
              hide: true,
            ),
            LineSeries(
              dataKey: 'uv',
              stroke: Color(0xFF82CA9D),
              hide: false,
            ),
          ],
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });

    testWidgets('all series hidden', (tester) async {
      await tester.pumpWidget(wrapChart(
        CartesianChartWidget(
          data: pageData,
          xAxes: const [XAxis(dataKey: 'name')],
          yAxes: const [YAxis()],
          lineSeries: const [
            LineSeries(dataKey: 'pv', hide: true),
            LineSeries(dataKey: 'uv', hide: true),
          ],
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });
  });

  group('ResponsiveContainer', () {
    testWidgets('chart fills available space', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 600,
              height: 400,
              child: CartesianChartWidget(
                data: pageData,
                xAxes: const [XAxis(dataKey: 'name')],
                yAxes: const [YAxis()],
                lineSeries: const [
                  LineSeries(dataKey: 'pv', stroke: Color(0xFF8884D8)),
                ],
                isAnimationActive: false,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });

    testWidgets('chart adapts to different sizes', (tester) async {
      for (final size in [
        const Size(300, 200),
        const Size(600, 400),
        const Size(800, 600),
      ]) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: size.width,
                height: size.height,
                child: CartesianChartWidget(
                  data: pageData,
                  xAxes: const [XAxis(dataKey: 'name')],
                  yAxes: const [YAxis()],
                  lineSeries: const [
                    LineSeries(dataKey: 'pv', stroke: Color(0xFF8884D8)),
                  ],
                  isAnimationActive: false,
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.byType(CartesianChartWidget), findsOneWidget,
            reason: 'Failed at size: $size');
      }
    });

    testWidgets('handles very small container', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 100,
              height: 50,
              child: CartesianChartWidget(
                data: pageData,
                xAxes: const [XAxis(dataKey: 'name')],
                yAxes: const [YAxis()],
                lineSeries: const [
                  LineSeries(dataKey: 'pv', stroke: Color(0xFF8884D8)),
                ],
                isAnimationActive: false,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });

    testWidgets('handles zero dimensions gracefully', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 0,
              height: 0,
              child: CartesianChartWidget(
                data: pageData,
                lineSeries: const [
                  LineSeries(dataKey: 'pv', stroke: Color(0xFF8884D8)),
                ],
                isAnimationActive: false,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsOneWidget);
    });
  });

  group('SynchronizedCharts', () {
    testWidgets('renders multiple charts with same data', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: CartesianChartWidget(
                    syncId: 'sync-test',
                    data: pageData,
                    xAxes: const [XAxis(dataKey: 'name')],
                    yAxes: const [YAxis()],
                    lineSeries: const [
                      LineSeries(dataKey: 'pv', stroke: Color(0xFF8884D8)),
                    ],
                    isAnimationActive: false,
                  ),
                ),
                Expanded(
                  child: CartesianChartWidget(
                    syncId: 'sync-test',
                    data: pageData,
                    xAxes: const [XAxis(dataKey: 'name')],
                    yAxes: const [YAxis()],
                    lineSeries: const [
                      LineSeries(dataKey: 'uv', stroke: Color(0xFF82CA9D)),
                    ],
                    isAnimationActive: false,
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

    testWidgets('renders three synchronized charts', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: CartesianChartWidget(
                    syncId: 'triple-sync',
                    data: pageData,
                    xAxes: const [XAxis(dataKey: 'name')],
                    yAxes: const [YAxis()],
                    lineSeries: const [
                      LineSeries(dataKey: 'pv', stroke: Color(0xFF8884D8)),
                    ],
                    isAnimationActive: false,
                  ),
                ),
                Expanded(
                  child: CartesianChartWidget(
                    syncId: 'triple-sync',
                    data: pageData,
                    xAxes: const [XAxis(dataKey: 'name')],
                    yAxes: const [YAxis()],
                    barSeries: const [
                      BarSeries(dataKey: 'uv', fill: Color(0xFF82CA9D)),
                    ],
                    isAnimationActive: false,
                  ),
                ),
                Expanded(
                  child: CartesianChartWidget(
                    syncId: 'triple-sync',
                    data: pageData,
                    xAxes: const [XAxis(dataKey: 'name')],
                    yAxes: const [YAxis()],
                    areaSeries: const [
                      AreaSeries(dataKey: 'amt', fill: Color(0xFFFFC658)),
                    ],
                    isAnimationActive: false,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(CartesianChartWidget), findsNWidgets(3));
    });
  });
}
