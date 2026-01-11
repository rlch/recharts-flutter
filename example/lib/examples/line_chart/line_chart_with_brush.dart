import 'package:flutter/material.dart';
import 'package:recharts_flutter/recharts_flutter.dart';
import '../../data/page_data.dart';

class LineChartWithBrush extends StatelessWidget {
  const LineChartWithBrush({super.key});

  @override
  Widget build(BuildContext context) {
    return CartesianChartWidget(
      data: numberData,
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
  data: numberData,
  xAxes: const [XAxis(dataKey: 'name')],
  yAxes: const [YAxis()],
  grid: const CartesianGrid(strokeDasharray: [3, 3]),
  lineSeries: const [
    LineSeries(dataKey: 'pv', stroke: Color(0xFF8884D8)),
    LineSeries(dataKey: 'uv', stroke: Color(0xFF82CA9D)),
  ],
  // Brush would be added like:
  // brush: Brush(
  //   dataKey: 'name',
  //   startIndex: 2,
  //   height: 30,
  //   stroke: Color(0xFF8884D8),
  // ),
  tooltip: const ChartTooltip(),
)''';
}
