import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recharts_flutter/recharts_flutter.dart';

final radialBarData = [
  {'name': '18-24', 'uv': 31.47, 'fill': '#8884d8'},
  {'name': '25-29', 'uv': 26.69, 'fill': '#83a6ed'},
  {'name': '30-34', 'uv': 15.69, 'fill': '#8dd1e1'},
  {'name': '35-39', 'uv': 8.22, 'fill': '#82ca9d'},
  {'name': '40-49', 'uv': 8.63, 'fill': '#a4de6c'},
  {'name': '50+', 'uv': 2.63, 'fill': '#d0ed57'},
];

void main() {
  Widget wrapChart(Widget child, {double width = 400, double height = 400}) {
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

  group('SimpleRadialBarChart', () {
    testWidgets('renders radial bar chart', (tester) async {
      await tester.pumpWidget(wrapChart(
        PolarChartWidget(
          data: radialBarData,
          radialBarSeries: const [
            RadialBarSeries(
              dataKey: 'uv',
              nameKey: 'name',
              innerRadius: 0.2,
              outerRadius: 0.8,
            ),
          ],
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(PolarChartWidget), findsOneWidget);
    });

    testWidgets('renders with background', (tester) async {
      await tester.pumpWidget(wrapChart(
        PolarChartWidget(
          data: radialBarData,
          radialBarSeries: const [
            RadialBarSeries(
              dataKey: 'uv',
              nameKey: 'name',
              innerRadius: 0.2,
              outerRadius: 0.8,
              background: Color(0xFFEEEEEE),
            ),
          ],
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(PolarChartWidget), findsOneWidget);
    });

    testWidgets('renders with corner radius', (tester) async {
      await tester.pumpWidget(wrapChart(
        PolarChartWidget(
          data: radialBarData,
          radialBarSeries: const [
            RadialBarSeries(
              dataKey: 'uv',
              nameKey: 'name',
              innerRadius: 0.2,
              outerRadius: 0.8,
              cornerRadius: 10,
            ),
          ],
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(PolarChartWidget), findsOneWidget);
    });
  });

  group('RadialBarChart edge cases', () {
    testWidgets('handles empty data', (tester) async {
      await tester.pumpWidget(wrapChart(
        PolarChartWidget(
          data: const [],
          radialBarSeries: const [
            RadialBarSeries(dataKey: 'uv'),
          ],
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(PolarChartWidget), findsOneWidget);
    });

    testWidgets('handles single bar', (tester) async {
      await tester.pumpWidget(wrapChart(
        PolarChartWidget(
          data: [radialBarData.first],
          radialBarSeries: const [
            RadialBarSeries(dataKey: 'uv'),
          ],
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(PolarChartWidget), findsOneWidget);
    });

    testWidgets('renders with custom start and end angles', (tester) async {
      await tester.pumpWidget(wrapChart(
        PolarChartWidget(
          data: radialBarData,
          radialBarSeries: const [
            RadialBarSeries(
              dataKey: 'uv',
              startAngle: 90,
              endAngle: -270,
            ),
          ],
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(PolarChartWidget), findsOneWidget);
    });

    testWidgets('renders bar size variations', (tester) async {
      await tester.pumpWidget(wrapChart(
        PolarChartWidget(
          data: radialBarData,
          radialBarSeries: const [
            RadialBarSeries(
              dataKey: 'uv',
              barSize: 10,
            ),
          ],
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(PolarChartWidget), findsOneWidget);
    });

    testWidgets('handles 100% values', (tester) async {
      await tester.pumpWidget(wrapChart(
        PolarChartWidget(
          data: [
            {'name': 'A', 'value': 100},
            {'name': 'B', 'value': 100},
            {'name': 'C', 'value': 100},
          ],
          radialBarSeries: const [
            RadialBarSeries(
              dataKey: 'value',
            ),
          ],
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(PolarChartWidget), findsOneWidget);
    });

    testWidgets('handles zero values', (tester) async {
      await tester.pumpWidget(wrapChart(
        PolarChartWidget(
          data: [
            {'name': 'A', 'value': 0},
            {'name': 'B', 'value': 50},
            {'name': 'C', 'value': 0},
          ],
          radialBarSeries: const [
            RadialBarSeries(dataKey: 'value'),
          ],
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(PolarChartWidget), findsOneWidget);
    });
  });
}
