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
import '../state/models/interaction_state.dart';
import '../state/providers/chart_layout_provider.dart';
import '../state/providers/cartesian_scales_provider.dart';
import '../state/providers/line_points_provider.dart';
import '../state/providers/area_points_provider.dart';
import '../state/providers/bar_rects_provider.dart';
import '../state/controllers/chart_interaction_controller.dart';
import '../components/tooltip/tooltip.dart';

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
  final ChartTooltip? tooltip;

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
    this.tooltip,
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
          tooltip: widget.tooltip,
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

class _ChartContent extends StatefulWidget {
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
  final ChartTooltip? tooltip;

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
    this.tooltip,
  });

  @override
  State<_ChartContent> createState() => _ChartContentState();
}

class _ChartContentState extends State<_ChartContent> {
  ChartInteractionState _interactionState = ChartInteractionState.inactive;
  ChartInteractionController? _controller;

  @override
  void didUpdateWidget(_ChartContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller = null;
  }

  void _handleStateChanged(ChartInteractionState state) {
    setState(() {
      _interactionState = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    final layout = computeChartLayout(
      size: Size(widget.width, widget.height),
      margin: widget.margin,
    );

    final effectiveXAxes =
        widget.xAxes.isNotEmpty ? widget.xAxes : [const XAxis()];
    final effectiveYAxes =
        widget.yAxes.isNotEmpty ? widget.yAxes : [const YAxis()];

    final yDataKeys = <String>[
      ...widget.lineSeries.map((s) => s.dataKey),
      ...widget.areaSeries.map((s) => s.dataKey),
      ...widget.barSeries.map((s) => s.dataKey),
    ];

    final scales = buildCartesianScales(
      data: widget.dataSet,
      layout: layout,
      xAxes: effectiveXAxes,
      yAxes: effectiveYAxes,
      yDataKeys: yDataKeys,
    );

    final xDataKey = effectiveXAxes.first.dataKey;

    final linePointsMap = <String, List<LinePoint>>{};
    for (final series in widget.lineSeries) {
      linePointsMap[series.dataKey] = computeLinePoints(
        data: widget.dataSet,
        series: series,
        xScale: scales.xScale,
        yScale: scales.yScale,
        xDataKey: xDataKey,
      );
    }

    final baseY = scales.yScale(0);

    final areaPointsMap = <String, List<AreaPoint>>{};
    for (final series in widget.areaSeries) {
      areaPointsMap[series.dataKey] = computeAreaPoints(
        data: widget.dataSet,
        series: series,
        xScale: scales.xScale,
        yScale: scales.yScale,
        xDataKey: xDataKey,
        baseY: baseY,
      );
    }

    final barRectsMap = <String, List<BarRect>>{};
    final totalBars = widget.barSeries.length;
    for (int i = 0; i < widget.barSeries.length; i++) {
      final series = widget.barSeries[i];
      barRectsMap[series.dataKey] = computeBarRects(
        data: widget.dataSet,
        series: series,
        xScale: scales.xScale,
        yScale: scales.yScale,
        xDataKey: xDataKey,
        baseY: baseY,
        barIndex: i,
        totalBars: totalBars,
      );
    }

    final seriesInfoList = <SeriesInfo>[
      ...widget.lineSeries.map((s) => SeriesInfo(
            dataKey: s.dataKey,
            name: s.name,
            color: s.stroke,
          )),
      ...widget.areaSeries.map((s) => SeriesInfo(
            dataKey: s.dataKey,
            name: s.name,
            color: s.stroke,
          )),
      ...widget.barSeries.map((s) => SeriesInfo(
            dataKey: s.dataKey,
            name: s.name,
            color: s.fill,
          )),
    ];

    _controller ??= ChartInteractionController(
      data: widget.dataSet,
      layout: layout,
      xScale: scales.xScale,
      yScale: scales.yScale,
      xDataKey: xDataKey ?? 'name',
      seriesInfoList: seriesInfoList,
      onStateChanged: _handleStateChanged,
    );

    double? activeX;
    List<Offset?> activePoints = [];

    if (_interactionState.isActive && _interactionState.activeIndex != null) {
      final index = _interactionState.activeIndex!;
      final point = widget.dataSet[index];
      final xValue = point[xDataKey ?? 'name'];
      if (xValue != null) {
        activeX = scales.xScale(xValue) + (scales.xScale.bandwidth ?? 0) / 2;
      }

      activePoints = seriesInfoList
          .map((info) => _controller!.getPointCoordinate(index, info.dataKey))
          .toList();
    }

    final effectiveTooltip = widget.tooltip ?? const ChartTooltip();
    final tooltipEnabled = effectiveTooltip.enabled;
    final cursorConfig = effectiveTooltip.cursor;

    Widget chartWidget = Container(
      width: widget.width,
      height: widget.height,
      color: widget.backgroundColor,
      child: CustomPaint(
        size: Size(widget.width, widget.height),
        painter: CartesianChartPainter(
          layout: layout,
          grid: widget.grid,
          xAxes: effectiveXAxes,
          yAxes: effectiveYAxes,
          lineSeries: widget.lineSeries,
          areaSeries: widget.areaSeries,
          barSeries: widget.barSeries,
          xScale: scales.xScale,
          yScale: scales.yScale,
          linePointsMap: linePointsMap,
          areaPointsMap: areaPointsMap,
          barRectsMap: barRectsMap,
          cursorConfig: tooltipEnabled ? cursorConfig : null,
          activeX: activeX,
          activePoints: activePoints,
        ),
      ),
    );

    if (tooltipEnabled) {
      chartWidget = Stack(
        children: [
          chartWidget,
          if (_interactionState.tooltipPayload != null)
            Positioned.fill(
              child: TooltipOverlay(
                payload: _interactionState.tooltipPayload,
                config: effectiveTooltip,
                chartSize: Size(widget.width, widget.height),
                cursorPosition: _interactionState.activeCoordinate,
              ),
            ),
        ],
      );

      final trigger = effectiveTooltip.trigger;
      if (trigger == TooltipTrigger.hover) {
        chartWidget = MouseRegion(
          onHover: (event) => _controller?.onPointerMove(event.localPosition),
          onExit: (_) => _controller?.onPointerExit(),
          child: chartWidget,
        );
      } else if (trigger == TooltipTrigger.click) {
        chartWidget = GestureDetector(
          onTapDown: (details) =>
              _controller?.onPointerTap(details.localPosition),
          child: chartWidget,
        );
      }
    }

    return chartWidget;
  }
}
