import 'package:flutter/material.dart';

import '../core/types/chart_data.dart';
import 'axis/x_axis.dart';
import 'axis/y_axis.dart';
import 'grid/cartesian_grid.dart';
import 'series/line_series.dart';
import 'series/area_series.dart';
import 'series/bar_series.dart';
import 'painters/cartesian_chart_painter.dart';
import '../state/models/chart_layout.dart';
import '../state/models/computed_data.dart';
import '../state/providers/chart_layout_provider.dart';
import '../state/providers/cartesian_scales_provider.dart';
import '../state/providers/line_points_provider.dart';
import '../state/providers/area_points_provider.dart';
import '../state/providers/bar_rects_provider.dart';

sealed class CartesianChild {}

class CartesianChartWidget extends StatefulWidget {
  final double? width;
  final double? height;
  final ChartData data;
  final ChartMargin? margin;
  final List<XAxis> xAxes;
  final List<YAxis> yAxes;
  final CartesianGrid? grid;
  final List<LineSeries> lineSeries;
  final List<AreaSeries> areaSeries;
  final List<BarSeries> barSeries;
  final Color? backgroundColor;

  const CartesianChartWidget({
    super.key,
    this.width,
    this.height,
    required this.data,
    this.margin,
    this.xAxes = const [],
    this.yAxes = const [],
    this.grid,
    this.lineSeries = const [],
    this.areaSeries = const [],
    this.barSeries = const [],
    this.backgroundColor,
  });

  @override
  State<CartesianChartWidget> createState() => _CartesianChartWidgetState();
}

class _CartesianChartWidgetState extends State<CartesianChartWidget> {
  late ChartDataSet _dataSet;

  @override
  void initState() {
    super.initState();
    _dataSet = ChartDataSet(widget.data);
  }

  @override
  void didUpdateWidget(CartesianChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data) {
      _dataSet = ChartDataSet(widget.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child = LayoutBuilder(
      builder: (context, constraints) {
        final width = widget.width ?? constraints.maxWidth;
        final height = widget.height ?? constraints.maxHeight;

        if (width <= 0 || height <= 0 || width.isInfinite || height.isInfinite) {
          return const SizedBox.shrink();
        }

        return _ChartContent(
          width: width,
          height: height,
          dataSet: _dataSet,
          margin: widget.margin,
          xAxes: widget.xAxes,
          yAxes: widget.yAxes,
          grid: widget.grid,
          lineSeries: widget.lineSeries,
          areaSeries: widget.areaSeries,
          barSeries: widget.barSeries,
          backgroundColor: widget.backgroundColor,
        );
      },
    );

    if (widget.width != null || widget.height != null) {
      child = SizedBox(
        width: widget.width,
        height: widget.height,
        child: child,
      );
    }

    return child;
  }
}

class _ChartContent extends StatelessWidget {
  final double width;
  final double height;
  final ChartDataSet dataSet;
  final ChartMargin? margin;
  final List<XAxis> xAxes;
  final List<YAxis> yAxes;
  final CartesianGrid? grid;
  final List<LineSeries> lineSeries;
  final List<AreaSeries> areaSeries;
  final List<BarSeries> barSeries;
  final Color? backgroundColor;

  const _ChartContent({
    required this.width,
    required this.height,
    required this.dataSet,
    this.margin,
    required this.xAxes,
    required this.yAxes,
    this.grid,
    required this.lineSeries,
    required this.areaSeries,
    required this.barSeries,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final layout = computeChartLayout(
      size: Size(width, height),
      margin: margin,
    );

    final effectiveXAxes = xAxes.isNotEmpty ? xAxes : [const XAxis()];
    final effectiveYAxes = yAxes.isNotEmpty ? yAxes : [const YAxis()];

    final yDataKeys = <String>[
      ...lineSeries.map((s) => s.dataKey),
      ...areaSeries.map((s) => s.dataKey),
      ...barSeries.map((s) => s.dataKey),
    ];

    final scales = buildCartesianScales(
      data: dataSet,
      layout: layout,
      xAxes: effectiveXAxes,
      yAxes: effectiveYAxes,
      yDataKeys: yDataKeys,
    );

    final xDataKey = effectiveXAxes.first.dataKey;

    final linePointsMap = <String, List<LinePoint>>{};
    for (final series in lineSeries) {
      linePointsMap[series.dataKey] = computeLinePoints(
        data: dataSet,
        series: series,
        xScale: scales.xScale,
        yScale: scales.yScale,
        xDataKey: xDataKey,
      );
    }

    final baseY = scales.yScale(0);

    final areaPointsMap = <String, List<AreaPoint>>{};
    for (final series in areaSeries) {
      areaPointsMap[series.dataKey] = computeAreaPoints(
        data: dataSet,
        series: series,
        xScale: scales.xScale,
        yScale: scales.yScale,
        xDataKey: xDataKey,
        baseY: baseY,
      );
    }

    final barRectsMap = <String, List<BarRect>>{};
    final totalBars = barSeries.length;
    for (int i = 0; i < barSeries.length; i++) {
      final series = barSeries[i];
      barRectsMap[series.dataKey] = computeBarRects(
        data: dataSet,
        series: series,
        xScale: scales.xScale,
        yScale: scales.yScale,
        xDataKey: xDataKey,
        baseY: baseY,
        barIndex: i,
        totalBars: totalBars,
      );
    }

    return Container(
      width: width,
      height: height,
      color: backgroundColor,
      child: CustomPaint(
        size: Size(width, height),
        painter: CartesianChartPainter(
          layout: layout,
          grid: grid,
          xAxes: effectiveXAxes,
          yAxes: effectiveYAxes,
          lineSeries: lineSeries,
          areaSeries: areaSeries,
          barSeries: barSeries,
          xScale: scales.xScale,
          yScale: scales.yScale,
          linePointsMap: linePointsMap,
          areaPointsMap: areaPointsMap,
          barRectsMap: barRectsMap,
        ),
      ),
    );
  }
}
