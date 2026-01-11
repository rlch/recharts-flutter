import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recharts_flutter/recharts_flutter.dart';

final subjectData = [
  {'subject': 'Math', 'A': 120, 'B': 110, 'fullMark': 150},
  {'subject': 'Chinese', 'A': 98, 'B': 130, 'fullMark': 150},
  {'subject': 'English', 'A': 86, 'B': 130, 'fullMark': 150},
  {'subject': 'Geography', 'A': 99, 'B': 100, 'fullMark': 150},
  {'subject': 'Physics', 'A': 85, 'B': 90, 'fullMark': 150},
  {'subject': 'History', 'A': 65, 'B': 85, 'fullMark': 150},
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

  group('SimpleRadarChart', () {
    testWidgets('renders radar chart with two series', (tester) async {
      await tester.pumpWidget(wrapChart(
        PolarChartWidget(
          data: subjectData,
          angleAxis: const PolarAngleAxis(dataKey: 'subject'),
          radiusAxis: const PolarRadiusAxis(tickCount: 5),
          grid: const PolarGrid(),
          radarSeries: const [
            RadarSeries(
              dataKey: 'A',
              name: 'Student A',
              stroke: Color(0xFF8884D8),
              fill: Color(0x408884D8),
            ),
            RadarSeries(
              dataKey: 'B',
              name: 'Student B',
              stroke: Color(0xFF82CA9D),
              fill: Color(0x4082CA9D),
            ),
          ],
          tooltip: const ChartTooltip(),
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(PolarChartWidget), findsOneWidget);
    });

    testWidgets('renders single radar series', (tester) async {
      await tester.pumpWidget(wrapChart(
        PolarChartWidget(
          data: subjectData,
          angleAxis: const PolarAngleAxis(dataKey: 'subject'),
          radiusAxis: const PolarRadiusAxis(),
          grid: const PolarGrid(),
          radarSeries: const [
            RadarSeries(
              dataKey: 'A',
              stroke: Color(0xFF8884D8),
              fill: Color(0x408884D8),
            ),
          ],
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(PolarChartWidget), findsOneWidget);
    });
  });

  group('SpecifiedDomainRadarChart', () {
    testWidgets('renders with custom domain', (tester) async {
      await tester.pumpWidget(wrapChart(
        PolarChartWidget(
          data: subjectData,
          angleAxis: const PolarAngleAxis(dataKey: 'subject'),
          radiusAxis: const PolarRadiusAxis(
            angle: 90,
            domain: [0, 150],
            tickCount: 6,
          ),
          grid: const PolarGrid(),
          radarSeries: const [
            RadarSeries(
              dataKey: 'A',
              stroke: Color(0xFF8884D8),
              fill: Color(0x408884D8),
            ),
          ],
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(PolarChartWidget), findsOneWidget);
    });
  });

  group('RadarChart grid types', () {
    testWidgets('renders with polygon grid', (tester) async {
      await tester.pumpWidget(wrapChart(
        PolarChartWidget(
          data: subjectData,
          angleAxis: const PolarAngleAxis(dataKey: 'subject'),
          radiusAxis: const PolarRadiusAxis(),
          grid: const PolarGrid(gridType: PolarGridType.polygon),
          radarSeries: const [
            RadarSeries(dataKey: 'A', stroke: Color(0xFF8884D8)),
          ],
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(PolarChartWidget), findsOneWidget);
    });

    testWidgets('renders with circle grid', (tester) async {
      await tester.pumpWidget(wrapChart(
        PolarChartWidget(
          data: subjectData,
          angleAxis: const PolarAngleAxis(dataKey: 'subject'),
          radiusAxis: const PolarRadiusAxis(),
          grid: const PolarGrid(gridType: PolarGridType.circle),
          radarSeries: const [
            RadarSeries(dataKey: 'A', stroke: Color(0xFF8884D8)),
          ],
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(PolarChartWidget), findsOneWidget);
    });
  });

  group('RadarChart edge cases', () {
    testWidgets('handles empty data', (tester) async {
      await tester.pumpWidget(wrapChart(
        PolarChartWidget(
          data: const [],
          angleAxis: const PolarAngleAxis(dataKey: 'subject'),
          radarSeries: const [
            RadarSeries(dataKey: 'A'),
          ],
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(PolarChartWidget), findsOneWidget);
    });

    testWidgets('handles 3-point radar (triangle)', (tester) async {
      await tester.pumpWidget(wrapChart(
        PolarChartWidget(
          data: [
            {'subject': 'A', 'value': 100},
            {'subject': 'B', 'value': 80},
            {'subject': 'C', 'value': 90},
          ],
          angleAxis: const PolarAngleAxis(dataKey: 'subject'),
          radiusAxis: const PolarRadiusAxis(),
          grid: const PolarGrid(gridType: PolarGridType.polygon),
          radarSeries: const [
            RadarSeries(dataKey: 'value', stroke: Color(0xFF8884D8)),
          ],
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(PolarChartWidget), findsOneWidget);
    });

    testWidgets('handles many points radar', (tester) async {
      final manyPoints = List.generate(
        12,
        (i) => {'subject': 'Cat $i', 'value': 50 + (i * 5)},
      );

      await tester.pumpWidget(wrapChart(
        PolarChartWidget(
          data: manyPoints,
          angleAxis: const PolarAngleAxis(dataKey: 'subject'),
          radiusAxis: const PolarRadiusAxis(),
          grid: const PolarGrid(),
          radarSeries: const [
            RadarSeries(dataKey: 'value', stroke: Color(0xFF8884D8)),
          ],
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(PolarChartWidget), findsOneWidget);
    });

    testWidgets('renders with fill opacity', (tester) async {
      await tester.pumpWidget(wrapChart(
        PolarChartWidget(
          data: subjectData,
          angleAxis: const PolarAngleAxis(dataKey: 'subject'),
          radarSeries: const [
            RadarSeries(
              dataKey: 'A',
              stroke: Color(0xFF8884D8),
              fill: Color(0xFF8884D8),
              fillOpacity: 0.6,
            ),
          ],
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(PolarChartWidget), findsOneWidget);
    });

    testWidgets('renders with dots', (tester) async {
      await tester.pumpWidget(wrapChart(
        PolarChartWidget(
          data: subjectData,
          angleAxis: const PolarAngleAxis(dataKey: 'subject'),
          radarSeries: const [
            RadarSeries(
              dataKey: 'A',
              stroke: Color(0xFF8884D8),
              dot: true,
            ),
          ],
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(PolarChartWidget), findsOneWidget);
    });
  });
}
