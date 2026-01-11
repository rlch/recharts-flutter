import 'package:flutter/material.dart';
import 'package:recharts_flutter/recharts_flutter.dart';
import '../../data/page_data.dart';

class SimpleAreaChart extends StatelessWidget {
  const SimpleAreaChart({super.key});

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
      areaSeries: const [
        AreaSeries(
          dataKey: 'uv',
          name: 'Unique Visitors',
          stroke: Color(0xFF8884D8),
          fill: Color(0xFF8884D8),
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
  areaSeries: const [
    AreaSeries(
      dataKey: 'uv',
      name: 'Unique Visitors',
      stroke: Color(0xFF8884D8),
      fill: Color(0xFF8884D8),
      curveType: CurveType.monotone,
    ),
  ],
  tooltip: const ChartTooltip(),
)''';
}
