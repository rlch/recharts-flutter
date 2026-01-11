import 'package:flutter/material.dart';
import 'package:recharts_flutter/recharts_flutter.dart';
import '../../data/page_data.dart';

class SimpleRadialBarChart extends StatelessWidget {
  const SimpleRadialBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return PolarChartWidget(
      data: pageDataWithFillColor,
      radialBarSeries: const [
        RadialBarSeries(
          dataKey: 'pv',
          nameKey: 'name',
        ),
      ],
      tooltip: const ChartTooltip(),
    );
  }

  static const String sourceCode = '''
final radialData = [
  {'name': '18-24', 'uv': 31.47, 'pv': 2400, 'fill': '#8884d8'},
  {'name': '25-29', 'uv': 26.69, 'pv': 4567, 'fill': '#83a6ed'},
  {'name': '30-34', 'uv': 15.69, 'pv': 1398, 'fill': '#8dd1e1'},
  {'name': '35-39', 'uv': 8.22, 'pv': 9800, 'fill': '#82ca9d'},
  // ...
];

PolarChartWidget(
  data: radialData,
  radialBarSeries: const [
    RadialBarSeries(
      dataKey: 'pv',
      nameKey: 'name',
    ),
  ],
  tooltip: const ChartTooltip(),
)''';
}
