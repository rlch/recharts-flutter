import 'package:flutter/material.dart';
import 'package:recharts_flutter/recharts_flutter.dart';
import '../../data/page_data.dart';

class SimpleFunnelChart extends StatelessWidget {
  const SimpleFunnelChart({super.key});

  @override
  Widget build(BuildContext context) {
    return FunnelChart(
      data: funnelData,
      series: const FunnelSeries(
        dataKey: 'value',
        nameKey: 'name',
      ),
    );
  }

  static const String sourceCode = '''
final funnelData = [
  {'name': 'Sent', 'value': 4500, 'fill': '#8884d8'},
  {'name': 'Viewed', 'value': 3000, 'fill': '#83a6ed'},
  {'name': 'Clicked', 'value': 2000, 'fill': '#8dd1e1'},
  {'name': 'Applied', 'value': 1200, 'fill': '#82ca9d'},
  {'name': 'Interviewed', 'value': 500, 'fill': '#a4de6c'},
  {'name': 'Hired', 'value': 100, 'fill': '#d0ed57'},
];

FunnelChart(
  data: funnelData,
  series: const FunnelSeries(
    dataKey: 'value',
    nameKey: 'name',
  ),
)''';
}
