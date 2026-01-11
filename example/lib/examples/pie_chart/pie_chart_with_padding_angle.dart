import 'package:flutter/material.dart';
import 'package:recharts_flutter/recharts_flutter.dart';
import '../../data/page_data.dart';

class PieChartWithPaddingAngle extends StatelessWidget {
  const PieChartWithPaddingAngle({super.key});

  @override
  Widget build(BuildContext context) {
    return PolarChartWidget(
      data: pieData,
      innerRadiusPercent: 0.5,
      pieSeries: const [
        PieSeries(
          dataKey: 'value',
          nameKey: 'name',
          innerRadius: 50,
          outerRadius: 100,
          paddingAngle: 5,
        ),
      ],
      tooltip: const ChartTooltip(),
    );
  }

  static const String sourceCode = '''
PolarChartWidget(
  data: pieData,
  innerRadiusPercent: 0.5,  // Donut chart
  pieSeries: const [
    PieSeries(
      dataKey: 'value',
      nameKey: 'name',
      innerRadius: 50,
      outerRadius: 100,
      paddingAngle: 5,  // Gap between segments
    ),
  ],
  tooltip: const ChartTooltip(),
)''';
}
