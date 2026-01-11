import 'package:flutter/material.dart';
import 'package:recharts_flutter/recharts_flutter.dart';
import '../../data/page_data.dart';

class SpecifiedDomainRadarChart extends StatelessWidget {
  const SpecifiedDomainRadarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return PolarChartWidget(
      data: subjectData,
      angleAxis: const PolarAngleAxis(dataKey: 'subject'),
      radiusAxis: const PolarRadiusAxis(
        tickCount: 5,
        domain: [0, 150],
      ),
      grid: const PolarGrid(),
      radarSeries: const [
        RadarSeries(
          dataKey: 'A',
          name: 'Student A',
          stroke: Color(0xFF8884D8),
          fill: Color(0x408884D8),
        ),
      ],
      tooltip: const ChartTooltip(),
    );
  }

  static const String sourceCode = '''
PolarChartWidget(
  data: subjectData,
  angleAxis: const PolarAngleAxis(dataKey: 'subject'),
  radiusAxis: const PolarRadiusAxis(
    tickCount: 5,
    domain: [0, 150],  // Specified domain
  ),
  grid: const PolarGrid(),
  radarSeries: const [
    RadarSeries(
      dataKey: 'A',
      name: 'Student A',
      stroke: Color(0xFF8884D8),
      fill: Color(0x408884D8),
    ),
  ],
  tooltip: const ChartTooltip(),
)''';
}
