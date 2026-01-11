import 'package:flutter/material.dart';
import 'package:recharts_flutter/recharts_flutter.dart';
import '../../data/page_data.dart';

class VerticalLineChart extends StatelessWidget {
  const VerticalLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return CartesianChartWidget(
      data: pageData,
      xAxes: const [XAxis()],
      yAxes: const [YAxis(dataKey: 'name')],
      grid: const CartesianGrid(
        horizontal: true,
        vertical: true,
        strokeDasharray: [3, 3],
      ),
      lineSeries: const [
        LineSeries(
          dataKey: 'pv',
          name: 'Page Views',
          stroke: Color(0xFF8884D8),
          strokeWidth: 2,
        ),
        LineSeries(
          dataKey: 'uv',
          name: 'Unique Visitors',
          stroke: Color(0xFF82CA9D),
          strokeWidth: 2,
        ),
      ],
      tooltip: const ChartTooltip(),
    );
  }

  static const String sourceCode = '''
CartesianChartWidget(
  data: pageData,
  // For vertical layout, configure axes appropriately
  xAxes: const [XAxis()],
  yAxes: const [YAxis(dataKey: 'name')],
  grid: const CartesianGrid(
    horizontal: true,
    vertical: true,
    strokeDasharray: [3, 3],
  ),
  lineSeries: const [
    LineSeries(
      dataKey: 'pv',
      name: 'Page Views',
      stroke: Color(0xFF8884D8),
    ),
    LineSeries(
      dataKey: 'uv',
      name: 'Unique Visitors',
      stroke: Color(0xFF82CA9D),
    ),
  ],
  tooltip: const ChartTooltip(),
)''';
}
