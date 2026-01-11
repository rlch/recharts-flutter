import 'package:flutter/material.dart';
import 'package:recharts_flutter/recharts_flutter.dart';
import '../../data/page_data.dart';

class LineChartWithReferenceLines extends StatelessWidget {
  const LineChartWithReferenceLines({super.key});

  @override
  Widget build(BuildContext context) {
    return CartesianChartWidget(
      data: pageData,
      xAxes: const [XAxis(dataKey: 'name')],
      yAxes: const [YAxis()],
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
          curveType: CurveType.monotone,
        ),
        LineSeries(
          dataKey: 'uv',
          name: 'Unique Visitors',
          stroke: Color(0xFF82CA9D),
          strokeWidth: 2,
          curveType: CurveType.monotone,
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
  grid: const CartesianGrid(strokeDasharray: [3, 3]),
  lineSeries: const [
    LineSeries(dataKey: 'pv', stroke: Color(0xFF8884D8)),
    LineSeries(dataKey: 'uv', stroke: Color(0xFF82CA9D)),
  ],
  // Reference lines would be added like:
  // referenceLines: [
  //   ReferenceLine(y: 1000, stroke: Colors.red, label: 'Target'),
  //   ReferenceLine(x: 'Page C', stroke: Colors.blue),
  // ],
  tooltip: const ChartTooltip(),
)''';
}
