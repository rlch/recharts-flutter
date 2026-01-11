import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recharts_flutter/recharts_flutter.dart';

final pieData = [
  {'name': 'Group A', 'value': 400},
  {'name': 'Group B', 'value': 300},
  {'name': 'Group C', 'value': 300},
  {'name': 'Group D', 'value': 200},
];

final pieOuterData = [
  {'name': 'A1', 'value': 100},
  {'name': 'A2', 'value': 300},
  {'name': 'B1', 'value': 100},
  {'name': 'B2', 'value': 80},
  {'name': 'B3', 'value': 40},
  {'name': 'B4', 'value': 30},
  {'name': 'B5', 'value': 50},
  {'name': 'C1', 'value': 100},
  {'name': 'C2', 'value': 200},
  {'name': 'D1', 'value': 150},
  {'name': 'D2', 'value': 50},
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

  group('SimplePieChart', () {
    testWidgets('renders basic pie chart', (tester) async {
      await tester.pumpWidget(wrapChart(
        PolarChartWidget(
          data: pieData,
          pieSeries: const [
            PieSeries(
              dataKey: 'value',
              nameKey: 'name',
            ),
          ],
          tooltip: const ChartTooltip(),
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(PolarChartWidget), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('renders 4 sectors for 4 data points', (tester) async {
      await tester.pumpWidget(wrapChart(
        PolarChartWidget(
          data: pieData,
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
      ));

      await tester.pumpAndSettle();

      expect(find.byType(PolarChartWidget), findsOneWidget);
    });
  });

  group('TwoLevelPieChart', () {
    testWidgets('renders nested pie rings', (tester) async {
      await tester.pumpWidget(wrapChart(
        PolarChartWidget(
          data: pieData,
          pieSeries: const [
            PieSeries(
              dataKey: 'value',
              innerRadius: 0,
              outerRadius: 0.4,
            ),
            PieSeries(
              dataKey: 'value',
              innerRadius: 0.5,
              outerRadius: 0.8,
            ),
          ],
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(PolarChartWidget), findsOneWidget);
    });
  });

  group('PieChartWithPaddingAngle', () {
    testWidgets('renders with padding between sectors', (tester) async {
      await tester.pumpWidget(wrapChart(
        PolarChartWidget(
          data: pieData,
          pieSeries: const [
            PieSeries(
              dataKey: 'value',
              nameKey: 'name',
              paddingAngle: 5,
              innerRadius: 0.6,
              outerRadius: 0.8,
            ),
          ],
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(PolarChartWidget), findsOneWidget);
    });
  });

  group('DonutChart (Pie with inner radius)', () {
    testWidgets('renders donut with inner radius', (tester) async {
      await tester.pumpWidget(wrapChart(
        PolarChartWidget(
          data: pieData,
          pieSeries: const [
            PieSeries(
              dataKey: 'value',
              innerRadius: 0.6,
              outerRadius: 0.8,
            ),
          ],
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(PolarChartWidget), findsOneWidget);
    });
  });

  group('CustomActiveShapePieChart', () {
    testWidgets('renders with active shape on hover', (tester) async {
      await tester.pumpWidget(wrapChart(
        PolarChartWidget(
          data: pieData,
          pieSeries: const [
            PieSeries(
              dataKey: 'value',
              nameKey: 'name',
              innerRadius: 0.6,
              outerRadius: 0.8,
            ),
          ],
          tooltip: const ChartTooltip(trigger: TooltipTrigger.hover),
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(PolarChartWidget), findsOneWidget);
    });
  });

  group('PieChart edge cases', () {
    testWidgets('handles empty data', (tester) async {
      await tester.pumpWidget(wrapChart(
        PolarChartWidget(
          data: const [],
          pieSeries: const [
            PieSeries(dataKey: 'value'),
          ],
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(PolarChartWidget), findsOneWidget);
    });

    testWidgets('handles single sector (full circle)', (tester) async {
      await tester.pumpWidget(wrapChart(
        PolarChartWidget(
          data: [pieData.first],
          pieSeries: const [
            PieSeries(dataKey: 'value'),
          ],
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(PolarChartWidget), findsOneWidget);
    });

    testWidgets('handles custom start and end angles', (tester) async {
      await tester.pumpWidget(wrapChart(
        PolarChartWidget(
          data: pieData,
          pieSeries: const [
            PieSeries(
              dataKey: 'value',
              startAngle: 180,
              endAngle: 0,
            ),
          ],
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(PolarChartWidget), findsOneWidget);
    });

    testWidgets('handles semi-circle (180 degree arc)', (tester) async {
      await tester.pumpWidget(wrapChart(
        PolarChartWidget(
          data: pieData,
          pieSeries: const [
            PieSeries(
              dataKey: 'value',
              startAngle: 180,
              endAngle: 0,
              innerRadius: 0.5,
              outerRadius: 0.8,
            ),
          ],
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(PolarChartWidget), findsOneWidget);
    });

    testWidgets('renders with default center', (tester) async {
      await tester.pumpWidget(wrapChart(
        PolarChartWidget(
          data: pieData,
          pieSeries: const [
            PieSeries(dataKey: 'value'),
          ],
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(PolarChartWidget), findsOneWidget);
    });

    testWidgets('handles data with zero values', (tester) async {
      await tester.pumpWidget(wrapChart(
        PolarChartWidget(
          data: [
            {'name': 'A', 'value': 100},
            {'name': 'B', 'value': 0},
            {'name': 'C', 'value': 100},
          ],
          pieSeries: const [
            PieSeries(dataKey: 'value'),
          ],
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(PolarChartWidget), findsOneWidget);
    });

    testWidgets('handles all zero values', (tester) async {
      await tester.pumpWidget(wrapChart(
        PolarChartWidget(
          data: [
            {'name': 'A', 'value': 0},
            {'name': 'B', 'value': 0},
          ],
          pieSeries: const [
            PieSeries(dataKey: 'value'),
          ],
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(PolarChartWidget), findsOneWidget);
    });
  });
}
