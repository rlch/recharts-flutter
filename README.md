# Recharts Flutter

A comprehensive charting library for Flutter, ported from [Recharts](https://github.com/recharts/recharts) (React).

## Features

- **Cartesian Charts**: Line, Area, Bar, and Scatter charts with full customization
- **Polar Charts**: Pie, Radar, and Radial Bar charts
- **Specialized Charts**: Funnel, Treemap, Sunburst, and Sankey diagrams
- **Interactive Tooltips**: Hover and click-based tooltips with customizable content
- **Chart Synchronization**: Sync tooltips across multiple charts with `syncId`
- **Animations**: Smooth data transitions with configurable easing
- **Responsive Sizing**: Charts adapt to available space
- **Reference Elements**: Reference lines, areas, and dots for annotations

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  recharts_flutter:
    git:
      url: https://github.com/your-repo/recharts_flutter.git
```

## Quick Start

### Line Chart

```dart
import 'package:recharts_flutter/recharts_flutter.dart';

final data = [
  {'name': 'Jan', 'value': 400},
  {'name': 'Feb', 'value': 300},
  {'name': 'Mar', 'value': 600},
];

CartesianChartWidget(
  data: data,
  xAxes: [XAxis(dataKey: 'name')],
  yAxes: [YAxis()],
  lineSeries: [
    LineSeries(dataKey: 'value', stroke: Colors.blue),
  ],
  tooltip: ChartTooltip(),
)
```

### Bar Chart

```dart
CartesianChartWidget(
  data: data,
  xAxes: [XAxis(dataKey: 'name')],
  yAxes: [YAxis()],
  barSeries: [
    BarSeries(dataKey: 'value', fill: Colors.purple),
  ],
  tooltip: ChartTooltip(),
)
```

### Pie Chart

```dart
PolarChartWidget(
  data: data,
  pieSeries: [
    PieSeries(dataKey: 'value', nameKey: 'name'),
  ],
  tooltip: ChartTooltip(),
)
```

### Synchronized Charts

Charts with the same `syncId` share tooltip/hover state:

```dart
// Chart 1 - when hovered, Chart 2 shows tooltip at same index
CartesianChartWidget(
  syncId: 'myGroup',
  data: revenueData,
  lineSeries: [LineSeries(dataKey: 'revenue')],
  tooltip: ChartTooltip(),
)

// Chart 2 - synced with Chart 1
CartesianChartWidget(
  syncId: 'myGroup',
  data: usersData,
  lineSeries: [LineSeries(dataKey: 'users')],
  tooltip: ChartTooltip(),
)
```

## Chart Types

### Cartesian Charts

| Widget | Series Type | Description |
|--------|-------------|-------------|
| `CartesianChartWidget` | `LineSeries` | Line charts with customizable stroke, dots, and curve type |
| `CartesianChartWidget` | `AreaSeries` | Filled area charts with gradient support |
| `CartesianChartWidget` | `BarSeries` | Vertical bar charts with stacking support |
| `CartesianChartWidget` | `ScatterSeries` | Scatter plots with customizable point shapes |

### Polar Charts

| Widget | Series Type | Description |
|--------|-------------|-------------|
| `PolarChartWidget` | `PieSeries` | Pie and donut charts |
| `PolarChartWidget` | `RadarSeries` | Radar/spider charts |
| `PolarChartWidget` | `RadialBarSeries` | Radial bar charts |

### Specialized Charts

| Widget | Description |
|--------|-------------|
| `FunnelChart` | Funnel/pyramid charts for conversion visualization |
| `TreemapChart` | Hierarchical data as nested rectangles |
| `SunburstChart` | Hierarchical data as concentric rings |
| `SankeyChart` | Flow diagrams showing relationships |

## Configuration

### Axes

```dart
XAxis(
  dataKey: 'name',
  tickFormatter: (value) => value.toString(),
  axisLine: true,
  tickLine: true,
)

YAxis(
  domain: (0, 100),  // Fixed domain
  tickCount: 5,
)
```

### Grid

```dart
CartesianGrid(
  horizontal: true,
  vertical: false,
  strokeDasharray: [5, 5],
)
```

### Tooltip

```dart
ChartTooltip(
  trigger: TooltipTrigger.hover,  // or .click
  backgroundColor: Colors.white,
  borderColor: Colors.grey,
  contentBuilder: (context, payload) {
    return CustomTooltipContent(payload: payload);
  },
)
```

### Animations

```dart
CartesianChartWidget(
  isAnimationActive: true,
  animationDuration: Duration(milliseconds: 500),
  animationEasing: Curves.easeOutCubic,
)
```

## Z-Index Layering

Chart elements are layered in this order (lowest to highest):

1. Grid (z: 0)
2. Series (z: 100)
3. Axes (z: 200)
4. Reference elements (z: 300)
5. Cursor (z: 400)
6. Tooltip (z: 500)
7. Legend (z: 600)

## API Reference

See the [API documentation](https://your-docs-site.com) for detailed reference.

## Examples

Run the example app:

```bash
cd example
flutter run
```

## Contributing

Contributions are welcome! Please read the contributing guidelines before submitting PRs.

## License

MIT License - see LICENSE file for details.
