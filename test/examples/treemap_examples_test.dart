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

  group('SimpleTreemap', () {
    testWidgets('renders basic treemap', (tester) async {
      const data = TreemapNode(
        name: 'Root',
        children: [
          TreemapNode(name: 'A', value: 100, color: Color(0xFF8884D8)),
          TreemapNode(name: 'B', value: 200, color: Color(0xFF82CA9D)),
          TreemapNode(name: 'C', value: 150, color: Color(0xFFFFC658)),
        ],
      );

      await tester.pumpWidget(wrapChart(
        const TreemapChart(data: data, isAnimationActive: false),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(TreemapChart), findsOneWidget);
    });

    testWidgets('renders nested treemap', (tester) async {
      const data = TreemapNode(
        name: 'Root',
        children: [
          TreemapNode(name: 'Event', value: 8023, color: Color(0xFF8884D8)),
          TreemapNode(
            name: 'Displays',
            children: [
              TreemapNode(name: 'RectSprite', value: 3623, color: Color(0xFF83A6ED)),
              TreemapNode(name: 'TextSprite', value: 10066, color: Color(0xFF8DD1E1)),
            ],
          ),
          TreemapNode(
            name: 'Legend',
            children: [
              TreemapNode(name: 'LegendItem', value: 4054, color: Color(0xFF82CA9D)),
              TreemapNode(name: 'LegendRange', value: 10530, color: Color(0xFFA4DE6C)),
            ],
          ),
        ],
      );

      await tester.pumpWidget(wrapChart(
        const TreemapChart(data: data, isAnimationActive: false),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(TreemapChart), findsOneWidget);
    });

    testWidgets('renders with labels', (tester) async {
      const data = TreemapNode(
        name: 'Root',
        children: [
          TreemapNode(name: 'A', value: 100),
          TreemapNode(name: 'B', value: 200),
        ],
      );

      await tester.pumpWidget(wrapChart(
        const TreemapChart(
          data: data,
          showLabels: true,
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(TreemapChart), findsOneWidget);
    });
  });

  group('Treemap edge cases', () {
    testWidgets('handles empty children', (tester) async {
      const data = TreemapNode(
        name: 'Root',
        children: [],
      );

      await tester.pumpWidget(wrapChart(
        const TreemapChart(data: data, isAnimationActive: false),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(TreemapChart), findsOneWidget);
    });

    testWidgets('handles single leaf node', (tester) async {
      const data = TreemapNode(
        name: 'Root',
        children: [
          TreemapNode(name: 'Only', value: 100),
        ],
      );

      await tester.pumpWidget(wrapChart(
        const TreemapChart(data: data, isAnimationActive: false),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(TreemapChart), findsOneWidget);
    });

    testWidgets('handles deeply nested hierarchy', (tester) async {
      const data = TreemapNode(
        name: 'Level 1',
        children: [
          TreemapNode(
            name: 'Level 2',
            children: [
              TreemapNode(
                name: 'Level 3',
                children: [
                  TreemapNode(name: 'Level 4', value: 100),
                ],
              ),
            ],
          ),
        ],
      );

      await tester.pumpWidget(wrapChart(
        const TreemapChart(data: data, isAnimationActive: false),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(TreemapChart), findsOneWidget);
    });

    testWidgets('handles mixed leaf and branch nodes', (tester) async {
      const data = TreemapNode(
        name: 'Root',
        children: [
          TreemapNode(name: 'Leaf', value: 100),
          TreemapNode(
            name: 'Branch',
            children: [
              TreemapNode(name: 'Child1', value: 50),
              TreemapNode(name: 'Child2', value: 50),
            ],
          ),
        ],
      );

      await tester.pumpWidget(wrapChart(
        const TreemapChart(data: data, isAnimationActive: false),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(TreemapChart), findsOneWidget);
    });

    testWidgets('handles zero values', (tester) async {
      const data = TreemapNode(
        name: 'Root',
        children: [
          TreemapNode(name: 'A', value: 100),
          TreemapNode(name: 'B', value: 0),
          TreemapNode(name: 'C', value: 100),
        ],
      );

      await tester.pumpWidget(wrapChart(
        const TreemapChart(data: data, isAnimationActive: false),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(TreemapChart), findsOneWidget);
    });

    testWidgets('renders with custom cell padding', (tester) async {
      const data = TreemapNode(
        name: 'Root',
        children: [
          TreemapNode(name: 'A', value: 100),
          TreemapNode(name: 'B', value: 100),
        ],
      );

      await tester.pumpWidget(wrapChart(
        const TreemapChart(
          data: data,
          cellPadding: 4,
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(TreemapChart), findsOneWidget);
    });

    testWidgets('renders with custom colors', (tester) async {
      const data = TreemapNode(
        name: 'Root',
        children: [
          TreemapNode(name: 'A', value: 100),
          TreemapNode(name: 'B', value: 100),
        ],
      );

      await tester.pumpWidget(wrapChart(
        const TreemapChart(
          data: data,
          colors: [Color(0xFFFF0000), Color(0xFF00FF00)],
          isAnimationActive: false,
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(TreemapChart), findsOneWidget);
    });
  });
}
