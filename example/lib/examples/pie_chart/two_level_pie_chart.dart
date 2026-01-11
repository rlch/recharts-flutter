import 'package:flutter/material.dart';
import 'package:recharts_flutter/recharts_flutter.dart';
import '../../data/page_data.dart';

class TwoLevelPieChart extends StatelessWidget {
  const TwoLevelPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return PolarChartWidget(
      data: pieData,
      pieSeries: const [
        PieSeries(
          dataKey: 'value',
          nameKey: 'name',
          innerRadius: 0,
          outerRadius: 60,
        ),
      ],
      tooltip: const ChartTooltip(),
    );
  }

  static const String sourceCode = '''
// Inner pie (main categories)
final innerData = [
  {'name': 'Group A', 'value': 400},
  {'name': 'Group B', 'value': 300},
  {'name': 'Group C', 'value': 300},
  {'name': 'Group D', 'value': 200},
];

// Outer pie (subcategories)
final outerData = [
  {'name': 'A1', 'value': 100},
  {'name': 'A2', 'value': 300},
  // ...
];

PolarChartWidget(
  data: innerData,
  pieSeries: const [
    // Inner pie
    PieSeries(
      dataKey: 'value',
      innerRadius: 0,
      outerRadius: 60,
    ),
    // Outer pie would use different data
    // PieSeries(
    //   data: outerData,
    //   dataKey: 'value',
    //   innerRadius: 70,
    //   outerRadius: 100,
    // ),
  ],
  tooltip: const ChartTooltip(),
)''';
}
