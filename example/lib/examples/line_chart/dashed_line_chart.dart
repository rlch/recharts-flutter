import 'package:flutter/material.dart';
import 'package:recharts_flutter/recharts_flutter.dart';
import '../../data/page_data.dart';

class DashedLineChart extends StatelessWidget {
  const DashedLineChart({super.key});

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
  grid: const CartesianGrid(
    horizontal: true,
    vertical: true,
    strokeDasharray: [3, 3],
  ),
  lineSeries: [
    LineSeries(
      dataKey: 'pv',
      name: 'Page Views',
      stroke: Color(0xFF8884D8),
      strokeWidth: 2,
      curveType: CurveType.monotone,
      strokeDasharray: [5, 5],  // Dashed line
    ),
    LineSeries(
      dataKey: 'uv',
      name: 'Unique Visitors',
      stroke: Color(0xFF82CA9D),
      strokeWidth: 2,
      curveType: CurveType.monotone,
      strokeDasharray: [3, 4, 5, 2],  // Custom dash pattern
    ),
  ],
  tooltip: const ChartTooltip(),
)''';
}
