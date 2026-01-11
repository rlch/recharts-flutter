import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:recharts_flutter/src/sunburst/sunburst_chart.dart';
import 'package:recharts_flutter/src/sunburst/sunburst_node.dart';

void main() {
  final testData = SunburstNode(
    name: 'Total',
    children: [
      SunburstNode(
        name: 'North America',
        children: [
          SunburstNode(name: 'USA', value: 100),
          SunburstNode(name: 'Canada', value: 30),
          SunburstNode(name: 'Mexico', value: 25),
        ],
      ),
      SunburstNode(
        name: 'Europe',
        children: [
          SunburstNode(name: 'UK', value: 45),
          SunburstNode(name: 'Germany', value: 55),
          SunburstNode(name: 'France', value: 40),
        ],
      ),
      SunburstNode(
        name: 'Asia',
        children: [
          SunburstNode(name: 'Japan', value: 60),
          SunburstNode(name: 'China', value: 80),
          SunburstNode(name: 'India', value: 50),
        ],
      ),
    ],
  );

  Widget wrapWidget(Widget child) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: child),
      ),
    );
  }

  group('SunburstChart Golden Tests', () {
    testWidgets('sunburst chart golden', (tester) async {
      await tester.pumpWidget(wrapWidget(
        RepaintBoundary(
          child: SunburstChart(
            width: 400,
            height: 400,
            data: testData,
            isAnimationActive: false,
          ),
        ),
      ));

      await tester.pump();

      await expectLater(
        find.byType(SunburstChart),
        matchesGoldenFile('goldens/sunburst_chart.png'),
      );
    });

    testWidgets('sunburst chart with inner radius golden', (tester) async {
      await tester.pumpWidget(wrapWidget(
        RepaintBoundary(
          child: SunburstChart(
            width: 400,
            height: 400,
            data: testData,
            innerRadiusPercent: 0.3,
            isAnimationActive: false,
          ),
        ),
      ));

      await tester.pump();

      await expectLater(
        find.byType(SunburstChart),
        matchesGoldenFile('goldens/sunburst_chart_donut.png'),
      );
    });
  });
}
