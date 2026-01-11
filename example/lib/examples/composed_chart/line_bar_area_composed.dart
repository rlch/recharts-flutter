import 'package:flutter/material.dart';
import 'package:recharts_flutter/recharts_flutter.dart';
import '../../data/page_data.dart';

class LineBarAreaComposed extends StatelessWidget {
  const LineBarAreaComposed({super.key});

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
          dataKey: 'amt',
          name: 'Amount',
          stroke: Color(0xFFFFC658),
          fill: Color(0x80FFC658),
          curveType: CurveType.monotone,
        ),
      ],
      barSeries: const [
        BarSeries(
          dataKey: 'pv',
          name: 'Page Views',
          fill: Color(0xFF8884D8),
        ),
      ],
      lineSeries: const [
        LineSeries(
          dataKey: 'uv',
          name: 'Unique Visitors',
          stroke: Color(0xFFFF7300),
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
  // Combine multiple series types
  areaSeries: const [
    AreaSeries(
      dataKey: 'amt',
      stroke: Color(0xFFFFC658),
      fill: Color(0x80FFC658),
    ),
  ],
  barSeries: const [
    BarSeries(
      dataKey: 'pv',
      fill: Color(0xFF8884D8),
    ),
  ],
  lineSeries: const [
    LineSeries(
      dataKey: 'uv',
      stroke: Color(0xFFFF7300),
    ),
  ],
  tooltip: const ChartTooltip(),
)''';
}
