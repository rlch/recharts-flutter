import 'package:flutter/material.dart';
import 'package:recharts_flutter/recharts_flutter.dart';
import '../../data/page_data.dart';

class SynchronizedChartsExample extends StatelessWidget {
  const SynchronizedChartsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Hover on any chart to sync tooltips across all charts',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: CartesianChartWidget(
            syncId: 'mainSync',
            data: pageData,
            xAxes: const [XAxis(dataKey: 'name')],
            yAxes: const [YAxis()],
            grid: const CartesianGrid(
              horizontal: true,
              strokeDasharray: [3, 3],
            ),
            areaSeries: const [
              AreaSeries(
                dataKey: 'uv',
                name: 'UV',
                stroke: Color(0xFF82CA9D),
                fill: Color(0x8082CA9D),
                curveType: CurveType.monotone,
              ),
            ],
            tooltip: const ChartTooltip(),
          ),
        ),
        const SizedBox(height: 8),
        const Text('Unique Visitors'),
        const SizedBox(height: 16),
        Expanded(
          child: CartesianChartWidget(
            syncId: 'mainSync',
            data: pageData,
            xAxes: const [XAxis(dataKey: 'name')],
            yAxes: const [YAxis()],
            grid: const CartesianGrid(
              horizontal: true,
              strokeDasharray: [3, 3],
            ),
            barSeries: const [
              BarSeries(
                dataKey: 'pv',
                name: 'PV',
                fill: Color(0xFF8884D8),
              ),
            ],
            tooltip: const ChartTooltip(),
          ),
        ),
        const SizedBox(height: 8),
        const Text('Page Views'),
        const SizedBox(height: 16),
        Expanded(
          child: CartesianChartWidget(
            syncId: 'mainSync',
            data: pageData,
            xAxes: const [XAxis(dataKey: 'name')],
            yAxes: const [YAxis()],
            grid: const CartesianGrid(
              horizontal: true,
              strokeDasharray: [3, 3],
            ),
            lineSeries: const [
              LineSeries(
                dataKey: 'amt',
                name: 'AMT',
                stroke: Color(0xFF2C5097),
                strokeWidth: 2,
                curveType: CurveType.monotone,
              ),
            ],
            tooltip: const ChartTooltip(),
          ),
        ),
        const SizedBox(height: 8),
        const Text('Amount'),
      ],
    );
  }

  static const String sourceCode = '''
// All charts with the same syncId share tooltip state
Column(
  children: [
    CartesianChartWidget(
      syncId: 'mainSync',  // Same ID
      data: data,
      areaSeries: const [
        AreaSeries(dataKey: 'uv', stroke: Color(0xFF82CA9D)),
      ],
      tooltip: const ChartTooltip(),
    ),
    CartesianChartWidget(
      syncId: 'mainSync',  // Same ID
      data: data,
      barSeries: const [
        BarSeries(dataKey: 'pv', fill: Color(0xFF8884D8)),
      ],
      tooltip: const ChartTooltip(),
    ),
    CartesianChartWidget(
      syncId: 'mainSync',  // Same ID
      data: data,
      lineSeries: const [
        LineSeries(dataKey: 'amt', stroke: Color(0xFF2C5097)),
      ],
      tooltip: const ChartTooltip(),
    ),
  ],
)''';
}
