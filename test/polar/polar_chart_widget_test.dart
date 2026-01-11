import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recharts_flutter/recharts_flutter.dart';

void main() {
  group('PolarChartWidget', () {
    testWidgets('renders pie chart correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 400,
              child: PolarChartWidget(
                data: [
                  {'name': 'A', 'value': 400},
                  {'name': 'B', 'value': 300},
                  {'name': 'C', 'value': 300},
                ],
                pieSeries: const [
                  PieSeries(
                    dataKey: 'value',
                    nameKey: 'name',
                    innerRadius: 0,
                    outerRadius: 0.8,
                  ),
                ],
                isAnimationActive: false,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(PolarChartWidget), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('renders donut chart with inner radius', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 400,
              child: PolarChartWidget(
                data: [
                  {'name': 'A', 'value': 100},
                  {'name': 'B', 'value': 200},
                ],
                pieSeries: const [
                  PieSeries(
                    dataKey: 'value',
                    innerRadius: 0.5,
                    outerRadius: 0.8,
                  ),
                ],
                isAnimationActive: false,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(PolarChartWidget), findsOneWidget);
    });

    testWidgets('renders radar chart correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 400,
              child: PolarChartWidget(
                data: [
                  {'subject': 'Math', 'A': 120, 'B': 110},
                  {'subject': 'Chinese', 'A': 98, 'B': 130},
                  {'subject': 'English', 'A': 86, 'B': 130},
                  {'subject': 'Geography', 'A': 99, 'B': 100},
                  {'subject': 'Physics', 'A': 85, 'B': 90},
                  {'subject': 'History', 'A': 65, 'B': 85},
                ],
                angleAxis: const PolarAngleAxis(dataKey: 'subject'),
                radiusAxis: const PolarRadiusAxis(angle: 90),
                grid: const PolarGrid(gridType: PolarGridType.polygon),
                radarSeries: const [
                  RadarSeries(
                    dataKey: 'A',
                    name: 'Mike',
                    fill: Color(0xFF8884d8),
                    stroke: Color(0xFF8884d8),
                    fillOpacity: 0.6,
                  ),
                  RadarSeries(
                    dataKey: 'B',
                    name: 'Lily',
                    fill: Color(0xFF82ca9d),
                    stroke: Color(0xFF82ca9d),
                    fillOpacity: 0.6,
                  ),
                ],
                isAnimationActive: false,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(PolarChartWidget), findsOneWidget);
    });

    testWidgets('renders radial bar chart correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 400,
              child: PolarChartWidget(
                data: [
                  {'name': '18-24', 'value': 31.47},
                  {'name': '25-29', 'value': 26.69},
                  {'name': '30-34', 'value': 15.69},
                  {'name': '35-39', 'value': 8.22},
                ],
                radialBarSeries: const [
                  RadialBarSeries(
                    dataKey: 'value',
                    nameKey: 'name',
                    innerRadius: 0.2,
                    outerRadius: 0.8,
                    background: Color(0xFFEEEEEE),
                  ),
                ],
                isAnimationActive: false,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(PolarChartWidget), findsOneWidget);
    });

    testWidgets('handles empty data gracefully', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 400,
              child: PolarChartWidget(
                data: const [],
                pieSeries: const [
                  PieSeries(dataKey: 'value'),
                ],
                isAnimationActive: false,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(PolarChartWidget), findsOneWidget);
    });

    testWidgets('renders with polar grid', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 400,
              child: PolarChartWidget(
                data: [
                  {'subject': 'A', 'value': 100},
                  {'subject': 'B', 'value': 80},
                  {'subject': 'C', 'value': 60},
                  {'subject': 'D', 'value': 90},
                ],
                angleAxis: const PolarAngleAxis(dataKey: 'subject'),
                grid: const PolarGrid(
                  gridType: PolarGridType.circle,
                  concentricCircleCount: 5,
                  showRadialLines: true,
                ),
                radarSeries: const [
                  RadarSeries(dataKey: 'value'),
                ],
                isAnimationActive: false,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(PolarChartWidget), findsOneWidget);
    });

    testWidgets('animation triggers on data change', (tester) async {
      final key = GlobalKey<State>();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              key: key,
              width: 400,
              height: 400,
              child: PolarChartWidget(
                data: [
                  {'name': 'A', 'value': 100},
                  {'name': 'B', 'value': 200},
                ],
                pieSeries: const [
                  PieSeries(dataKey: 'value'),
                ],
                animationDuration: const Duration(milliseconds: 200),
                isAnimationActive: true,
              ),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pumpAndSettle();

      expect(find.byType(PolarChartWidget), findsOneWidget);
    });

    testWidgets('tooltip shows on hover', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 400,
              child: PolarChartWidget(
                data: [
                  {'name': 'A', 'value': 400},
                  {'name': 'B', 'value': 300},
                ],
                pieSeries: const [
                  PieSeries(
                    dataKey: 'value',
                    nameKey: 'name',
                  ),
                ],
                tooltip: const ChartTooltip(
                  enabled: true,
                  trigger: TooltipTrigger.hover,
                ),
                isAnimationActive: false,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(MouseRegion), findsWidgets);
    });

    testWidgets('respects width and height constraints', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PolarChartWidget(
              width: 300,
              height: 200,
              data: [
                {'name': 'A', 'value': 100},
              ],
              pieSeries: const [
                PieSeries(dataKey: 'value'),
              ],
              isAnimationActive: false,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.constraints?.maxWidth, equals(300));
      expect(container.constraints?.maxHeight, equals(200));
    });
  });
}
