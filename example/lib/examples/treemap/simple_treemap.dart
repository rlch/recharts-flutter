import 'package:flutter/material.dart';
import 'package:recharts_flutter/recharts_flutter.dart';

class SimpleTreemap extends StatelessWidget {
  const SimpleTreemap({super.key});

  @override
  Widget build(BuildContext context) {
    const data = TreemapNode(
      name: 'Axis',
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
        TreemapNode(
          name: 'Layouts',
          children: [
            TreemapNode(name: 'AxisLayout', value: 6725, color: Color(0xFFD0ED57)),
            TreemapNode(name: 'TreeMapLayout', value: 9191, color: Color(0xFFFFC658)),
            TreemapNode(name: 'PieLayout', value: 7214, color: Color(0xFFFF8042)),
          ],
        ),
      ],
    );

    return const TreemapChart(data: data);
  }

  static const String sourceCode = '''
const treemapData = TreemapNode(
  name: 'Axis',
  children: [
    TreemapNode(name: 'Event', value: 8023, color: Color(0xFF8884D8)),
    TreemapNode(
      name: 'Displays',
      children: [
        TreemapNode(name: 'RectSprite', value: 3623),
        TreemapNode(name: 'TextSprite', value: 10066),
      ],
    ),
    TreemapNode(
      name: 'Legend',
      children: [
        TreemapNode(name: 'LegendItem', value: 4054),
        TreemapNode(name: 'LegendRange', value: 10530),
      ],
    ),
    // ...
  ],
);

TreemapChart(data: treemapData)''';
}
