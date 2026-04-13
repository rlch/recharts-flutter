import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../cartesian/axis/x_axis.dart';
import '../cartesian/axis/y_axis.dart';
import '../cartesian/cartesian_chart_widget.dart';
import '../cartesian/grid/cartesian_grid.dart';
import '../cartesian/series/area_series.dart';
import '../cartesian/series/bar_series.dart';
import '../cartesian/series/line_series.dart';
import '../components/responsive_chart_container.dart';
import '../components/tooltip/chart_tooltip.dart';
import '../components/tooltip/tooltip_types.dart';
import '../core/types/chart_data.dart';
import '../core/types/axis_types.dart';
import '../core/types/series_types.dart';
import '../funnel/funnel_chart.dart';
import '../funnel/funnel_series.dart';
import '../polar/axis/polar_angle_axis.dart';
import '../polar/axis/polar_radius_axis.dart';
import '../polar/grid/polar_grid.dart';
import '../polar/polar_chart_widget.dart';
import '../polar/series/pie_series.dart';
import '../polar/series/radar_series.dart';
import '../polar/series/radial_bar_series.dart';
import '../sankey/sankey_chart.dart';
import '../sankey/sankey_data.dart';
import '../state/models/chart_layout.dart';
import '../treemap/treemap_chart.dart';
import '../treemap/treemap_node.dart';

enum RechartsChartKind {
  area,
  line,
  bar,
  composed,
  scatter,
  pie,
  radar,
  radialBar,
  funnel,
  treemap,
  sankey,
  unknown,
}

class RechartsLikeSpec {
  final RechartsChartKind kind;
  final ChartData? cartesianData;
  final SankeyData? sankeyData;
  final TreemapNode? treemapData;
  final ChartMargin? margin;
  final StackOffsetType stackOffset;
  final List<XAxis> xAxes;
  final List<YAxis> yAxes;
  final CartesianGrid? cartesianGrid;
  final List<LineSeries> lineSeries;
  final List<AreaSeries> areaSeries;
  final List<BarSeries> barSeries;
  final PolarAngleAxis? angleAxis;
  final PolarRadiusAxis? radiusAxis;
  final PolarGrid? polarGrid;
  final List<PieSeries> pieSeries;
  final List<RadarSeries> radarSeries;
  final List<RadialBarSeries> radialBarSeries;
  final FunnelSeries? funnelSeries;
  final ChartTooltip? tooltip;
  final bool responsive;
  final double? aspectRatio;
  final String sourceChartTag;

  const RechartsLikeSpec({
    required this.kind,
    required this.sourceChartTag,
    this.cartesianData,
    this.sankeyData,
    this.treemapData,
    this.margin,
    this.stackOffset = StackOffsetType.none,
    this.xAxes = const [],
    this.yAxes = const [],
    this.cartesianGrid,
    this.lineSeries = const [],
    this.areaSeries = const [],
    this.barSeries = const [],
    this.angleAxis,
    this.radiusAxis,
    this.polarGrid,
    this.pieSeries = const [],
    this.radarSeries = const [],
    this.radialBarSeries = const [],
    this.funnelSeries,
    this.tooltip,
    this.responsive = false,
    this.aspectRatio,
  });

  Widget buildWidget() {
    Widget child;

    switch (kind) {
      case RechartsChartKind.area:
      case RechartsChartKind.line:
      case RechartsChartKind.bar:
      case RechartsChartKind.composed:
      case RechartsChartKind.scatter:
        child = CartesianChartWidget(
          data: cartesianData ?? const [],
          margin: margin,
          xAxes: xAxes,
          yAxes: yAxes,
          grid: cartesianGrid,
          lineSeries: lineSeries,
          areaSeries: areaSeries,
          barSeries: barSeries,
          stackOffset: stackOffset,
          tooltip: tooltip,
        );
        break;
      case RechartsChartKind.pie:
      case RechartsChartKind.radar:
      case RechartsChartKind.radialBar:
        child = PolarChartWidget(
          data: cartesianData ?? const [],
          angleAxis: angleAxis,
          radiusAxis: radiusAxis,
          grid: polarGrid,
          pieSeries: pieSeries,
          radarSeries: radarSeries,
          radialBarSeries: radialBarSeries,
          tooltip: tooltip,
        );
        break;
      case RechartsChartKind.funnel:
        child = FunnelChart(
          data: cartesianData ?? const [],
          series: funnelSeries ?? const FunnelSeries(dataKey: 'value'),
          tooltip: tooltip,
        );
        break;
      case RechartsChartKind.treemap:
        child = TreemapChart(
          data: treemapData ?? _buildFallbackTreemapNode(),
          tooltip: tooltip,
        );
        break;
      case RechartsChartKind.sankey:
        child = SankeyChart(
          data: sankeyData ?? _buildFallbackSankeyData(),
          tooltip: tooltip,
        );
        break;
      case RechartsChartKind.unknown:
        child = const _UnsupportedChartWidget(
          message: 'No supported Recharts chart tag was found.',
        );
        break;
    }

    if (responsive || aspectRatio != null) {
      return ResponsiveChartContainer(
        aspectRatio: aspectRatio,
        builder: (width, height) => child,
      );
    }

    return child;
  }
}

class RechartsConversionResult {
  final RechartsLikeSpec spec;
  final List<String> warnings;
  final List<String> comments;

  const RechartsConversionResult({
    required this.spec,
    this.warnings = const [],
    this.comments = const [],
  });

  Widget buildWidget() => spec.buildWidget();
}

class RechartsConverter {
  static const List<String> _chartTags = [
    'AreaChart',
    'LineChart',
    'BarChart',
    'ComposedChart',
    'ScatterChart',
    'PieChart',
    'RadarChart',
    'RadialBarChart',
    'FunnelChart',
    'Treemap',
    'SankeyChart',
  ];

  const RechartsConverter();

  RechartsConversionResult convert(String source, {Object? dataOverride}) {
    final warnings = <String>[];
    final comments = <String>[];

    final rootTag = _findRootChartTag(source);
    if (rootTag == null) {
      return RechartsConversionResult(
        spec: const RechartsLikeSpec(
          kind: RechartsChartKind.unknown,
          sourceChartTag: 'unknown',
        ),
        warnings: const ['Unable to locate a supported Recharts chart tag.'],
      );
    }

    final rootProps = _parseProps(rootTag.attributes);
    final kind = _kindForTag(rootTag.name);
    final children = _extractChildTags(rootTag.inner);

    final resolvedData = _resolveData(
      source: source,
      dataExpression: rootProps['data'],
      dataOverride: dataOverride,
      kind: kind,
      warnings: warnings,
    );

    final responsive =
        rootProps.containsKey('responsive') &&
        _parseBool(rootProps['responsive'], defaultValue: true);
    final rootStyle = _parseObjectLiteral(rootProps['style']);
    final aspectRatio = _parseNum(rootStyle['aspectRatio'])?.toDouble();
    final margin = _parseChartMargin(rootProps['margin']);

    final xAxes = <XAxis>[];
    final yAxes = <YAxis>[];
    CartesianGrid? cartesianGrid;
    final lineSeries = <LineSeries>[];
    final areaSeries = <AreaSeries>[];
    final barSeries = <BarSeries>[];
    PolarAngleAxis? angleAxis;
    PolarRadiusAxis? radiusAxis;
    PolarGrid? polarGrid;
    final pieSeries = <PieSeries>[];
    final radarSeries = <RadarSeries>[];
    final radialBarSeries = <RadialBarSeries>[];
    FunnelSeries? funnelSeries;
    ChartTooltip? tooltip;

    for (final child in children) {
      final props = _parseProps(child.attributes);
      switch (child.name) {
        case 'CartesianGrid':
          cartesianGrid = _buildCartesianGrid(props);
          break;
        case 'XAxis':
          xAxes.add(_buildXAxis(props));
          break;
        case 'YAxis':
          yAxes.add(_buildYAxis(props));
          break;
        case 'Tooltip':
          tooltip = _buildTooltip(props, warnings, comments);
          break;
        case 'Area':
          areaSeries.add(_buildAreaSeries(props));
          break;
        case 'Line':
          lineSeries.add(_buildLineSeries(props));
          break;
        case 'Bar':
          barSeries.add(_buildBarSeries(props));
          break;
        case 'PolarGrid':
          polarGrid = _buildPolarGrid(props);
          break;
        case 'PolarAngleAxis':
          angleAxis = _buildPolarAngleAxis(props);
          break;
        case 'PolarRadiusAxis':
          radiusAxis = _buildPolarRadiusAxis(props);
          break;
        case 'Pie':
          pieSeries.add(_buildPieSeries(props, child));
          break;
        case 'Radar':
          radarSeries.add(_buildRadarSeries(props));
          break;
        case 'RadialBar':
          radialBarSeries.add(_buildRadialBarSeries(props, child));
          break;
        case 'Funnel':
          funnelSeries = _buildFunnelSeries(props);
          break;
        case 'Scatter':
          warnings.add(
            'Scatter series parsing is recognized, but `CartesianChartWidget` does not render scatter points yet. The chart preview will omit them.',
          );
          break;
        case 'Legend':
        case 'Brush':
        case 'ReferenceLine':
        case 'ReferenceArea':
        case 'ReferenceDot':
        case 'Cell':
        case 'LabelList':
        case 'RechartsDevtools':
          warnings.add(
            'Ignoring unsupported child `<${child.name}>` during conversion.',
          );
          break;
        default:
          warnings.add(
            'Ignoring unknown child `<${child.name}>` during conversion.',
          );
      }
    }

    if (kind == RechartsChartKind.scatter) {
      warnings.add(
        'ScatterChart was converted to cartesian axes and tooltip only because scatter rendering is not yet wired into the Flutter cartesian widget.',
      );
    }

    final chartData = switch (resolvedData) {
      List<Map<String, dynamic>> list => list,
      _ => _generateFallbackCartesianData(kind, xAxes, [
        ...lineSeries.map((series) => series.dataKey),
        ...areaSeries.map((series) => series.dataKey),
        ...barSeries.map((series) => series.dataKey),
        if (kind == RechartsChartKind.scatter) 'y',
      ], warnings),
    };

    final spec = RechartsLikeSpec(
      kind: kind,
      sourceChartTag: rootTag.name,
      cartesianData: switch (kind) {
        RechartsChartKind.treemap || RechartsChartKind.sankey => null,
        _ => chartData,
      },
      sankeyData: kind == RechartsChartKind.sankey
          ? _resolveSankeyData(resolvedData, warnings)
          : null,
      treemapData: kind == RechartsChartKind.treemap
          ? _resolveTreemapData(resolvedData, warnings)
          : null,
      margin: margin,
      stackOffset: _parseStackOffset(rootProps['stackOffset']),
      xAxes: xAxes.isEmpty && _isCartesian(kind)
          ? [XAxis(dataKey: _defaultXAxisKeyFor(kind))]
          : xAxes,
      yAxes: yAxes.isEmpty && _isCartesian(kind) ? const [YAxis()] : yAxes,
      cartesianGrid: cartesianGrid,
      lineSeries: lineSeries,
      areaSeries: areaSeries,
      barSeries: barSeries,
      angleAxis: angleAxis,
      radiusAxis: radiusAxis,
      polarGrid: polarGrid,
      pieSeries: pieSeries.isEmpty && kind == RechartsChartKind.pie
          ? const [PieSeries(dataKey: 'value', nameKey: 'name')]
          : pieSeries,
      radarSeries: radarSeries,
      radialBarSeries: radialBarSeries,
      funnelSeries: funnelSeries,
      tooltip: tooltip,
      responsive: responsive,
      aspectRatio: aspectRatio,
    );

    return RechartsConversionResult(
      spec: spec,
      warnings: warnings.toSet().toList(),
      comments: comments,
    );
  }

  _ParsedTag? _findRootChartTag(String source) {
    _ParsedTag? earliest;

    for (final tag in _chartTags) {
      final match = RegExp(
        '<$tag\\b([\\s\\S]*?)(?:\\/\\>|>([\\s\\S]*?)<\\/$tag>)',
      ).firstMatch(source);
      if (match == null) continue;

      final parsed = _ParsedTag(
        name: tag,
        attributes: match.group(1) ?? '',
        inner: match.group(2) ?? '',
      );

      if (earliest == null ||
          match.start < source.indexOf('<${earliest.name}')) {
        earliest = parsed;
      }
    }

    return earliest;
  }

  List<_ParsedTag> _extractChildTags(String source) {
    final matches = RegExp(
      '<([A-Z][A-Za-z0-9]*)\\b([\\s\\S]*?)(?:\\/\\>|>([\\s\\S]*?)<\\/\\1>)',
    ).allMatches(source);

    return matches
        .map(
          (match) => _ParsedTag(
            name: match.group(1) ?? '',
            attributes: match.group(2) ?? '',
            inner: match.group(3) ?? '',
          ),
        )
        .toList();
  }

  Map<String, String> _parseProps(String input) {
    final props = <String, String>{};
    var index = 0;

    while (index < input.length) {
      while (index < input.length && input[index].trim().isEmpty) {
        index++;
      }
      if (index >= input.length) break;

      final start = index;
      while (index < input.length &&
          RegExp(r'[A-Za-z0-9_\-$:]').hasMatch(input[index])) {
        index++;
      }
      if (start == index) {
        index++;
        continue;
      }

      final name = input.substring(start, index);
      while (index < input.length && input[index].trim().isEmpty) {
        index++;
      }

      if (index >= input.length || input[index] != '=') {
        props[name] = 'true';
        continue;
      }

      index++;
      while (index < input.length && input[index].trim().isEmpty) {
        index++;
      }
      if (index >= input.length) {
        props[name] = '';
        break;
      }

      final current = input[index];
      if (current == '"' || current == '\'') {
        final quote = current;
        index++;
        final valueStart = index;
        while (index < input.length && input[index] != quote) {
          index++;
        }
        props[name] = input.substring(
          valueStart,
          math.min(index, input.length),
        );
        if (index < input.length) index++;
        continue;
      }

      if (current == '{') {
        var depth = 1;
        index++;
        final valueStart = index;
        while (index < input.length && depth > 0) {
          final char = input[index];
          if (char == '{') {
            depth++;
          } else if (char == '}') {
            depth--;
          } else if (char == '"' || char == '\'') {
            final quote = char;
            index++;
            while (index < input.length && input[index] != quote) {
              if (input[index] == r'\') index++;
              index++;
            }
          }
          index++;
        }
        props[name] = input
            .substring(valueStart, math.max(valueStart, index - 1))
            .trim();
        continue;
      }

      final valueStart = index;
      while (index < input.length && input[index].trim().isNotEmpty) {
        index++;
      }
      props[name] = input.substring(valueStart, index);
    }

    return props;
  }

  dynamic _resolveData({
    required String source,
    required String? dataExpression,
    required Object? dataOverride,
    required RechartsChartKind kind,
    required List<String> warnings,
  }) {
    if (dataOverride != null) {
      return dataOverride;
    }

    final expression = dataExpression?.trim();
    if (expression == null || expression.isEmpty) {
      warnings.add(
        'No explicit data prop was found. Generated sample data will be used.',
      );
      return null;
    }

    if (expression.startsWith('[') || expression.startsWith('{')) {
      return _parseJsLiteral(expression, warnings);
    }

    final assignmentPattern = RegExp(
      '(?:const|let|var)\\s+$expression\\s*=\\s*',
      multiLine: true,
    );
    final assignment = assignmentPattern.firstMatch(source);
    if (assignment == null) {
      warnings.add(
        'Could not resolve `$expression` from the snippet. Generated sample data will be used.',
      );
      return null;
    }

    final literal = _extractAssignedLiteral(source, assignment.end);
    if (literal == null) {
      warnings.add(
        'Found `$expression`, but could not extract its literal value. Generated sample data will be used.',
      );
      return null;
    }

    return _parseJsLiteral(literal, warnings);
  }

  String? _extractAssignedLiteral(String source, int startIndex) {
    var index = startIndex;
    while (index < source.length && source[index].trim().isEmpty) {
      index++;
    }
    if (index >= source.length) return null;

    final opening = source[index];
    if (opening != '[' && opening != '{') return null;
    final closing = opening == '[' ? ']' : '}';
    var depth = 0;
    final literalStart = index;

    while (index < source.length) {
      final char = source[index];
      if (char == opening) {
        depth++;
      } else if (char == closing) {
        depth--;
        if (depth == 0) {
          return source.substring(literalStart, index + 1);
        }
      } else if (char == '"' || char == '\'') {
        final quote = char;
        index++;
        while (index < source.length && source[index] != quote) {
          if (source[index] == r'\') index++;
          index++;
        }
      }
      index++;
    }

    return null;
  }

  dynamic _parseJsLiteral(String input, List<String> warnings) {
    try {
      var normalized = input;
      normalized = normalized.replaceAll(RegExp(r'//.*$', multiLine: true), '');
      normalized = normalized.replaceAll(RegExp(r'/\*[\s\S]*?\*/'), '');
      normalized = normalized.replaceAllMapped(
        RegExp(r'([{,]\s*)([A-Za-z_][A-Za-z0-9_\-]*)(\s*:)'),
        (match) => '${match.group(1)}"${match.group(2)}"${match.group(3)}',
      );
      normalized = normalized.replaceAll('\'', '"');
      normalized = normalized.replaceAllMapped(
        RegExp(r',(\s*[}\]])'),
        (match) => match.group(1)!,
      );
      return jsonDecode(normalized);
    } catch (_) {
      warnings.add(
        'Failed to parse a JavaScript data literal. Generated sample data will be used.',
      );
      return null;
    }
  }

  CartesianGrid _buildCartesianGrid(Map<String, String> props) {
    return CartesianGrid(
      horizontal: _parseBool(props['horizontal'], defaultValue: true),
      vertical: _parseBool(props['vertical'], defaultValue: true),
      strokeDasharray: _parseDoubleList(props['strokeDasharray']),
      stroke: _parseColor(props['stroke']) ?? const Color(0xFFCCCCCC),
      strokeWidth: _parseNum(props['strokeWidth'])?.toDouble() ?? 1,
      strokeOpacity: _parseNum(props['strokeOpacity'])?.toDouble() ?? 1,
    );
  }

  XAxis _buildXAxis(Map<String, String> props) {
    return XAxis(
      dataKey: _parseStringLiteral(props['dataKey']),
      id: _parseStringLiteral(props['xAxisId']) ?? '0',
      tickCount: _parseInt(props['tickCount']),
      ticks: _parseLiteralList(props['ticks']),
      domain: _parseLiteralList(props['domain']),
      type: _parseScaleType(props['type'], fallback: ScaleType.category),
      hide: _parseBool(props['hide']),
      angle: _parseNum(props['angle'])?.toDouble(),
      unit: _parseStringLiteral(props['unit']),
      name: _parseStringLiteral(props['name']),
      mirror: _parseBool(props['mirror']),
      reversed: _parseBool(props['reversed']),
      height: _parseNum(props['height'])?.toDouble(),
      tickMargin: _parseNum(props['tickMargin'])?.toDouble(),
      interval: _parseInt(props['interval']),
    );
  }

  YAxis _buildYAxis(Map<String, String> props) {
    return YAxis(
      dataKey: _parseStringLiteral(props['dataKey']),
      id: _parseStringLiteral(props['yAxisId']) ?? '0',
      tickCount: _parseInt(props['tickCount']),
      ticks: _parseLiteralList(props['ticks']),
      domain: _parseLiteralList(props['domain']),
      type: _parseScaleType(props['type'], fallback: ScaleType.linear),
      hide: _parseBool(props['hide']),
      angle: _parseNum(props['angle'])?.toDouble(),
      unit: _parseStringLiteral(props['unit']),
      name: _parseStringLiteral(props['name']),
      mirror: _parseBool(props['mirror']),
      reversed: _parseBool(props['reversed']),
      width: _parseNum(props['width'])?.toDouble(),
      tickMargin: _parseNum(props['tickMargin'])?.toDouble(),
      interval: _parseInt(props['interval']),
    );
  }

  ChartTooltip _buildTooltip(
    Map<String, String> props,
    List<String> warnings,
    List<String> comments,
  ) {
    final content = props['content'];
    if (content != null && content.trim().isNotEmpty) {
      comments.add('// Original Recharts tooltip content: $content');
      warnings.add(
        'Custom tooltip functions are preserved as comments only. The preview uses the default Flutter tooltip.',
      );
    }

    return ChartTooltip(
      trigger: _parseTooltipTrigger(props['trigger']),
      cursor: _buildCursorConfig(props['cursor']),
      separator: _parseStringLiteral(props['separator']) ?? ' : ',
      showLabel: _parseBool(props['label'], defaultValue: true),
      showSeriesName: _parseBool(props['showSeriesName'], defaultValue: true),
    );
  }

  CursorConfig _buildCursorConfig(String? raw) {
    final map = _parseObjectLiteral(raw);
    return CursorConfig(
      show: _parseBool(map['show'], defaultValue: true),
      color:
          _parseColor(map['stroke']) ??
          _parseColor(map['fill']) ??
          const Color(0xFF999999),
      strokeWidth: _parseNum(map['strokeWidth'])?.toDouble() ?? 1,
      dashPattern: _parseDoubleList(map['strokeDasharray']) ?? const [4, 4],
    );
  }

  AreaSeries _buildAreaSeries(Map<String, String> props) {
    return AreaSeries(
      dataKey: _parseStringLiteral(props['dataKey']) ?? 'value',
      name: _parseStringLiteral(props['name']),
      stroke: _parseColor(props['stroke']) ?? const Color(0xFF8884D8),
      fill: _parseColor(props['fill']) ?? const Color(0xFF8884D8),
      fillOpacity: _parseNum(props['fillOpacity'])?.toDouble() ?? 0.6,
      strokeWidth: _parseNum(props['strokeWidth'])?.toDouble() ?? 2,
      curveType: _parseCurveType(props['type']),
      connectNulls: _parseBool(props['connectNulls']),
      stackId: _parseStringLiteral(props['stackId']),
      xAxisId: _parseStringLiteral(props['xAxisId']),
      yAxisId: _parseStringLiteral(props['yAxisId']),
    );
  }

  LineSeries _buildLineSeries(Map<String, String> props) {
    return LineSeries(
      dataKey: _parseStringLiteral(props['dataKey']) ?? 'value',
      name: _parseStringLiteral(props['name']),
      stroke: _parseColor(props['stroke']) ?? const Color(0xFF8884D8),
      strokeWidth: _parseNum(props['strokeWidth'])?.toDouble() ?? 2,
      strokeDasharray: _parseDoubleList(props['strokeDasharray']),
      curveType: _parseCurveType(props['type']),
      connectNulls: _parseBool(props['connectNulls']),
      dot: _parseBool(props['dot'], defaultValue: true),
      activeDot: _parseBool(props['activeDot'], defaultValue: true),
      xAxisId: _parseStringLiteral(props['xAxisId']),
      yAxisId: _parseStringLiteral(props['yAxisId']),
    );
  }

  BarSeries _buildBarSeries(Map<String, String> props) {
    return BarSeries(
      dataKey: _parseStringLiteral(props['dataKey']) ?? 'value',
      name: _parseStringLiteral(props['name']),
      fill: _parseColor(props['fill']) ?? const Color(0xFF8884D8),
      fillOpacity: _parseNum(props['fillOpacity'])?.toDouble() ?? 1,
      stroke: _parseColor(props['stroke']),
      strokeWidth: _parseNum(props['strokeWidth'])?.toDouble() ?? 0,
      radius: _parseNum(props['radius'])?.toDouble(),
      stackId: _parseStringLiteral(props['stackId']),
      xAxisId: _parseStringLiteral(props['xAxisId']),
      yAxisId: _parseStringLiteral(props['yAxisId']),
    );
  }

  PolarGrid _buildPolarGrid(Map<String, String> props) {
    return PolarGrid(
      gridType:
          (_parseStringLiteral(props['gridType']) ?? 'polygon') == 'circle'
          ? PolarGridType.circle
          : PolarGridType.polygon,
      strokeColor: _parseColor(props['stroke']) ?? const Color(0xFFCCCCCC),
      strokeWidth: _parseNum(props['strokeWidth'])?.toDouble() ?? 1,
      strokeDashArray: _parseDoubleList(props['strokeDasharray']),
      showRadialLines: _parseBool(props['radialLines'], defaultValue: true),
    );
  }

  PolarAngleAxis _buildPolarAngleAxis(Map<String, String> props) {
    return PolarAngleAxis(
      dataKey: _parseStringLiteral(props['dataKey']),
      hide: _parseBool(props['hide']),
    );
  }

  PolarRadiusAxis _buildPolarRadiusAxis(Map<String, String> props) {
    return PolarRadiusAxis(
      angle: _parseNum(props['angle'])?.toDouble() ?? 90,
      domain: _parseNumList(props['domain']),
      tickCount: _parseInt(props['tickCount']) ?? 5,
      hide: _parseBool(props['hide']),
    );
  }

  PieSeries _buildPieSeries(Map<String, String> props, _ParsedTag tag) {
    final cellColors = _extractChildTags(tag.inner)
        .where((child) => child.name == 'Cell')
        .map((cell) => _parseColor(_parseProps(cell.attributes)['fill']))
        .whereType<Color>()
        .toList();

    return PieSeries(
      dataKey: _parseStringLiteral(props['dataKey']) ?? 'value',
      nameKey: _parseStringLiteral(props['nameKey']) ?? 'name',
      name: _parseStringLiteral(props['name']),
      innerRadius: _parseRadius(props['innerRadius']) ?? 0,
      outerRadius: _parseRadius(props['outerRadius']) ?? 80,
      startAngle: _parseNum(props['startAngle'])?.toDouble() ?? 0,
      endAngle: _parseNum(props['endAngle'])?.toDouble() ?? 360,
      paddingAngle: _parseNum(props['paddingAngle'])?.toDouble() ?? 0,
      stroke: _parseColor(props['stroke']),
      strokeWidth: _parseNum(props['strokeWidth'])?.toDouble() ?? 1,
      label: _parseBool(props['label']),
      colors: cellColors.isEmpty ? null : cellColors,
    );
  }

  RadarSeries _buildRadarSeries(Map<String, String> props) {
    return RadarSeries(
      dataKey: _parseStringLiteral(props['dataKey']) ?? 'value',
      name: _parseStringLiteral(props['name']),
      fill: _parseColor(props['fill']) ?? const Color(0xFF8884D8),
      stroke: _parseColor(props['stroke']) ?? const Color(0xFF8884D8),
      fillOpacity: _parseNum(props['fillOpacity'])?.toDouble() ?? 0.6,
      strokeWidth: _parseNum(props['strokeWidth'])?.toDouble() ?? 2,
      dot: _parseBool(props['dot'], defaultValue: true),
    );
  }

  RadialBarSeries _buildRadialBarSeries(
    Map<String, String> props,
    _ParsedTag tag,
  ) {
    final cellColors = _extractChildTags(tag.inner)
        .where((child) => child.name == 'Cell')
        .map((cell) => _parseColor(_parseProps(cell.attributes)['fill']))
        .whereType<Color>()
        .toList();

    return RadialBarSeries(
      dataKey: _parseStringLiteral(props['dataKey']) ?? 'value',
      nameKey: _parseStringLiteral(props['nameKey']) ?? 'name',
      name: _parseStringLiteral(props['name']),
      innerRadius: _parseRadius(props['innerRadius']) ?? 30,
      outerRadius: _parseRadius(props['outerRadius']) ?? 100,
      startAngle: _parseNum(props['startAngle'])?.toDouble() ?? 90,
      endAngle: _parseNum(props['endAngle'])?.toDouble() ?? -270,
      cornerRadius: _parseNum(props['cornerRadius'])?.toDouble() ?? 0,
      background: _parseColor(props['background']),
      colors: cellColors.isEmpty ? null : cellColors,
    );
  }

  FunnelSeries _buildFunnelSeries(Map<String, String> props) {
    return FunnelSeries(
      dataKey: _parseStringLiteral(props['dataKey']) ?? 'value',
      nameKey: _parseStringLiteral(props['nameKey']) ?? 'name',
      name: _parseStringLiteral(props['name']),
      shape: (_parseStringLiteral(props['shape']) ?? 'trapezoid') == 'rectangle'
          ? FunnelShape.rectangle
          : FunnelShape.trapezoid,
      stroke: _parseColor(props['stroke']),
      strokeWidth: _parseNum(props['strokeWidth'])?.toDouble() ?? 1,
      label: _parseBool(props['label'], defaultValue: true),
      reversed: _parseBool(props['reversed']),
    );
  }

  SankeyData? _resolveSankeyData(dynamic resolvedData, List<String> warnings) {
    if (resolvedData is Map<String, dynamic>) {
      return SankeyData.fromMap(resolvedData);
    }

    warnings.add(
      'Sankey charts require a `{ nodes, links }` data object. Generated sample data will be used.',
    );
    return null;
  }

  TreemapNode? _resolveTreemapData(
    dynamic resolvedData,
    List<String> warnings,
  ) {
    if (resolvedData is Map<String, dynamic>) {
      return TreemapNode.fromMap(resolvedData);
    }

    warnings.add(
      'Treemap charts require a hierarchical object. Generated sample data will be used.',
    );
    return null;
  }

  ChartMargin? _parseChartMargin(String? raw) {
    final map = _parseObjectLiteral(raw);
    if (map.isEmpty) return null;

    return ChartMargin(
      top: _parseNum(map['top'])?.toDouble() ?? 5,
      right: _parseNum(map['right'])?.toDouble() ?? 5,
      bottom: _parseNum(map['bottom'])?.toDouble() ?? 30,
      left: _parseNum(map['left'])?.toDouble() ?? 60,
    );
  }

  ScaleType _parseScaleType(String? raw, {required ScaleType fallback}) {
    return switch (_parseStringLiteral(raw)) {
      'number' => ScaleType.linear,
      'linear' => ScaleType.linear,
      'point' => ScaleType.point,
      'band' => ScaleType.band,
      _ => fallback,
    };
  }

  CurveType _parseCurveType(String? raw) {
    return switch (_parseStringLiteral(raw)) {
      'monotone' || 'monotoneX' => CurveType.monotone,
      'step' => CurveType.step,
      'basis' => CurveType.basis,
      'natural' => CurveType.natural,
      _ => CurveType.linear,
    };
  }

  TooltipTrigger _parseTooltipTrigger(String? raw) {
    return switch (_parseStringLiteral(raw)) {
      'click' => TooltipTrigger.click,
      'none' => TooltipTrigger.none,
      _ => TooltipTrigger.hover,
    };
  }

  StackOffsetType _parseStackOffset(String? raw) {
    return switch (_parseStringLiteral(raw)) {
      'expand' => StackOffsetType.expand,
      'sign' => StackOffsetType.sign,
      'silhouette' => StackOffsetType.silhouette,
      'wiggle' => StackOffsetType.wiggle,
      _ => StackOffsetType.none,
    };
  }

  RechartsChartKind _kindForTag(String tag) {
    return switch (tag) {
      'AreaChart' => RechartsChartKind.area,
      'LineChart' => RechartsChartKind.line,
      'BarChart' => RechartsChartKind.bar,
      'ComposedChart' => RechartsChartKind.composed,
      'ScatterChart' => RechartsChartKind.scatter,
      'PieChart' => RechartsChartKind.pie,
      'RadarChart' => RechartsChartKind.radar,
      'RadialBarChart' => RechartsChartKind.radialBar,
      'FunnelChart' => RechartsChartKind.funnel,
      'Treemap' => RechartsChartKind.treemap,
      'SankeyChart' => RechartsChartKind.sankey,
      _ => RechartsChartKind.unknown,
    };
  }

  bool _isCartesian(RechartsChartKind kind) {
    return switch (kind) {
      RechartsChartKind.area ||
      RechartsChartKind.line ||
      RechartsChartKind.bar ||
      RechartsChartKind.composed ||
      RechartsChartKind.scatter => true,
      _ => false,
    };
  }

  String _defaultXAxisKeyFor(RechartsChartKind kind) {
    return kind == RechartsChartKind.scatter ? 'x' : 'name';
  }

  List<Map<String, dynamic>> _generateFallbackCartesianData(
    RechartsChartKind kind,
    List<XAxis> xAxes,
    List<String> seriesKeys,
    List<String> warnings,
  ) {
    warnings.add('Generated fallback sample data for preview.');

    final xKey = xAxes.isNotEmpty
        ? (xAxes.first.dataKey ?? _defaultXAxisKeyFor(kind))
        : _defaultXAxisKeyFor(kind);
    final keys = seriesKeys.where((key) => key.isNotEmpty).toSet().toList();
    if (keys.isEmpty) {
      if (kind == RechartsChartKind.scatter) {
        keys.add('y');
      } else {
        keys.add('value');
      }
    }

    return List.generate(6, (index) {
      final row = <String, dynamic>{
        xKey: kind == RechartsChartKind.scatter
            ? (index + 1) * 10
            : ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'][index],
      };
      for (var seriesIndex = 0; seriesIndex < keys.length; seriesIndex++) {
        row[keys[seriesIndex]] = (index + 1) * (seriesIndex + 2) * 12;
      }
      if (kind == RechartsChartKind.scatter) {
        row['x'] ??= (index + 1) * 15;
        row['y'] ??= ((index + 2) * 18) + (index.isEven ? 12 : 0);
        row['z'] = (index + 1) * 40;
      }
      return row;
    });
  }

  Map<String, String> _parseObjectLiteral(String? raw) {
    if (raw == null || raw.trim().isEmpty) return const {};

    var input = raw.trim();
    if (input.startsWith('{') && input.endsWith('}')) {
      input = input.substring(1, input.length - 1).trim();
    }
    if (input.isEmpty) return const {};

    final result = <String, String>{};
    var index = 0;
    while (index < input.length) {
      while (index < input.length &&
          (input[index].trim().isEmpty || input[index] == ',')) {
        index++;
      }
      if (index >= input.length) break;

      final keyStart = index;
      while (index < input.length &&
          RegExp(r'[A-Za-z0-9_\-$]').hasMatch(input[index])) {
        index++;
      }
      final key = input.substring(keyStart, index).trim();
      while (index < input.length &&
          (input[index].trim().isEmpty || input[index] == ':')) {
        index++;
      }
      final valueStart = index;
      var braceDepth = 0;
      var bracketDepth = 0;
      String? quote;
      while (index < input.length) {
        final char = input[index];
        if (quote != null) {
          if (char == quote) quote = null;
        } else if (char == '"' || char == '\'') {
          quote = char;
        } else if (char == '{') {
          braceDepth++;
        } else if (char == '}') {
          if (braceDepth == 0) break;
          braceDepth--;
        } else if (char == '[') {
          bracketDepth++;
        } else if (char == ']') {
          bracketDepth--;
        } else if (char == ',' && braceDepth == 0 && bracketDepth == 0) {
          break;
        }
        index++;
      }
      result[key] = input.substring(valueStart, index).trim();
      if (index < input.length && input[index] == ',') index++;
    }

    return result;
  }

  List<dynamic>? _parseLiteralList(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final input = raw.trim();
    if (!input.startsWith('[') || !input.endsWith(']')) return null;
    final body = input.substring(1, input.length - 1).trim();
    if (body.isEmpty) return [];

    final parts = <String>[];
    final buffer = StringBuffer();
    var braceDepth = 0;
    var bracketDepth = 0;
    String? quote;

    for (final char in body.split('')) {
      if (quote != null) {
        if (char == quote) quote = null;
        buffer.write(char);
        continue;
      }

      if (char == '"' || char == '\'') {
        quote = char;
        buffer.write(char);
        continue;
      }
      if (char == '{') braceDepth++;
      if (char == '}') braceDepth--;
      if (char == '[') bracketDepth++;
      if (char == ']') bracketDepth--;

      if (char == ',' && braceDepth == 0 && bracketDepth == 0) {
        parts.add(buffer.toString().trim());
        buffer.clear();
        continue;
      }
      buffer.write(char);
    }

    if (buffer.isNotEmpty) {
      parts.add(buffer.toString().trim());
    }

    return parts.map(_parseScalar).toList();
  }

  List<double>? _parseDoubleList(String? raw) {
    final list = _parseLiteralList(raw);
    return list
        ?.map((value) => _parseNum(value.toString())?.toDouble() ?? 0)
        .toList();
  }

  List<num>? _parseNumList(String? raw) {
    final list = _parseLiteralList(raw);
    return list?.map((value) => _parseNum(value.toString()) ?? 0).toList();
  }

  dynamic _parseScalar(String input) {
    final trimmed = input.trim();
    final stringValue = _parseStringLiteral(trimmed);
    if (stringValue != null &&
        (trimmed.startsWith('"') || trimmed.startsWith('\''))) {
      return stringValue;
    }
    if (trimmed == 'true') return true;
    if (trimmed == 'false') return false;
    if (trimmed == 'null') return null;
    return _parseNum(trimmed) ?? stringValue ?? trimmed;
  }

  String? _parseStringLiteral(String? raw) {
    if (raw == null) return null;
    final trimmed = raw.trim();
    if (trimmed.startsWith('"') && trimmed.endsWith('"')) {
      return trimmed.substring(1, trimmed.length - 1);
    }
    if (trimmed.startsWith('\'') && trimmed.endsWith('\'')) {
      return trimmed.substring(1, trimmed.length - 1);
    }
    return trimmed;
  }

  bool _parseBool(String? raw, {bool defaultValue = false}) {
    if (raw == null) return defaultValue;
    final value = _parseStringLiteral(raw)?.trim();
    return switch (value) {
      'true' => true,
      'false' => false,
      _ => defaultValue,
    };
  }

  num? _parseNum(String? raw) {
    if (raw == null) return null;
    final cleaned = _parseStringLiteral(
      raw,
    )?.replaceAll(RegExp(r'px|%|vh|vw'), '').trim();
    return num.tryParse(cleaned ?? '');
  }

  int? _parseInt(String? raw) => _parseNum(raw)?.toInt();

  double? _parseRadius(String? raw) => _parseNum(raw)?.toDouble();

  Color? _parseColor(String? raw) {
    final value = _parseStringLiteral(raw)?.trim().toLowerCase();
    if (value == null || value.isEmpty) return null;

    if (value.startsWith('#')) {
      var hex = value.substring(1);
      if (hex.length == 3) {
        hex = hex.split('').map((char) => '$char$char').join();
      }
      if (hex.length == 6) {
        hex = 'ff$hex';
      }
      if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
    }

    final rgba = RegExp(r'rgba?\(([^)]+)\)').firstMatch(value);
    if (rgba != null) {
      final parts = rgba
          .group(1)!
          .split(',')
          .map((part) => part.trim())
          .toList();
      if (parts.length >= 3) {
        final r = int.tryParse(parts[0]) ?? 0;
        final g = int.tryParse(parts[1]) ?? 0;
        final b = int.tryParse(parts[2]) ?? 0;
        final alpha = parts.length > 3
            ? ((double.tryParse(parts[3]) ?? 1) * 255).round()
            : 255;
        return Color.fromARGB(alpha, r, g, b);
      }
    }

    return switch (value) {
      'white' => const Color(0xFFFFFFFF),
      'black' => const Color(0xFF000000),
      'gray' || 'grey' => const Color(0xFF808080),
      'red' => const Color(0xFFFF0000),
      'green' => const Color(0xFF00AA00),
      'blue' => const Color(0xFF0000FF),
      'transparent' => const Color(0x00000000),
      _ => null,
    };
  }
}

class _ParsedTag {
  final String name;
  final String attributes;
  final String inner;

  const _ParsedTag({
    required this.name,
    required this.attributes,
    required this.inner,
  });
}

class _UnsupportedChartWidget extends StatelessWidget {
  final String message;

  const _UnsupportedChartWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message, textAlign: TextAlign.center));
  }
}

TreemapNode _buildFallbackTreemapNode() {
  return const TreemapNode(
    name: 'Root',
    children: [
      TreemapNode(name: 'Group A', value: 420),
      TreemapNode(
        name: 'Group B',
        children: [
          TreemapNode(name: 'B1', value: 210),
          TreemapNode(name: 'B2', value: 180),
        ],
      ),
    ],
  );
}

SankeyData _buildFallbackSankeyData() {
  return const SankeyData(
    nodes: [
      SankeyNode(id: '0', name: 'Visit'),
      SankeyNode(id: '1', name: 'Signup'),
      SankeyNode(id: '2', name: 'Purchase'),
    ],
    links: [
      SankeyLink(source: '0', target: '1', value: 120),
      SankeyLink(source: '1', target: '2', value: 48),
    ],
  );
}
