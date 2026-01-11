import 'package:flutter/material.dart';
import 'package:recharts_flutter/recharts_flutter.dart';
import '../../data/page_data.dart';

class SimpleRadarChart extends StatelessWidget {
  const SimpleRadarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return PolarChartWidget(
      data: subjectData,
      angleAxis: const PolarAngleAxis(dataKey: 'subject'),
      radiusAxis: const PolarRadiusAxis(tickCount: 5),
      grid: const PolarGrid(),
      radarSeries: const [
        RadarSeries(
          dataKey: 'A',
          name: 'Student A',
          stroke: Color(0xFF8884D8),
          fill: Color(0x408884D8),
        ),
        RadarSeries(
          dataKey: 'B',
          name: 'Student B',
          stroke: Color(0xFF82CA9D),
          fill: Color(0x4082CA9D),
        ),
      ],
      tooltip: const ChartTooltip(),
    );
  }

  static const String sourceCode = '''
final subjectData = [
  {'subject': 'Math', 'A': 120, 'B': 110, 'fullMark': 150},
  {'subject': 'Chinese', 'A': 98, 'B': 130, 'fullMark': 150},
  {'subject': 'English', 'A': 86, 'B': 130, 'fullMark': 150},
  {'subject': 'Geography', 'A': 99, 'B': 100, 'fullMark': 150},
  {'subject': 'Physics', 'A': 85, 'B': 90, 'fullMark': 150},
  {'subject': 'History', 'A': 65, 'B': 85, 'fullMark': 150},
];

PolarChartWidget(
  data: subjectData,
  angleAxis: const PolarAngleAxis(dataKey: 'subject'),
  radiusAxis: const PolarRadiusAxis(tickCount: 5),
  grid: const PolarGrid(),
  radarSeries: const [
    RadarSeries(
      dataKey: 'A',
      name: 'Student A',
      stroke: Color(0xFF8884D8),
      fill: Color(0x408884D8),
    ),
    RadarSeries(
      dataKey: 'B',
      name: 'Student B',
      stroke: Color(0xFF82CA9D),
      fill: Color(0x4082CA9D),
    ),
  ],
  tooltip: const ChartTooltip(),
)''';
}
