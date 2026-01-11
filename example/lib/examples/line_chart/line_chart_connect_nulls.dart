import 'package:flutter/material.dart';
import 'package:recharts_flutter/recharts_flutter.dart';
import '../../data/page_data.dart';

class LineChartConnectNulls extends StatelessWidget {
  const LineChartConnectNulls({super.key});

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
            lineSeries: const [
              LineSeries(
                dataKey: 'uv',
                name: 'Without connectNulls',
                stroke: Color(0xFF8884D8),
                strokeWidth: 2,
                curveType: CurveType.monotone,
                connectNulls: false,
              ),
            ],
            tooltip: const ChartTooltip(),
          ),
        ),
        const SizedBox(height: 16),
        const Text('connectNulls: false (gap at null values)'),
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
            lineSeries: const [
              LineSeries(
                dataKey: 'uv',
                name: 'With connectNulls',
                stroke: Color(0xFF8884D8),
                strokeWidth: 2,
                curveType: CurveType.monotone,
                connectNulls: true,
              ),
            ],
            tooltip: const ChartTooltip(),
          ),
        ),
        const SizedBox(height: 16),
        const Text('connectNulls: true (line connects through nulls)'),
      ],
    );
  }

  static const String sourceCode = '''
// Without connectNulls (default)
LineSeries(
  dataKey: 'uv',
  stroke: Color(0xFF8884D8),
  connectNulls: false,  // Line breaks at null values
)

// With connectNulls
LineSeries(
  dataKey: 'uv',
  stroke: Color(0xFF8884D8),
  connectNulls: true,  // Line connects through null values
)''';
}
