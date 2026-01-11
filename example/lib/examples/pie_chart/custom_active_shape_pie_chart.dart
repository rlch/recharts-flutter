import 'package:flutter/material.dart';
import 'package:recharts_flutter/recharts_flutter.dart';
import '../../data/page_data.dart';

class CustomActiveShapePieChart extends StatelessWidget {
  const CustomActiveShapePieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return PolarChartWidget(
      data: pieData,
      pieSeries: const [
        PieSeries(
          dataKey: 'value',
          nameKey: 'name',
          innerRadius: 40,
          outerRadius: 80,
          label: true,
        ),
      ],
      tooltip: const ChartTooltip(),
    );
  }

  static const String sourceCode = '''
PolarChartWidget(
  data: pieData,
  pieSeries: const [
    PieSeries(
      dataKey: 'value',
      nameKey: 'name',
      innerRadius: 40,
      outerRadius: 80,
      label: true,  // Show labels
      // Custom active shape rendering
      // activeShape: (props) => CustomActiveShape(props),
    ),
  ],
  tooltip: const ChartTooltip(),
)''';
}
