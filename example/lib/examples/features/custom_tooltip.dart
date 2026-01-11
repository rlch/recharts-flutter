import 'package:flutter/material.dart';
import 'package:recharts_flutter/recharts_flutter.dart';
import '../../data/page_data.dart';

class CustomTooltipExample extends StatelessWidget {
  const CustomTooltipExample({super.key});

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
      tooltip: const ChartTooltip(
        cursor: CursorConfig(
          color: Color(0xFFFFD700),
          strokeWidth: 2,
        ),
      ),
    );
  }

  static const String sourceCode = '''
CartesianChartWidget(
  data: pageData,
  xAxes: const [XAxis(dataKey: 'name')],
  yAxes: const [YAxis()],
  lineSeries: const [
    LineSeries(dataKey: 'pv', stroke: Color(0xFF8884D8)),
    LineSeries(dataKey: 'uv', stroke: Color(0xFF82CA9D)),
  ],
  tooltip: const ChartTooltip(
    // Custom cursor styling
    cursor: CursorConfig(
      color: Color(0xFFFFD700),  // Gold cursor
      strokeWidth: 2,
    ),
    // Custom content builder
    // contentBuilder: (context, payload) => CustomTooltipContent(payload),
  ),
)''';
}
