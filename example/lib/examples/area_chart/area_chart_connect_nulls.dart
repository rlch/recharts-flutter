import 'package:flutter/material.dart';
import 'package:recharts_flutter/recharts_flutter.dart';
import '../../data/page_data.dart';

class AreaChartConnectNulls extends StatelessWidget {
  const AreaChartConnectNulls({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CartesianChartWidget(
            data: dataWithNulls,
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
                name: 'Without connectNulls',
                stroke: Color(0xFF8884D8),
                fill: Color(0xFF8884D8),
                curveType: CurveType.monotone,
                connectNulls: false,
              ),
            ],
            tooltip: const ChartTooltip(),
          ),
        ),
        const SizedBox(height: 16),
        const Text('connectNulls: false'),
        const SizedBox(height: 24),
        Expanded(
          child: CartesianChartWidget(
            data: dataWithNulls,
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
                name: 'With connectNulls',
                stroke: Color(0xFF8884D8),
                fill: Color(0xFF8884D8),
                curveType: CurveType.monotone,
                connectNulls: true,
              ),
            ],
            tooltip: const ChartTooltip(),
          ),
        ),
        const SizedBox(height: 16),
        const Text('connectNulls: true'),
      ],
    );
  }

  static const String sourceCode = '''
// Without connectNulls
AreaSeries(
  dataKey: 'uv',
  stroke: Color(0xFF8884D8),
  fill: Color(0xFF8884D8),
  connectNulls: false,
)

// With connectNulls
AreaSeries(
  dataKey: 'uv',
  stroke: Color(0xFF8884D8),
  fill: Color(0xFF8884D8),
  connectNulls: true,
)''';
}
