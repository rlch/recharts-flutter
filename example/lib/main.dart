/// Recharts Flutter Example App
///
/// A comprehensive gallery demonstrating all chart types available in
/// recharts_flutter, matching the Recharts examples.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'converter_lab.dart';

// Line Chart Examples
import 'examples/line_chart/simple_line_chart.dart';
import 'examples/line_chart/dashed_line_chart.dart';
import 'examples/line_chart/biaxial_line_chart.dart';
import 'examples/line_chart/vertical_line_chart.dart';
import 'examples/line_chart/line_chart_connect_nulls.dart';
import 'examples/line_chart/line_chart_with_reference_lines.dart';
import 'examples/line_chart/synchronized_line_chart.dart';
import 'examples/line_chart/line_chart_with_brush.dart';

// Area Chart Examples
import 'examples/area_chart/simple_area_chart.dart';
import 'examples/area_chart/stacked_area_chart.dart';
import 'examples/area_chart/percent_area_chart.dart';
import 'examples/area_chart/area_chart_connect_nulls.dart';

// Bar Chart Examples
import 'examples/bar_chart/simple_bar_chart.dart';
import 'examples/bar_chart/stacked_bar_chart.dart';
import 'examples/bar_chart/mix_bar_chart.dart';
import 'examples/bar_chart/positive_negative_bar_chart.dart';
import 'examples/bar_chart/bar_chart_with_brush.dart';

// Composed Chart
import 'examples/composed_chart/line_bar_area_composed.dart';

// Scatter Chart Examples
import 'examples/scatter_chart/simple_scatter_chart.dart';
import 'examples/scatter_chart/bubble_chart.dart';

// Pie Chart Examples
import 'examples/pie_chart/simple_pie_chart.dart';
import 'examples/pie_chart/two_level_pie_chart.dart';
import 'examples/pie_chart/pie_chart_with_padding_angle.dart';
import 'examples/pie_chart/custom_active_shape_pie_chart.dart';

// Radar Chart Examples
import 'examples/radar_chart/simple_radar_chart.dart';
import 'examples/radar_chart/specified_domain_radar_chart.dart';

// Radial Bar Chart
import 'examples/radial_bar_chart/simple_radial_bar_chart.dart';

// Treemap
import 'examples/treemap/simple_treemap.dart';

// Funnel
import 'examples/funnel/simple_funnel_chart.dart';

// Sankey
import 'examples/sankey/simple_sankey_chart.dart';

// Features
import 'examples/features/custom_tooltip.dart';
import 'examples/features/legend_toggle.dart';
import 'examples/features/responsive_container.dart';
import 'examples/features/synchronized_charts.dart';

void main() {
  runApp(const RechartsExampleApp());
}

class RechartsExampleApp extends StatefulWidget {
  const RechartsExampleApp({super.key});

  @override
  State<RechartsExampleApp> createState() => _RechartsExampleAppState();
}

class _RechartsExampleAppState extends State<RechartsExampleApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recharts Flutter Examples',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8884D8),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8884D8),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: _themeMode,
      home: ChartGallery(
        onThemeToggle: _toggleTheme,
        isDarkMode: _themeMode == ThemeMode.dark,
      ),
    );
  }
}

class ExampleItem {
  final String title;
  final Widget Function() builder;
  final String sourceCode;

  const ExampleItem({
    required this.title,
    required this.builder,
    required this.sourceCode,
  });
}

class ExampleCategory {
  final String name;
  final IconData icon;
  final List<ExampleItem> examples;

  const ExampleCategory({
    required this.name,
    required this.icon,
    required this.examples,
  });
}

final categories = [
  ExampleCategory(
    name: 'Line Chart',
    icon: Icons.show_chart,
    examples: [
      ExampleItem(
        title: 'Simple Line Chart',
        builder: () => const SimpleLineChart(),
        sourceCode: SimpleLineChart.sourceCode,
      ),
      ExampleItem(
        title: 'Dashed Line Chart',
        builder: () => const DashedLineChart(),
        sourceCode: DashedLineChart.sourceCode,
      ),
      ExampleItem(
        title: 'Biaxial Line Chart',
        builder: () => const BiaxialLineChart(),
        sourceCode: BiaxialLineChart.sourceCode,
      ),
      ExampleItem(
        title: 'Vertical Line Chart',
        builder: () => const VerticalLineChart(),
        sourceCode: VerticalLineChart.sourceCode,
      ),
      ExampleItem(
        title: 'Connect Nulls',
        builder: () => const LineChartConnectNulls(),
        sourceCode: LineChartConnectNulls.sourceCode,
      ),
      ExampleItem(
        title: 'Reference Lines',
        builder: () => const LineChartWithReferenceLines(),
        sourceCode: LineChartWithReferenceLines.sourceCode,
      ),
      ExampleItem(
        title: 'Synchronized',
        builder: () => const SynchronizedLineChart(),
        sourceCode: SynchronizedLineChart.sourceCode,
      ),
      ExampleItem(
        title: 'With Brush',
        builder: () => const LineChartWithBrush(),
        sourceCode: LineChartWithBrush.sourceCode,
      ),
    ],
  ),
  ExampleCategory(
    name: 'Area Chart',
    icon: Icons.area_chart,
    examples: [
      ExampleItem(
        title: 'Simple Area Chart',
        builder: () => const SimpleAreaChart(),
        sourceCode: SimpleAreaChart.sourceCode,
      ),
      ExampleItem(
        title: 'Stacked Area Chart',
        builder: () => const StackedAreaChart(),
        sourceCode: StackedAreaChart.sourceCode,
      ),
      ExampleItem(
        title: 'Percent Area Chart',
        builder: () => const PercentAreaChart(),
        sourceCode: PercentAreaChart.sourceCode,
      ),
      ExampleItem(
        title: 'Connect Nulls',
        builder: () => const AreaChartConnectNulls(),
        sourceCode: AreaChartConnectNulls.sourceCode,
      ),
    ],
  ),
  ExampleCategory(
    name: 'Bar Chart',
    icon: Icons.bar_chart,
    examples: [
      ExampleItem(
        title: 'Simple Bar Chart',
        builder: () => const SimpleBarChart(),
        sourceCode: SimpleBarChart.sourceCode,
      ),
      ExampleItem(
        title: 'Stacked Bar Chart',
        builder: () => const StackedBarChart(),
        sourceCode: StackedBarChart.sourceCode,
      ),
      ExampleItem(
        title: 'Mix Bar Chart',
        builder: () => const MixBarChart(),
        sourceCode: MixBarChart.sourceCode,
      ),
      ExampleItem(
        title: 'Positive & Negative',
        builder: () => const PositiveNegativeBarChart(),
        sourceCode: PositiveNegativeBarChart.sourceCode,
      ),
      ExampleItem(
        title: 'With Brush',
        builder: () => const BarChartWithBrush(),
        sourceCode: BarChartWithBrush.sourceCode,
      ),
    ],
  ),
  ExampleCategory(
    name: 'Composed Chart',
    icon: Icons.stacked_line_chart,
    examples: [
      ExampleItem(
        title: 'Line Bar Area',
        builder: () => const LineBarAreaComposed(),
        sourceCode: LineBarAreaComposed.sourceCode,
      ),
    ],
  ),
  ExampleCategory(
    name: 'Scatter Chart',
    icon: Icons.scatter_plot,
    examples: [
      ExampleItem(
        title: 'Simple Scatter',
        builder: () => const SimpleScatterChart(),
        sourceCode: SimpleScatterChart.sourceCode,
      ),
      ExampleItem(
        title: 'Bubble Chart',
        builder: () => const BubbleChart(),
        sourceCode: BubbleChart.sourceCode,
      ),
    ],
  ),
  ExampleCategory(
    name: 'Pie Chart',
    icon: Icons.pie_chart,
    examples: [
      ExampleItem(
        title: 'Simple Pie',
        builder: () => const SimplePieChart(),
        sourceCode: SimplePieChart.sourceCode,
      ),
      ExampleItem(
        title: 'Two Level Pie',
        builder: () => const TwoLevelPieChart(),
        sourceCode: TwoLevelPieChart.sourceCode,
      ),
      ExampleItem(
        title: 'Padding Angle',
        builder: () => const PieChartWithPaddingAngle(),
        sourceCode: PieChartWithPaddingAngle.sourceCode,
      ),
      ExampleItem(
        title: 'Active Shape',
        builder: () => const CustomActiveShapePieChart(),
        sourceCode: CustomActiveShapePieChart.sourceCode,
      ),
    ],
  ),
  ExampleCategory(
    name: 'Radar Chart',
    icon: Icons.radar,
    examples: [
      ExampleItem(
        title: 'Simple Radar',
        builder: () => const SimpleRadarChart(),
        sourceCode: SimpleRadarChart.sourceCode,
      ),
      ExampleItem(
        title: 'Specified Domain',
        builder: () => const SpecifiedDomainRadarChart(),
        sourceCode: SpecifiedDomainRadarChart.sourceCode,
      ),
    ],
  ),
  ExampleCategory(
    name: 'Radial Bar',
    icon: Icons.donut_large,
    examples: [
      ExampleItem(
        title: 'Simple Radial Bar',
        builder: () => const SimpleRadialBarChart(),
        sourceCode: SimpleRadialBarChart.sourceCode,
      ),
    ],
  ),
  ExampleCategory(
    name: 'Treemap',
    icon: Icons.grid_view,
    examples: [
      ExampleItem(
        title: 'Simple Treemap',
        builder: () => const SimpleTreemap(),
        sourceCode: SimpleTreemap.sourceCode,
      ),
    ],
  ),
  ExampleCategory(
    name: 'Funnel',
    icon: Icons.filter_alt,
    examples: [
      ExampleItem(
        title: 'Simple Funnel',
        builder: () => const SimpleFunnelChart(),
        sourceCode: SimpleFunnelChart.sourceCode,
      ),
    ],
  ),
  ExampleCategory(
    name: 'Sankey',
    icon: Icons.account_tree,
    examples: [
      ExampleItem(
        title: 'Simple Sankey',
        builder: () => const SimpleSankeyChart(),
        sourceCode: SimpleSankeyChart.sourceCode,
      ),
    ],
  ),
  ExampleCategory(
    name: 'Features',
    icon: Icons.star,
    examples: [
      ExampleItem(
        title: 'Custom Tooltip',
        builder: () => const CustomTooltipExample(),
        sourceCode: CustomTooltipExample.sourceCode,
      ),
      ExampleItem(
        title: 'Legend Toggle',
        builder: () => const LegendToggleExample(),
        sourceCode: LegendToggleExample.sourceCode,
      ),
      ExampleItem(
        title: 'Responsive Container',
        builder: () => const ResponsiveContainerExample(),
        sourceCode: ResponsiveContainerExample.sourceCode,
      ),
      ExampleItem(
        title: 'Synchronized Charts',
        builder: () => const SynchronizedChartsExample(),
        sourceCode: SynchronizedChartsExample.sourceCode,
      ),
    ],
  ),
];

class ChartGallery extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const ChartGallery({
    super.key,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  State<ChartGallery> createState() => _ChartGalleryState();
}

class _ChartGalleryState extends State<ChartGallery> {
  int _selectedCategoryIndex = 0;
  int _selectedExampleIndex = 0;
  int _selectedTabIndex = 0;
  bool _showCode = false;

  ExampleCategory get _currentCategory => categories[_selectedCategoryIndex];
  ExampleItem get _currentExample =>
      _currentCategory.examples[_selectedExampleIndex];

  void _selectExample(int categoryIndex, int exampleIndex) {
    setState(() {
      _selectedTabIndex = 0;
      _selectedCategoryIndex = categoryIndex;
      _selectedExampleIndex = exampleIndex;
      _showCode = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: _selectedTabIndex,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _selectedTabIndex == 0 ? _currentExample.title : 'Converter Lab',
          ),
          bottom: TabBar(
            onTap: (index) {
              setState(() {
                _selectedTabIndex = index;
              });
            },
            tabs: const [
              Tab(text: 'Gallery', icon: Icon(Icons.grid_view)),
              Tab(text: 'Converter', icon: Icon(Icons.auto_fix_high)),
            ],
          ),
          actions: [
            if (_selectedTabIndex == 0)
              IconButton(
                icon: Icon(_showCode ? Icons.visibility : Icons.code),
                tooltip: _showCode ? 'Show Chart' : 'Show Code',
                onPressed: () {
                  setState(() {
                    _showCode = !_showCode;
                  });
                },
              ),
            IconButton(
              icon:
                  Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
              tooltip: 'Toggle Theme',
              onPressed: widget.onThemeToggle,
            ),
          ],
        ),
        drawer: _buildDrawer(),
        body: IndexedStack(
          index: _selectedTabIndex,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: _showCode ? _buildCodeView() : _buildChartView(),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: ConverterLab(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.insert_chart,
                  size: 48,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(height: 8),
                Text(
                  'Recharts Flutter',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                Text(
                  'Examples Gallery',
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimaryContainer
                        .withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          ...categories.asMap().entries.map((categoryEntry) {
            final categoryIndex = categoryEntry.key;
            final category = categoryEntry.value;
            final isExpanded = categoryIndex == _selectedCategoryIndex;

            return ExpansionTile(
              leading: Icon(category.icon),
              title: Text(category.name),
              initiallyExpanded: isExpanded,
              children: category.examples.asMap().entries.map((exampleEntry) {
                final exampleIndex = exampleEntry.key;
                final example = exampleEntry.value;
                final isSelected = categoryIndex == _selectedCategoryIndex &&
                    exampleIndex == _selectedExampleIndex;

                return ListTile(
                  title: Text(example.title),
                  selected: isSelected,
                  selectedTileColor: Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withValues(alpha: 0.3),
                  contentPadding: const EdgeInsets.only(left: 56),
                  onTap: () => _selectExample(categoryIndex, exampleIndex),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildChartView() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: _currentExample.builder(),
      ),
    );
  }

  Widget _buildCodeView() {
    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                const Icon(Icons.code, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Source Code',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.copy, size: 20),
                  tooltip: 'Copy to clipboard',
                  onPressed: () {
                    Clipboard.setData(
                        ClipboardData(text: _currentExample.sourceCode));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Code copied to clipboard')),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: SelectableText(
                _currentExample.sourceCode,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
