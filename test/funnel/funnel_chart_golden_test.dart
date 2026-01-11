import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:recharts_flutter/src/funnel/funnel_chart.dart';
import 'package:recharts_flutter/src/funnel/funnel_series.dart';

void main() {
  final testData = [
    {'name': 'Visited', 'value': 5000},
    {'name': 'Viewed Product', 'value': 2500},
    {'name': 'Added to Cart', 'value': 1200},
    {'name': 'Checkout', 'value': 600},
    {'name': 'Purchased', 'value': 300},
  ];

  Widget wrapWidget(Widget child) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: child),
      ),
    );
  }

  group('FunnelChart Golden Tests', () {
    testWidgets('funnel chart trapezoid golden', (tester) async {
      await tester.pumpWidget(wrapWidget(
        RepaintBoundary(
          child: FunnelChart(
            width: 400,
            height: 300,
            data: testData,
            series: const FunnelSeries(
              dataKey: 'value',
              nameKey: 'name',
              shape: FunnelShape.trapezoid,
            ),
            isAnimationActive: false,
          ),
        ),
      ));

      await tester.pump();

      await expectLater(
        find.byType(FunnelChart),
        matchesGoldenFile('goldens/funnel_chart_trapezoid.png'),
      );
    });

    testWidgets('funnel chart rectangle golden', (tester) async {
      await tester.pumpWidget(wrapWidget(
        RepaintBoundary(
          child: FunnelChart(
            width: 400,
            height: 300,
            data: testData,
            series: const FunnelSeries(
              dataKey: 'value',
              nameKey: 'name',
              shape: FunnelShape.rectangle,
            ),
            isAnimationActive: false,
          ),
        ),
      ));

      await tester.pump();

      await expectLater(
        find.byType(FunnelChart),
        matchesGoldenFile('goldens/funnel_chart_rectangle.png'),
      );
    });

    testWidgets('funnel chart reversed golden', (tester) async {
      await tester.pumpWidget(wrapWidget(
        RepaintBoundary(
          child: FunnelChart(
            width: 400,
            height: 300,
            data: testData,
            series: const FunnelSeries(
              dataKey: 'value',
              nameKey: 'name',
              reversed: true,
            ),
            isAnimationActive: false,
          ),
        ),
      ));

      await tester.pump();

      await expectLater(
        find.byType(FunnelChart),
        matchesGoldenFile('goldens/funnel_chart_reversed.png'),
      );
    });
  });
}
