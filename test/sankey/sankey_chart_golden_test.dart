import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:recharts_flutter/src/sankey/sankey_chart.dart';
import 'package:recharts_flutter/src/sankey/sankey_data.dart';

void main() {
  const testData = SankeyData(
    nodes: [
      SankeyNode(id: 'visit', name: 'Visit'),
      SankeyNode(id: 'direct', name: 'Direct Link'),
      SankeyNode(id: 'search', name: 'Search Engine'),
      SankeyNode(id: 'referral', name: 'Referral'),
      SankeyNode(id: 'product', name: 'Product Page'),
      SankeyNode(id: 'cart', name: 'Cart'),
      SankeyNode(id: 'checkout', name: 'Checkout'),
      SankeyNode(id: 'purchased', name: 'Purchased'),
    ],
    links: [
      SankeyLink(source: 'visit', target: 'direct', value: 200),
      SankeyLink(source: 'visit', target: 'search', value: 400),
      SankeyLink(source: 'visit', target: 'referral', value: 100),
      SankeyLink(source: 'direct', target: 'product', value: 180),
      SankeyLink(source: 'search', target: 'product', value: 350),
      SankeyLink(source: 'referral', target: 'product', value: 80),
      SankeyLink(source: 'product', target: 'cart', value: 400),
      SankeyLink(source: 'cart', target: 'checkout', value: 300),
      SankeyLink(source: 'checkout', target: 'purchased', value: 250),
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

  group('SankeyChart Golden Tests', () {
    testWidgets('sankey chart golden', (tester) async {
      await tester.pumpWidget(wrapWidget(
        RepaintBoundary(
          child: SankeyChart(
            width: 600,
            height: 400,
            data: testData,
            isAnimationActive: false,
          ),
        ),
      ));

      await tester.pump();

      await expectLater(
        find.byType(SankeyChart),
        matchesGoldenFile('goldens/sankey_chart.png'),
      );
    });

    testWidgets('sankey chart simple golden', (tester) async {
      const simpleData = SankeyData(
        nodes: [
          SankeyNode(id: 'a', name: 'A'),
          SankeyNode(id: 'b', name: 'B'),
          SankeyNode(id: 'c', name: 'C'),
          SankeyNode(id: 'd', name: 'D'),
        ],
        links: [
          SankeyLink(source: 'a', target: 'c', value: 60),
          SankeyLink(source: 'a', target: 'd', value: 40),
          SankeyLink(source: 'b', target: 'c', value: 30),
          SankeyLink(source: 'b', target: 'd', value: 70),
        ],
      );

      await tester.pumpWidget(wrapWidget(
        RepaintBoundary(
          child: SankeyChart(
            width: 400,
            height: 300,
            data: simpleData,
            isAnimationActive: false,
          ),
        ),
      ));

      await tester.pump();

      await expectLater(
        find.byType(SankeyChart),
        matchesGoldenFile('goldens/sankey_chart_simple.png'),
      );
    });
  });
}
