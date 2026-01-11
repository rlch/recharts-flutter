import 'package:flutter/material.dart';
import 'package:recharts_flutter/recharts_flutter.dart';
import '../../data/coordinate_data.dart';

class BubbleChart extends StatelessWidget {
  const BubbleChart({super.key});

  @override
  Widget build(BuildContext context) {
    return CartesianChartWidget(
      data: coordinateWithValueData,
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
// Bubble chart data with z-axis for size
final bubbleData = [
  {'x': 10, 'y': 50, 'z': 100},
  {'x': 150, 'y': 150, 'z': 200},
  {'x': 290, 'y': 70, 'z': 150},
  // ...
];

CartesianChartWidget(
  data: bubbleData,
  xAxes: const [XAxis(dataKey: 'x')],
  yAxes: const [YAxis(dataKey: 'y')],
  // ScatterSeries with z-axis for bubble sizes
  // scatterSeries: [
  //   ScatterSeries(
  //     xDataKey: 'x',
  //     yDataKey: 'y',
  //     zDataKey: 'z',  // Size axis
  //     zAxis: ZAxis(dataKey: 'z', minSize: 10, maxSize: 50),
  //     fill: Color(0xFF8884D8),
  //   ),
  // ],
  tooltip: const ChartTooltip(),
)''';
}
