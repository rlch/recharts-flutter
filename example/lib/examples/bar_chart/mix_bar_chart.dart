import 'package:flutter/material.dart';
import 'package:recharts_flutter/recharts_flutter.dart';
import '../../data/page_data.dart';

class MixBarChart extends StatelessWidget {
  const MixBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return CartesianChartWidget(
      data: pageData,
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
          stackId: 'a',
          fill: Color(0xFF8884D8),
        ),
        BarSeries(
          dataKey: 'amt',
          name: 'Amount',
          stackId: 'a',
          fill: Color(0xFF82CA9D),
        ),
        BarSeries(
          dataKey: 'uv',
          name: 'Unique Visitors',
          fill: Color(0xFFFFC658),
        ),
      ],
      tooltip: const ChartTooltip(),
    );
  }

  static const String sourceCode = '''
CartesianChartWidget(
  data: pageData,
  xAxes: const [XAxis(dataKey: 'name')],
  yAxes: const [YAxis()],
  barSeries: const [
    // Stacked bars
    BarSeries(
      dataKey: 'pv',
      stackId: 'a',
      fill: Color(0xFF8884D8),
    ),
    BarSeries(
      dataKey: 'amt',
      stackId: 'a',
      fill: Color(0xFF82CA9D),
    ),
    // Separate bar (no stackId)
    BarSeries(
      dataKey: 'uv',
      fill: Color(0xFFFFC658),
    ),
  ],
  tooltip: const ChartTooltip(),
)''';
}
