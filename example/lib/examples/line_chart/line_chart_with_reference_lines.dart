import 'package:flutter/material.dart';
import 'package:recharts_flutter/recharts_flutter.dart';

const _referenceLineData = [
  {'name': 'Page A', 'uv': 4000, 'pv': 2400, 'amt': 2400},
  {'name': 'Page B', 'uv': 3000, 'pv': 1398, 'amt': 2210},
  {'name': 'Page C', 'uv': 2000, 'pv': 9800, 'amt': 2290},
  {'name': 'Page D', 'uv': 2780, 'pv': 3908, 'amt': 2000},
  {'name': 'Page E', 'uv': 1890, 'pv': 4800, 'amt': 2181},
  {'name': 'Page F', 'uv': 2390, 'pv': 3800, 'amt': 2500},
  {'name': 'Page G', 'uv': 3490, 'pv': 4300, 'amt': 2100},
];

const _trackedKeys = ['pv', 'uv'];

class _PeakReference {
  const _PeakReference({required this.xCategory, required this.yValue});

  final String xCategory;
  final num yValue;
}

class LineChartWithReferenceLines extends StatelessWidget {
  const LineChartWithReferenceLines({super.key});

  static _PeakReference _findPeakReference(List<dynamic> data) {
    num? maxValue;
    String? maxCategory;

    for (final item in data) {
      if (item is! Map) continue;
      final category = item['name'];
      if (category is! String) continue;

      for (final key in _trackedKeys) {
        final value = item[key];
        if (value is! num) continue;
        final currentMax = maxValue;
        if (currentMax == null || value > currentMax) {
          maxValue = value;
          maxCategory = category;
        }
      }
    }

    return _PeakReference(
      xCategory: maxCategory ?? '',
      yValue: maxValue ?? 0,
    );
  }

  static String _formatPeak(num value) {
    return value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final peak = _findPeakReference(_referenceLineData);

    return CartesianChartWidget(
      data: _referenceLineData,
      xAxes: const [XAxis(dataKey: 'name')],
      yAxes: const [
        YAxis(domain: [0, 10000])
      ],
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
      referenceLines: [
        ReferenceLine(
          y: peak.yValue,
          stroke: const Color(0xFFE53935),
          strokeWidth: 2,
          strokeDasharray: const [6, 4],
          label: 'Max Y (${_formatPeak(peak.yValue)})',
          labelPosition: ReferenceLineLabelPosition.center,
          labelColor: const Color(0xFF6B7280),
          isFront: true,
        ),
        ReferenceLine(
          x: peak.xCategory,
          stroke: const Color(0xFFE53935),
          strokeWidth: 2,
          strokeDasharray: const [6, 4],
          label: 'Max X (${peak.xCategory})',
          labelPosition: ReferenceLineLabelPosition.center,
          labelColor: const Color(0xFF6B7280),
          isFront: true,
        ),
      ],
      tooltip: const ChartTooltip(),
    );
  }

  static const String sourceCode = '''
final peak = _findPeakReference(_referenceLineData);

CartesianChartWidget(
  data: _referenceLineData,
  xAxes: const [XAxis(dataKey: 'name')],
  yAxes: const [YAxis(domain: [0, 10000])],
  grid: const CartesianGrid(strokeDasharray: [3, 3]),
  lineSeries: const [
    LineSeries(dataKey: 'pv', stroke: Color(0xFF8884D8)),
    LineSeries(dataKey: 'uv', stroke: Color(0xFF82CA9D)),
  ],
  referenceLines: [
    ReferenceLine(
      y: peak.yValue,
      stroke: Color(0xFFE53935),
      strokeWidth: 2,
      strokeDasharray: [6, 4],
      label: 'Max Y',
      isFront: true,
    ),
    ReferenceLine(
      x: peak.xCategory,
      stroke: Color(0xFFE53935),
      strokeWidth: 2,
      strokeDasharray: [6, 4],
      label: 'Max X',
      isFront: true,
    ),
  ],
  tooltip: const ChartTooltip(),
)''';
}
