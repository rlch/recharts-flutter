import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recharts_flutter/recharts_flutter.dart';

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

  group('SimpleSankeyChart', () {
    testWidgets('renders basic sankey chart', (tester) async {
      final data = SankeyData(
        nodes: [
          const SankeyNode(id: '0', name: 'Visit'),
          const SankeyNode(id: '1', name: 'Direct-Favourite'),
          const SankeyNode(id: '2', name: 'Page-Click'),
          const SankeyNode(id: '3', name: 'Detail-Favourite'),
          const SankeyNode(id: '4', name: 'Lost'),
        ],
        links: [
          const SankeyLink(source: '0', target: '1', value: 3728.3),
          const SankeyLink(source: '0', target: '2', value: 354170),
          const SankeyLink(source: '2', target: '3', value: 291741),
          const SankeyLink(source: '2', target: '4', value: 62429),
        ],
      );

      await tester.pumpWidget(wrapChart(
        SankeyChart(data: data, isAnimationActive: false),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(SankeyChart), findsOneWidget);
    });

    testWidgets('renders with custom colors', (tester) async {
      final data = SankeyData(
        nodes: [
          const SankeyNode(id: '0', name: 'A', color: Color(0xFF8884D8)),
          const SankeyNode(id: '1', name: 'B', color: Color(0xFF82CA9D)),
          const SankeyNode(id: '2', name: 'C', color: Color(0xFFFFC658)),
        ],
        links: [
          const SankeyLink(source: '0', target: '1', value: 100),
          const SankeyLink(source: '0', target: '2', value: 200),
        ],
      );

      await tester.pumpWidget(wrapChart(
        SankeyChart(data: data, isAnimationActive: false),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(SankeyChart), findsOneWidget);
    });
  });

  group('SankeyChart complex flows', () {
    testWidgets('renders multi-level flow', (tester) async {
      final data = SankeyData(
        nodes: [
          const SankeyNode(id: '0', name: 'Income'),
          const SankeyNode(id: '1', name: 'Budget'),
          const SankeyNode(id: '2', name: 'Investment'),
          const SankeyNode(id: '3', name: 'Real Estate'),
          const SankeyNode(id: '4', name: 'Crypto'),
          const SankeyNode(id: '5', name: 'Stocks'),
        ],
        links: [
          const SankeyLink(source: '0', target: '1', value: 8500),
          const SankeyLink(source: '1', target: '2', value: 2300),
          const SankeyLink(source: '1', target: '3', value: 400),
          const SankeyLink(source: '1', target: '4', value: 1250),
          const SankeyLink(source: '2', target: '5', value: 1800),
        ],
      );

      await tester.pumpWidget(wrapChart(
        SankeyChart(data: data, isAnimationActive: false),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(SankeyChart), findsOneWidget);
    });

    testWidgets('renders with multiple source nodes', (tester) async {
      final data = SankeyData(
        nodes: [
          const SankeyNode(id: '0', name: 'Source A'),
          const SankeyNode(id: '1', name: 'Source B'),
          const SankeyNode(id: '2', name: 'Target'),
        ],
        links: [
          const SankeyLink(source: '0', target: '2', value: 100),
          const SankeyLink(source: '1', target: '2', value: 200),
        ],
      );

      await tester.pumpWidget(wrapChart(
        SankeyChart(data: data, isAnimationActive: false),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(SankeyChart), findsOneWidget);
    });

    testWidgets('renders with multiple target nodes', (tester) async {
      final data = SankeyData(
        nodes: [
          const SankeyNode(id: '0', name: 'Source'),
          const SankeyNode(id: '1', name: 'Target A'),
          const SankeyNode(id: '2', name: 'Target B'),
          const SankeyNode(id: '3', name: 'Target C'),
        ],
        links: [
          const SankeyLink(source: '0', target: '1', value: 100),
          const SankeyLink(source: '0', target: '2', value: 200),
          const SankeyLink(source: '0', target: '3', value: 150),
        ],
      );

      await tester.pumpWidget(wrapChart(
        SankeyChart(data: data, isAnimationActive: false),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(SankeyChart), findsOneWidget);
    });
  });

  group('SankeyChart edge cases', () {
    testWidgets('handles empty data', (tester) async {
      final data = SankeyData(nodes: [], links: []);

      await tester.pumpWidget(wrapChart(
        SankeyChart(data: data, isAnimationActive: false),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(SankeyChart), findsOneWidget);
    });

    testWidgets('handles single node', (tester) async {
      final data = SankeyData(
        nodes: [const SankeyNode(id: '0', name: 'Only')],
        links: [],
      );

      await tester.pumpWidget(wrapChart(
        SankeyChart(data: data, isAnimationActive: false),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(SankeyChart), findsOneWidget);
    });

    testWidgets('handles two connected nodes', (tester) async {
      final data = SankeyData(
        nodes: [
          const SankeyNode(id: '0', name: 'Source'),
          const SankeyNode(id: '1', name: 'Target'),
        ],
        links: [
          const SankeyLink(source: '0', target: '1', value: 100),
        ],
      );

      await tester.pumpWidget(wrapChart(
        SankeyChart(data: data, isAnimationActive: false),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(SankeyChart), findsOneWidget);
    });

    testWidgets('handles very small link values', (tester) async {
      final data = SankeyData(
        nodes: [
          const SankeyNode(id: '0', name: 'A'),
          const SankeyNode(id: '1', name: 'B'),
          const SankeyNode(id: '2', name: 'C'),
        ],
        links: [
          const SankeyLink(source: '0', target: '1', value: 1000),
          const SankeyLink(source: '0', target: '2', value: 1),
        ],
      );

      await tester.pumpWidget(wrapChart(
        SankeyChart(data: data, isAnimationActive: false),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(SankeyChart), findsOneWidget);
    });

    testWidgets('renders with custom node width and padding', (tester) async {
      final data = SankeyData(
        nodes: [
          const SankeyNode(id: '0', name: 'A'),
          const SankeyNode(id: '1', name: 'B'),
        ],
        links: [
          const SankeyLink(source: '0', target: '1', value: 100),
        ],
      );

      await tester.pumpWidget(wrapChart(
        SankeyChart(
          data: data,
          nodeWidth: 20,
          nodePadding: 10,
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(SankeyChart), findsOneWidget);
    });

    testWidgets('renders with labels disabled', (tester) async {
      final data = SankeyData(
        nodes: [
          const SankeyNode(id: '0', name: 'A'),
          const SankeyNode(id: '1', name: 'B'),
        ],
        links: [
          const SankeyLink(source: '0', target: '1', value: 100),
        ],
      );

      await tester.pumpWidget(wrapChart(
        SankeyChart(
          data: data,
          showLabels: false,
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(SankeyChart), findsOneWidget);
    });
  });
}
