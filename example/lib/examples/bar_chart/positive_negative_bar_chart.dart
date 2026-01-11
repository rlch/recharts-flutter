import 'package:flutter/material.dart';
import 'package:recharts_flutter/recharts_flutter.dart';
import '../../data/page_data.dart';

class PositiveNegativeBarChart extends StatelessWidget {
  const PositiveNegativeBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return CartesianChartWidget(
      data: pageDataWithNegativeNumbers,
      xAxes: const [XAxis(dataKey: 'name')],
      yAxes: const [YAxis()],
      grid: const CartesianGrid(
        horizontal: true,
        vertical: false,
        strokeDasharray: [3, 3],
      ),
      barSeries: const [
        BarSeries(
          dataKey: 'pv',
          name: 'Page Views',
          fill: Color(0xFF8884D8),
        ),
        BarSeries(
          dataKey: 'uv',
          name: 'Unique Visitors',
          fill: Color(0xFF82CA9D),
        ),
      ],
      tooltip: const ChartTooltip(),
    );
  }

  static const String sourceCode = '''
// Data with negative values
final data = [
  {'name': 'Page A', 'uv': 4000, 'pv': 2400},
  {'name': 'Page B', 'uv': -3000, 'pv': 1398},
  {'name': 'Page C', 'uv': -2000, 'pv': -9800},
  {'name': 'Page D', 'uv': 2780, 'pv': 3908},
  // ...
];

CartesianChartWidget(
  data: data,
  xAxes: const [XAxis(dataKey: 'name')],
  yAxes: const [YAxis()],
  barSeries: const [
    BarSeries(
      dataKey: 'pv',
      fill: Color(0xFF8884D8),
    ),
    BarSeries(
      dataKey: 'uv',
      fill: Color(0xFF82CA9D),
    ),
  ],
  tooltip: const ChartTooltip(),
)''';
}
