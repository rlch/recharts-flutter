import 'package:flutter/material.dart';
import 'package:recharts_flutter/recharts_flutter.dart';
import '../../data/coordinate_data.dart';

class SimpleScatterChart extends StatelessWidget {
  const SimpleScatterChart({super.key});

  @override
  Widget build(BuildContext context) {
    return CartesianChartWidget(
      data: scatterData01,
      xAxes: const [XAxis(dataKey: 'x')],
      yAxes: const [YAxis(dataKey: 'y')],
      grid: const CartesianGrid(
        horizontal: true,
        vertical: true,
        strokeDasharray: [3, 3],
      ),
      lineSeries: const [],
      areaSeries: const [],
      barSeries: const [],
      tooltip: const ChartTooltip(),
    );
  }

  static const String sourceCode = '''
// Scatter chart data
final scatterData = [
  {'x': 100, 'y': 200, 'z': 200},
  {'x': 120, 'y': 100, 'z': 260},
  {'x': 170, 'y': 300, 'z': 400},
  // ...
];

CartesianChartWidget(
  data: scatterData,
  xAxes: const [XAxis(dataKey: 'x')],
  yAxes: const [YAxis(dataKey: 'y')],
  grid: const CartesianGrid(strokeDasharray: [3, 3]),
  // ScatterSeries would be used like:
  // scatterSeries: [
  //   ScatterSeries(
  //     xDataKey: 'x',
  //     yDataKey: 'y',
  //     fill: Color(0xFF8884D8),
  //   ),
  // ],
  tooltip: const ChartTooltip(),
)''';
}
