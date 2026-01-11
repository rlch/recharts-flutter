import 'package:flutter/material.dart';
import 'package:recharts_flutter/recharts_flutter.dart';
import '../../data/page_data.dart';

class BarChartWithBrush extends StatelessWidget {
  const BarChartWithBrush({super.key});

  @override
  Widget build(BuildContext context) {
    return CartesianChartWidget(
      data: numberData,
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
CartesianChartWidget(
  data: numberData,  // Large dataset
  xAxes: const [XAxis(dataKey: 'name')],
  yAxes: const [YAxis()],
  barSeries: const [
    BarSeries(dataKey: 'pv', fill: Color(0xFF8884D8)),
    BarSeries(dataKey: 'uv', fill: Color(0xFF82CA9D)),
  ],
  // Brush component for range selection
  // brush: Brush(
  //   dataKey: 'name',
  //   startIndex: 0,
  //   endIndex: 10,
  //   height: 30,
  // ),
  tooltip: const ChartTooltip(),
)''';
}
