import 'package:flutter/material.dart';
import 'package:recharts_flutter/recharts_flutter.dart';
import '../../data/time_data.dart';

class SynchronizedLineChart extends StatelessWidget {
  const SynchronizedLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CartesianChartWidget(
            syncId: 'syncGroup1',
            data: monthlyData1,
            xAxes: const [XAxis(dataKey: 'month')],
            yAxes: const [YAxis()],
            grid: const CartesianGrid(
              horizontal: true,
              vertical: true,
              strokeDasharray: [3, 3],
            ),
            lineSeries: const [
              LineSeries(
                dataKey: 'revenue',
                name: 'Revenue',
                stroke: Color(0xFF8884D8),
                strokeWidth: 2,
                curveType: CurveType.monotone,
              ),
            ],
            tooltip: const ChartTooltip(),
          ),
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Revenue',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: CartesianChartWidget(
            syncId: 'syncGroup1',
            data: monthlyData2,
            xAxes: const [XAxis(dataKey: 'month')],
            yAxes: const [YAxis()],
            grid: const CartesianGrid(
              horizontal: true,
              vertical: true,
              strokeDasharray: [3, 3],
            ),
            lineSeries: const [
              LineSeries(
                dataKey: 'sessions',
                name: 'Sessions',
                stroke: Color(0xFF82CA9D),
                strokeWidth: 2,
                curveType: CurveType.monotone,
              ),
            ],
            tooltip: const ChartTooltip(),
          ),
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Sessions',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  static const String sourceCode = '''
// First chart
CartesianChartWidget(
  syncId: 'syncGroup1',  // Same syncId syncs tooltips
  data: revenueData,
  lineSeries: const [
    LineSeries(dataKey: 'revenue', stroke: Color(0xFF8884D8)),
  ],
  tooltip: const ChartTooltip(),
)

// Second chart
CartesianChartWidget(
  syncId: 'syncGroup1',  // Same syncId
  data: sessionsData,
  lineSeries: const [
    LineSeries(dataKey: 'sessions', stroke: Color(0xFF82CA9D)),
  ],
  tooltip: const ChartTooltip(),
)''';
}
