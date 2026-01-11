import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:recharts_flutter/src/treemap/treemap_chart.dart';
import 'package:recharts_flutter/src/treemap/treemap_node.dart';

void main() {
  final testData = TreemapNode(
    name: 'Root',
    children: [
      TreemapNode(
        name: 'Frontend',
        children: [
          TreemapNode(name: 'React', value: 150),
          TreemapNode(name: 'Vue', value: 100),
          TreemapNode(name: 'Angular', value: 80),
        ],
      ),
      TreemapNode(
        name: 'Backend',
        children: [
          TreemapNode(name: 'Node.js', value: 120),
          TreemapNode(name: 'Python', value: 90),
          TreemapNode(name: 'Go', value: 60),
        ],
      ),
      TreemapNode(
        name: 'Mobile',
        children: [
          TreemapNode(name: 'React Native', value: 70),
          TreemapNode(name: 'Flutter', value: 110),
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

  group('TreemapChart Golden Tests', () {
    testWidgets('treemap chart golden', (tester) async {
      await tester.pumpWidget(wrapWidget(
        RepaintBoundary(
          child: TreemapChart(
            width: 400,
            height: 300,
            data: testData,
            isAnimationActive: false,
          ),
        ),
      ));

      await tester.pump();

      await expectLater(
        find.byType(TreemapChart),
        matchesGoldenFile('goldens/treemap_chart.png'),
      );
    });

    testWidgets('treemap chart with custom colors golden', (tester) async {
      await tester.pumpWidget(wrapWidget(
        RepaintBoundary(
          child: TreemapChart(
            width: 400,
            height: 300,
            data: testData,
            colors: const [
              Color(0xFFe74c3c),
              Color(0xFF3498db),
              Color(0xFF2ecc71),
              Color(0xFFf39c12),
              Color(0xFF9b59b6),
            ],
            isAnimationActive: false,
          ),
        ),
      ));

      await tester.pump();

      await expectLater(
        find.byType(TreemapChart),
        matchesGoldenFile('goldens/treemap_chart_colors.png'),
      );
    });
  });
}
