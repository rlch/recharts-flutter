import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recharts_flutter/recharts_flutter.dart';

final funnelData = [
  {'name': 'Sent', 'value': 4500},
  {'name': 'Viewed', 'value': 3000},
  {'name': 'Clicked', 'value': 2000},
  {'name': 'Applied', 'value': 1200},
  {'name': 'Interviewed', 'value': 500},
  {'name': 'Hired', 'value': 100},
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

  group('SimpleFunnelChart', () {
    testWidgets('renders basic funnel chart', (tester) async {
      await tester.pumpWidget(wrapChart(
        FunnelChart(
          data: funnelData,
          series: const FunnelSeries(
            dataKey: 'value',
            nameKey: 'name',
          ),
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(FunnelChart), findsOneWidget);
    });

    testWidgets('renders with custom colors', (tester) async {
      await tester.pumpWidget(wrapChart(
        FunnelChart(
          data: funnelData,
          series: const FunnelSeries(
            dataKey: 'value',
            nameKey: 'name',
            colors: [
              Color(0xFF8884D8),
              Color(0xFF83A6ED),
              Color(0xFF8DD1E1),
              Color(0xFF82CA9D),
              Color(0xFFA4DE6C),
              Color(0xFFD0ED57),
            ],
          ),
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(FunnelChart), findsOneWidget);
    });

    testWidgets('renders with labels', (tester) async {
      await tester.pumpWidget(wrapChart(
        FunnelChart(
          data: funnelData,
          series: const FunnelSeries(
            dataKey: 'value',
            nameKey: 'name',
            label: true,
          ),
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(FunnelChart), findsOneWidget);
    });
  });

  group('FunnelChart edge cases', () {
    testWidgets('handles empty data', (tester) async {
      await tester.pumpWidget(wrapChart(
        const FunnelChart(
          data: [],
          series: FunnelSeries(dataKey: 'value'),
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(FunnelChart), findsOneWidget);
    });

    testWidgets('handles single step funnel', (tester) async {
      await tester.pumpWidget(wrapChart(
        FunnelChart(
          data: [funnelData.first],
          series: const FunnelSeries(dataKey: 'value'),
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(FunnelChart), findsOneWidget);
    });

    testWidgets('handles reversed funnel (pyramid)', (tester) async {
      await tester.pumpWidget(wrapChart(
        FunnelChart(
          data: funnelData,
          series: const FunnelSeries(
            dataKey: 'value',
            reversed: true,
          ),
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(FunnelChart), findsOneWidget);
    });

    testWidgets('handles equal values', (tester) async {
      final equalData = [
        {'name': 'A', 'value': 100},
        {'name': 'B', 'value': 100},
        {'name': 'C', 'value': 100},
      ];

      await tester.pumpWidget(wrapChart(
        FunnelChart(
          data: equalData,
          series: const FunnelSeries(dataKey: 'value'),
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(FunnelChart), findsOneWidget);
    });

    testWidgets('handles zero values', (tester) async {
      final dataWithZero = [
        {'name': 'A', 'value': 100},
        {'name': 'B', 'value': 0},
        {'name': 'C', 'value': 50},
      ];

      await tester.pumpWidget(wrapChart(
        FunnelChart(
          data: dataWithZero,
          series: const FunnelSeries(dataKey: 'value'),
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(FunnelChart), findsOneWidget);
    });

    testWidgets('renders with animation disabled', (tester) async {
      await tester.pumpWidget(wrapChart(
        FunnelChart(
          data: funnelData,
          series: const FunnelSeries(dataKey: 'value'),
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(FunnelChart), findsOneWidget);
    });

    testWidgets('renders with rectangle shape', (tester) async {
      await tester.pumpWidget(wrapChart(
        FunnelChart(
          data: funnelData,
          series: const FunnelSeries(
            dataKey: 'value',
            shape: FunnelShape.rectangle,
          ),
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(FunnelChart), findsOneWidget);
    });

    testWidgets('renders with custom gap', (tester) async {
      await tester.pumpWidget(wrapChart(
        FunnelChart(
          data: funnelData,
          series: const FunnelSeries(
            dataKey: 'value',
            gap: 8,
          ),
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(FunnelChart), findsOneWidget);
    });
  });
}
