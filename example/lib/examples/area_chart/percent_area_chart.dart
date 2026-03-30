import 'package:flutter/material.dart';
import 'package:recharts_flutter/recharts_flutter.dart';
import '../../data/page_data.dart';

class PercentAreaChart extends StatelessWidget {
  const PercentAreaChart({super.key});

  @override
  Widget build(BuildContext context) {
    return CartesianChartWidget(
      data: pageData,
      stackOffset: StackOffsetType.expand,
      xAxes: const [XAxis(dataKey: 'name')],
      yAxes: const [
        YAxis(domain: [0, 1], tickCount: 4)
      ],
      grid: const CartesianGrid(
        horizontal: true,
        vertical: true,
        strokeDasharray: [3, 3],
      ),
      areaSeries: const [
        AreaSeries(
          dataKey: 'uv',
          name: 'UV',
          stackId: '1',
          stroke: Color(0xFF8884D8),
          fill: Color(0xFF8884D8),
          curveType: CurveType.monotone,
        ),
        AreaSeries(
          dataKey: 'pv',
          name: 'PV',
          stackId: '1',
          stroke: Color(0xFF82CA9D),
          fill: Color(0xFF82CA9D),
          curveType: CurveType.monotone,
        ),
        AreaSeries(
          dataKey: 'amt',
          name: 'AMT',
          stackId: '1',
          stroke: Color(0xFFFFC658),
          fill: Color(0xFFFFC658),
          curveType: CurveType.monotone,
        ),
      ],
      tooltip: const ChartTooltip(),
    );
  }

  static const String sourceCode = '''
CartesianChartWidget(
  data: pageData,
  stackOffset: StackOffsetType.expand,
  xAxes: const [XAxis(dataKey: 'name')],
  yAxes: const [YAxis(domain: [0, 1], tickCount: 4)],
  grid: const CartesianGrid(strokeDasharray: [3, 3]),
  areaSeries: const [
    AreaSeries(
      dataKey: 'uv',
      stackId: '1',
      stroke: Color(0xFF8884D8),
      fill: Color(0xFF8884D8),
    ),
    AreaSeries(
      dataKey: 'pv',
      stackId: '1',
      stroke: Color(0xFF82CA9D),
      fill: Color(0xFF82CA9D),
    ),
    AreaSeries(
      dataKey: 'amt',
      stackId: '1',
      stroke: Color(0xFFFFC658),
      fill: Color(0xFFFFC658),
    ),
  ],
  tooltip: const ChartTooltip(),
)''';
}
