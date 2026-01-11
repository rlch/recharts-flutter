import 'package:flutter/material.dart';
import 'package:recharts_flutter/recharts_flutter.dart';
import '../../data/page_data.dart';

class ResponsiveContainerExample extends StatelessWidget {
  const ResponsiveContainerExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveChartContainer(
      builder: (width, height) => CartesianChartWidget(
        width: width,
        height: height,
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
      ),
    );
  }

  static const String sourceCode = '''
// ResponsiveChartContainer automatically sizes the chart
// to fit its parent container
ResponsiveChartContainer(
  builder: (width, height) => CartesianChartWidget(
    width: width,
    height: height,
    data: pageData,
    xAxes: const [XAxis(dataKey: 'name')],
    yAxes: const [YAxis()],
    lineSeries: const [
      LineSeries(dataKey: 'pv', stroke: Color(0xFF8884D8)),
      LineSeries(dataKey: 'uv', stroke: Color(0xFF82CA9D)),
    ],
    tooltip: const ChartTooltip(),
  ),
)

// The chart will resize when the container resizes,
// making it perfect for responsive layouts.''';
}
