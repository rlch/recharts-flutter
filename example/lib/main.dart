/// Recharts Flutter Example App
///
/// This example demonstrates all chart types and features available in
/// the recharts_flutter library.
library;

import 'package:flutter/material.dart';
import 'package:recharts_flutter/recharts_flutter.dart';

void main() {
  runApp(const RechartsExampleApp());
}

class RechartsExampleApp extends StatelessWidget {
  const RechartsExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recharts Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ChartGallery(),
    );
  }
}

class ChartGallery extends StatelessWidget {
  const ChartGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recharts Flutter Gallery'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection('Cartesian Charts', [
            _ChartCard(
              title: 'Line Chart',
              child: _buildLineChart(),
            ),
            _ChartCard(
              title: 'Area Chart',
              child: _buildAreaChart(),
            ),
            _ChartCard(
              title: 'Bar Chart',
              child: _buildBarChart(),
            ),
            _ChartCard(
              title: 'Multi-Series Chart',
              child: _buildMultiSeriesChart(),
            ),
          ]),
          _buildSection('Synchronized Charts', [
            _ChartCard(
              title: 'Synced Line Charts',
              subtitle: 'Hover one chart to sync tooltips',
              child: _buildSyncedCharts(),
            ),
          ]),
          _buildSection('Polar Charts', [
            _ChartCard(
              title: 'Pie Chart',
              child: _buildPieChart(),
            ),
            _ChartCard(
              title: 'Radar Chart',
              child: _buildRadarChart(),
            ),
          ]),
          _buildSection('Specialized Charts', [
            _ChartCard(
              title: 'Funnel Chart',
              child: _buildFunnelChart(),
            ),
            _ChartCard(
              title: 'Treemap',
              child: _buildTreemap(),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildLineChart() {
    final data = [
      {'name': 'Jan', 'value': 400},
      {'name': 'Feb', 'value': 300},
      {'name': 'Mar', 'value': 600},
      {'name': 'Apr', 'value': 800},
      {'name': 'May', 'value': 500},
      {'name': 'Jun', 'value': 900},
    ];

    return SizedBox(
      height: 300,
      child: CartesianChartWidget(
        data: data,
        xAxes: const [XAxis(dataKey: 'name')],
        yAxes: const [YAxis()],
        grid: const CartesianGrid(horizontal: true, vertical: true),
        lineSeries: const [
          LineSeries(
            dataKey: 'value',
            stroke: Color(0xFF8884D8),
            strokeWidth: 2,
          ),
        ],
        tooltip: const ChartTooltip(),
      ),
    );
  }

  Widget _buildAreaChart() {
    final data = [
      {'name': 'Jan', 'value': 400},
      {'name': 'Feb', 'value': 300},
      {'name': 'Mar', 'value': 600},
      {'name': 'Apr', 'value': 800},
      {'name': 'May', 'value': 500},
      {'name': 'Jun', 'value': 900},
    ];

    return SizedBox(
      height: 300,
      child: CartesianChartWidget(
        data: data,
        xAxes: const [XAxis(dataKey: 'name')],
        yAxes: const [YAxis()],
        areaSeries: const [
          AreaSeries(
            dataKey: 'value',
            stroke: Color(0xFF82CA9D),
            fill: Color(0x8082CA9D),
          ),
        ],
        tooltip: const ChartTooltip(),
      ),
    );
  }

  Widget _buildBarChart() {
    final data = [
      {'name': 'A', 'value': 4000},
      {'name': 'B', 'value': 3000},
      {'name': 'C', 'value': 2000},
      {'name': 'D', 'value': 2780},
      {'name': 'E', 'value': 1890},
    ];

    return SizedBox(
      height: 300,
      child: CartesianChartWidget(
        data: data,
        xAxes: const [XAxis(dataKey: 'name')],
        yAxes: const [YAxis()],
        grid: const CartesianGrid(horizontal: true),
        barSeries: const [
          BarSeries(
            dataKey: 'value',
            fill: Color(0xFF8884D8),
          ),
        ],
        tooltip: const ChartTooltip(),
      ),
    );
  }

  Widget _buildMultiSeriesChart() {
    final data = [
      {'name': 'Jan', 'uv': 4000, 'pv': 2400},
      {'name': 'Feb', 'uv': 3000, 'pv': 1398},
      {'name': 'Mar', 'uv': 2000, 'pv': 9800},
      {'name': 'Apr', 'uv': 2780, 'pv': 3908},
      {'name': 'May', 'uv': 1890, 'pv': 4800},
    ];

    return SizedBox(
      height: 300,
      child: CartesianChartWidget(
        data: data,
        xAxes: const [XAxis(dataKey: 'name')],
        yAxes: const [YAxis()],
        grid: const CartesianGrid(horizontal: true),
        lineSeries: const [
          LineSeries(
            dataKey: 'uv',
            name: 'UV',
            stroke: Color(0xFF8884D8),
            strokeWidth: 2,
          ),
          LineSeries(
            dataKey: 'pv',
            name: 'PV',
            stroke: Color(0xFF82CA9D),
            strokeWidth: 2,
          ),
        ],
        tooltip: const ChartTooltip(),
      ),
    );
  }

  Widget _buildSyncedCharts() {
    final data1 = [
      {'name': 'Jan', 'value': 400},
      {'name': 'Feb', 'value': 300},
      {'name': 'Mar', 'value': 600},
      {'name': 'Apr', 'value': 800},
      {'name': 'May', 'value': 500},
    ];

    final data2 = [
      {'name': 'Jan', 'users': 1000},
      {'name': 'Feb', 'users': 1500},
      {'name': 'Mar', 'users': 1200},
      {'name': 'Apr', 'users': 1800},
      {'name': 'May', 'users': 2000},
    ];

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: CartesianChartWidget(
            syncId: 'syncGroup1',
            data: data1,
            xAxes: const [XAxis(dataKey: 'name')],
            yAxes: const [YAxis()],
            lineSeries: const [
              LineSeries(
                dataKey: 'value',
                name: 'Revenue',
                stroke: Color(0xFF8884D8),
              ),
            ],
            tooltip: const ChartTooltip(),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: CartesianChartWidget(
            syncId: 'syncGroup1',
            data: data2,
            xAxes: const [XAxis(dataKey: 'name')],
            yAxes: const [YAxis()],
            lineSeries: const [
              LineSeries(
                dataKey: 'users',
                name: 'Users',
                stroke: Color(0xFF82CA9D),
              ),
            ],
            tooltip: const ChartTooltip(),
          ),
        ),
      ],
    );
  }

  Widget _buildPieChart() {
    final data = [
      {'name': 'Group A', 'value': 400},
      {'name': 'Group B', 'value': 300},
      {'name': 'Group C', 'value': 300},
      {'name': 'Group D', 'value': 200},
    ];

    return SizedBox(
      height: 300,
      child: PolarChartWidget(
        data: data,
        pieSeries: const [
          PieSeries(
            dataKey: 'value',
            nameKey: 'name',
          ),
        ],
        tooltip: const ChartTooltip(),
      ),
    );
  }

  Widget _buildRadarChart() {
    final data = [
      {'subject': 'Math', 'A': 120, 'B': 110},
      {'subject': 'Chinese', 'A': 98, 'B': 130},
      {'subject': 'English', 'A': 86, 'B': 130},
      {'subject': 'Geography', 'A': 99, 'B': 100},
      {'subject': 'Physics', 'A': 85, 'B': 90},
    ];

    return SizedBox(
      height: 300,
      child: PolarChartWidget(
        data: data,
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
      ),
    );
  }

  Widget _buildFunnelChart() {
    final data = [
      {'name': 'Impressions', 'value': 10000},
      {'name': 'Clicks', 'value': 5000},
      {'name': 'Leads', 'value': 2000},
      {'name': 'Sales', 'value': 500},
    ];

    return SizedBox(
      height: 300,
      child: FunnelChart(
        data: data,
        series: const FunnelSeries(
          dataKey: 'value',
          nameKey: 'name',
        ),
      ),
    );
  }

  Widget _buildTreemap() {
    final data = TreemapNode(
      name: 'Root',
      children: [
        TreemapNode(name: 'A', value: 100, color: const Color(0xFF8884D8)),
        TreemapNode(name: 'B', value: 200, color: const Color(0xFF82CA9D)),
        TreemapNode(name: 'C', value: 150, color: const Color(0xFFFFC658)),
        TreemapNode(name: 'D', value: 80, color: const Color(0xFFFF8042)),
      ],
    );

    return SizedBox(
      height: 300,
      child: TreemapChart(data: data),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;

  const _ChartCard({
    required this.title,
    this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 8),
                child: Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}
