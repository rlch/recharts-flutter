import 'package:flutter/material.dart';
import 'package:recharts_flutter/recharts_flutter.dart';
import '../../data/page_data.dart';

class SimplePieChart extends StatelessWidget {
  const SimplePieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return PolarChartWidget(
      data: pieData,
      pieSeries: const [
        PieSeries(
          dataKey: 'value',
          nameKey: 'name',
        ),
      ],
      tooltip: const ChartTooltip(),
    );
  }

  static const String sourceCode = '''
final pieData = [
  {'name': 'Group A', 'value': 400},
  {'name': 'Group B', 'value': 300},
  {'name': 'Group C', 'value': 300},
  {'name': 'Group D', 'value': 200},
];

PolarChartWidget(
  data: pieData,
  pieSeries: const [
    PieSeries(
      dataKey: 'value',
      nameKey: 'name',
    ),
  ],
  tooltip: const ChartTooltip(),
)''';
}
