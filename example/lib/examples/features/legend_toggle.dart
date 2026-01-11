import 'package:flutter/material.dart';
import 'package:recharts_flutter/recharts_flutter.dart';
import '../../data/page_data.dart';

class LegendToggleExample extends StatefulWidget {
  const LegendToggleExample({super.key});

  static const String sourceCode = '''
class LegendToggleExample extends StatefulWidget {
  @override
  State<LegendToggleExample> createState() => _LegendToggleExampleState();
}

class _LegendToggleExampleState extends State<LegendToggleExample> {
  final Set<String> _hiddenSeries = {};

  void _toggleSeries(String dataKey) {
    setState(() {
      if (_hiddenSeries.contains(dataKey)) {
        _hiddenSeries.remove(dataKey);
      } else {
        _hiddenSeries.add(dataKey);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CartesianChartWidget(
      data: pageData,
      lineSeries: [
        LineSeries(
          dataKey: 'pv',
          stroke: Color(0xFF8884D8),
          hide: _hiddenSeries.contains('pv'),  // Toggle visibility
        ),
        LineSeries(
          dataKey: 'uv',
          stroke: Color(0xFF82CA9D),
          hide: _hiddenSeries.contains('uv'),
        ),
      ],
    );
  }
}''';

  @override
  State<LegendToggleExample> createState() => _LegendToggleExampleState();
}

class _LegendToggleExampleState extends State<LegendToggleExample> {
  final Set<String> _hiddenSeries = {};

  void _toggleSeries(String dataKey) {
    setState(() {
      if (_hiddenSeries.contains(dataKey)) {
        _hiddenSeries.remove(dataKey);
      } else {
        _hiddenSeries.add(dataKey);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem('pv', 'Page Views', const Color(0xFF8884D8)),
            const SizedBox(width: 24),
            _buildLegendItem('uv', 'Unique Visitors', const Color(0xFF82CA9D)),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: CartesianChartWidget(
            data: pageData,
            xAxes: const [XAxis(dataKey: 'name')],
            yAxes: const [YAxis()],
            grid: const CartesianGrid(
              horizontal: true,
              vertical: true,
              strokeDasharray: [3, 3],
            ),
            lineSeries: [
              LineSeries(
                dataKey: 'pv',
                name: 'Page Views',
                stroke: const Color(0xFF8884D8),
                strokeWidth: 2,
                curveType: CurveType.monotone,
                hide: _hiddenSeries.contains('pv'),
              ),
              LineSeries(
                dataKey: 'uv',
                name: 'Unique Visitors',
                stroke: const Color(0xFF82CA9D),
                strokeWidth: 2,
                curveType: CurveType.monotone,
                hide: _hiddenSeries.contains('uv'),
              ),
            ],
            tooltip: const ChartTooltip(),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String dataKey, String label, Color color) {
    final isHidden = _hiddenSeries.contains(dataKey);
    return GestureDetector(
      onTap: () => _toggleSeries(dataKey),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: isHidden ? Colors.grey.shade300 : color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isHidden ? Colors.grey : Colors.black87,
              decoration: isHidden ? TextDecoration.lineThrough : null,
            ),
          ),
        ],
      ),
    );
  }
}
