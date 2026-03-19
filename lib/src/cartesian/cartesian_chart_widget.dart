import 'package:flutter/material.dart';

import '../core/types/chart_data.dart';
import '../core/types/axis_types.dart';
import '../core/animation/easing_curves.dart';
import 'axis/x_axis.dart';
import 'axis/y_axis.dart';
import 'grid/cartesian_grid.dart';
import 'reference/reference_line.dart';
import 'series/line_series.dart';
import 'series/area_series.dart';
import 'series/bar_series.dart';
import 'painters/animated_cartesian_chart_painter.dart';
import '../state/models/chart_layout.dart';
import '../state/models/computed_data.dart';
import '../state/models/interaction_state.dart';
import '../state/providers/chart_layout_provider.dart';
import '../state/providers/cartesian_scales_provider.dart';
import '../state/providers/line_points_provider.dart';
import '../state/providers/area_points_provider.dart';
import '../state/providers/bar_rects_provider.dart';
import '../state/controllers/chart_interaction_controller.dart';
import '../state/controllers/chart_animation_controller.dart';
import '../state/sync/chart_sync_bus.dart';
import '../components/tooltip/tooltip.dart';

sealed class CartesianChild {}

/// A cartesian chart widget that supports line, area, and bar series.
///
/// ## Synchronization
/// Charts with the same [syncId] share tooltip/interaction state.
/// When hovering on one chart, all synced charts show the same index.
///
/// ## Example
/// ```dart
/// CartesianChartWidget(
///   syncId: 'group1',
///   data: myData,
///   lineSeries: [LineSeries(dataKey: 'value')],
/// )
/// ```
class CartesianChartWidget extends StatefulWidget {
  /// Fixed width of the chart. If null, uses available width from parent.
  final double? width;

  /// Fixed height of the chart. If null, uses available height from parent.
  final double? height;

  /// The data to display in the chart.
  final ChartData data;

  /// Margins around the plot area for axes and labels.
  final ChartMargin? margin;

  /// X-axis configurations. Defaults to single auto-configured axis.
  final List<XAxis> xAxes;

  /// Y-axis configurations. Defaults to single auto-configured axis.
  final List<YAxis> yAxes;

  /// Grid line configuration.
  final CartesianGrid? grid;

  /// Line series to render.
  final List<LineSeries> lineSeries;

  /// Area series to render.
  final List<AreaSeries> areaSeries;

  /// Bar series to render.
  final List<BarSeries> barSeries;

  /// Reference lines to render.
  final List<ReferenceLine> referenceLines;

  /// Background color of the chart.
  final Color? backgroundColor;

  /// Tooltip configuration.
  final ChartTooltip? tooltip;

  /// Synchronization ID for coordinating tooltips across multiple charts.
  ///
  /// Charts with the same [syncId] will share hover/tooltip state.
  /// When one chart is hovered, all charts with the same syncId will
  /// show tooltips at the same data index.
  final String? syncId;

  /// Method used for synchronization. Defaults to [SyncMethod.byIndex].
  final SyncMethod syncMethod;

  /// Duration of data transition animations.
  final Duration animationDuration;

  /// Easing curve for animations.
  final Curve animationEasing;

  /// Whether animations are enabled.
  final bool isAnimationActive;

  /// Callback when animation starts.
  final VoidCallback? onAnimationStart;

  /// Callback when animation ends.
  final VoidCallback? onAnimationEnd;

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
    this.referenceLines = const [],
    this.backgroundColor,
    this.tooltip,
    this.syncId,
    this.syncMethod = SyncMethod.byIndex,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationEasing = ease,
    this.isAnimationActive = true,
    this.onAnimationStart,
    this.onAnimationEnd,
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

        if (width <= 0 ||
            height <= 0 ||
            width.isInfinite ||
            height.isInfinite) {
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
          referenceLines: widget.referenceLines,
          backgroundColor: widget.backgroundColor,
          tooltip: widget.tooltip,
          syncId: widget.syncId,
          syncMethod: widget.syncMethod,
          animationDuration: widget.animationDuration,
          animationEasing: widget.animationEasing,
          isAnimationActive: widget.isAnimationActive,
          onAnimationStart: widget.onAnimationStart,
          onAnimationEnd: widget.onAnimationEnd,
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
  final List<ReferenceLine> referenceLines;
  final Color? backgroundColor;
  final ChartTooltip? tooltip;
  final String? syncId;
  final SyncMethod syncMethod;
  final Duration animationDuration;
  final Curve animationEasing;
  final bool isAnimationActive;
  final VoidCallback? onAnimationStart;
  final VoidCallback? onAnimationEnd;

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
    required this.referenceLines,
    this.backgroundColor,
    this.tooltip,
    this.syncId,
    required this.syncMethod,
    required this.animationDuration,
    required this.animationEasing,
    required this.isAnimationActive,
    this.onAnimationStart,
    this.onAnimationEnd,
  });

  @override
  State<_ChartContent> createState() => _ChartContentState();
}

class _ChartContentState extends State<_ChartContent>
    with SingleTickerProviderStateMixin {
  ChartInteractionState _interactionState = ChartInteractionState.inactive;
  ChartInteractionController? _controller;

  ChartAnimationController? _animationController;
  double _animationProgress = 1.0;

  Map<String, List<LinePoint>>? _previousLinePointsMap;
  Map<String, List<AreaPoint>>? _previousAreaPointsMap;
  Map<String, List<BarRect>>? _previousBarRectsMap;

  Map<String, List<LinePoint>> _currentLinePointsMap = {};
  Map<String, List<AreaPoint>> _currentAreaPointsMap = {};
  Map<String, List<BarRect>> _currentBarRectsMap = {};

  bool _isFirstBuild = true;

  VoidCallback? _syncUnsubscribe;
  final String _chartId = UniqueKey().toString();

  @override
  void initState() {
    super.initState();
    _initAnimationController();
    _registerSync();
  }

  void _registerSync() {
    if (widget.syncId != null) {
      _syncUnsubscribe = ChartSyncBus.instance.register(
        widget.syncId!,
        _handleSyncUpdate,
      );
    }
  }

  void _unregisterSync() {
    _syncUnsubscribe?.call();
    _syncUnsubscribe = null;
  }

  void _handleSyncUpdate(SyncHoverPayload? payload) {
    if (payload?.sourceChartId == _chartId) return;

    if (payload == null) {
      setState(() {
        _interactionState = ChartInteractionState.inactive;
      });
    } else if (payload.index != null) {
      _handleSyncedHover(payload.index!);
    }
  }

  void _handleSyncedHover(int index) {
    if (_controller == null) return;

    final payload = _controller!.buildTooltipPayload(
      index,
      _interactionState.activeCoordinate ?? Offset.zero,
    );

    setState(() {
      _interactionState = ChartInteractionState(
        isActive: true,
        activeIndex: index,
        activeCoordinate: _interactionState.activeCoordinate,
        tooltipPayload: payload,
      );
    });
  }

  void _initAnimationController() {
    _animationController = ChartAnimationController(
      vsync: this,
      duration: widget.animationDuration,
      curve: widget.animationEasing,
      onProgress: _handleAnimationProgress,
      onComplete: _handleAnimationComplete,
    );
  }

  void _handleAnimationProgress(double progress) {
    setState(() {
      _animationProgress = progress;
    });
  }

  void _handleAnimationComplete() {
    _previousLinePointsMap = null;
    _previousAreaPointsMap = null;
    _previousBarRectsMap = null;
    widget.onAnimationEnd?.call();
  }

  @override
  void didUpdateWidget(_ChartContent oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.animationDuration != oldWidget.animationDuration) {
      _animationController?.duration = widget.animationDuration;
    }
    if (widget.animationEasing != oldWidget.animationEasing) {
      _animationController?.curve = widget.animationEasing;
    }

    if (widget.syncId != oldWidget.syncId) {
      _unregisterSync();
      _registerSync();
    }

    _controller = null;
  }

  @override
  void dispose() {
    _unregisterSync();
    _animationController?.dispose();
    super.dispose();
  }

  void _handleStateChanged(ChartInteractionState state) {
    setState(() {
      _interactionState = state;
    });

    if (widget.syncId != null && state.isActive && state.activeIndex != null) {
      ChartSyncBus.instance.notifyHover(
        SyncHoverPayload(
          syncId: widget.syncId!,
          index: state.activeIndex,
          coordinate: state.activeCoordinate,
          sourceChartId: _chartId,
        ),
      );
    } else if (widget.syncId != null && !state.isActive) {
      ChartSyncBus.instance.clearHover(widget.syncId!, sourceChartId: _chartId);
    }
  }

  void _triggerAnimation() {
    if (!widget.isAnimationActive) {
      _animationProgress = 1.0;
      return;
    }

    widget.onAnimationStart?.call();
    _animationProgress = 0.0;
    _animationController?.animate();
  }

  @override
  Widget build(BuildContext context) {
    final layout = computeChartLayout(
      size: Size(widget.width, widget.height),
      margin: widget.margin,
    );

    final effectiveXAxes = widget.xAxes.isNotEmpty
        ? widget.xAxes
        : [const XAxis()];
    final effectiveYAxes = widget.yAxes.isNotEmpty
        ? widget.yAxes
        : [const YAxis()];
    final primaryXAxis = effectiveXAxes.first;
    final primaryYAxis = effectiveYAxes.first;
    final isVerticalLayout = _isVerticalLayout(primaryXAxis, primaryYAxis);

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

    final xDataKey = primaryXAxis.dataKey;
    final categoryDataKey = isVerticalLayout
        ? (primaryYAxis.dataKey ?? xDataKey ?? 'name')
        : (xDataKey ?? primaryYAxis.dataKey ?? 'name');

    final linePointsMap = <String, List<LinePoint>>{};
    for (final series in widget.lineSeries) {
      linePointsMap[series.dataKey] = computeLinePoints(
        data: widget.dataSet,
        series: series,
        xScale: scales.xScale,
        yScale: scales.yScale,
        xDataKey: xDataKey,
        yDataKey: categoryDataKey,
        verticalLayout: isVerticalLayout,
      );
    }

    final baseX = scales.xScale(0);
    final baseY = scales.yScale(0);

    final areaPointsMap = <String, List<AreaPoint>>{};
    for (final series in widget.areaSeries) {
      areaPointsMap[series.dataKey] = computeAreaPoints(
        data: widget.dataSet,
        series: series,
        xScale: scales.xScale,
        yScale: scales.yScale,
        xDataKey: xDataKey,
        yDataKey: categoryDataKey,
        baseX: baseX,
        baseY: baseY,
        verticalLayout: isVerticalLayout,
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

    final dataChanged = _hasDataChanged(
      linePointsMap,
      areaPointsMap,
      barRectsMap,
    );

    if (dataChanged && !_isFirstBuild && widget.isAnimationActive) {
      _previousLinePointsMap = Map.from(_currentLinePointsMap);
      _previousAreaPointsMap = Map.from(_currentAreaPointsMap);
      _previousBarRectsMap = Map.from(_currentBarRectsMap);
      _triggerAnimation();
    }

    _currentLinePointsMap = linePointsMap;
    _currentAreaPointsMap = areaPointsMap;
    _currentBarRectsMap = barRectsMap;

    if (_isFirstBuild && widget.isAnimationActive) {
      _triggerAnimation();
    }
    _isFirstBuild = false;

    final seriesInfoList = <SeriesInfo>[
      ...widget.lineSeries.map(
        (s) => SeriesInfo(dataKey: s.dataKey, name: s.name, color: s.stroke),
      ),
      ...widget.areaSeries.map(
        (s) => SeriesInfo(dataKey: s.dataKey, name: s.name, color: s.stroke),
      ),
      ...widget.barSeries.map(
        (s) => SeriesInfo(dataKey: s.dataKey, name: s.name, color: s.fill),
      ),
    ];

    _controller ??= ChartInteractionController(
      data: widget.dataSet,
      layout: layout,
      xScale: scales.xScale,
      yScale: scales.yScale,
      xDataKey: xDataKey ?? 'name',
      categoryDataKey: categoryDataKey,
      verticalLayout: isVerticalLayout,
      seriesInfoList: seriesInfoList,
      onStateChanged: _handleStateChanged,
    );

    double? activeX;
    List<Offset?> activePoints = [];

    if (_interactionState.isActive && _interactionState.activeIndex != null) {
      final index = _interactionState.activeIndex!;
      if (isVerticalLayout) {
        final anchorDataKey = seriesInfoList.isNotEmpty
            ? seriesInfoList.first.dataKey
            : null;
        if (anchorDataKey != null) {
          activeX = _controller!.getPointCoordinate(index, anchorDataKey)?.dx;
        }
      } else {
        final point = widget.dataSet[index];
        final xValue = point[xDataKey ?? 'name'];
        if (xValue != null) {
          activeX = scales.xScale(xValue) + (scales.xScale.bandwidth ?? 0) / 2;
        }
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
        painter: AnimatedCartesianChartPainter(
          layout: layout,
          grid: widget.grid,
          xAxes: effectiveXAxes,
          yAxes: effectiveYAxes,
          lineSeries: widget.lineSeries,
          areaSeries: widget.areaSeries,
          barSeries: widget.barSeries,
          referenceLines: widget.referenceLines,
          xScale: scales.xScale,
          yScale: scales.yScale,
          linePointsMap: linePointsMap,
          areaPointsMap: areaPointsMap,
          barRectsMap: barRectsMap,
          previousLinePointsMap: _previousLinePointsMap,
          previousAreaPointsMap: _previousAreaPointsMap,
          previousBarRectsMap: _previousBarRectsMap,
          animationProgress: _animationProgress,
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

  bool _isVerticalLayout(XAxis xAxis, YAxis yAxis) {
    return _isCategoricalScaleType(yAxis.type) &&
        !_isCategoricalScaleType(xAxis.type);
  }

  bool _isCategoricalScaleType(ScaleType type) {
    return type == ScaleType.category ||
        type == ScaleType.band ||
        type == ScaleType.point ||
        type == ScaleType.ordinal;
  }

  bool _hasDataChanged(
    Map<String, List<LinePoint>> linePointsMap,
    Map<String, List<AreaPoint>> areaPointsMap,
    Map<String, List<BarRect>> barRectsMap,
  ) {
    if (_currentLinePointsMap.isEmpty &&
        _currentAreaPointsMap.isEmpty &&
        _currentBarRectsMap.isEmpty) {
      return false;
    }

    if (linePointsMap.length != _currentLinePointsMap.length ||
        areaPointsMap.length != _currentAreaPointsMap.length ||
        barRectsMap.length != _currentBarRectsMap.length) {
      return true;
    }

    for (final key in linePointsMap.keys) {
      final current = _currentLinePointsMap[key];
      final next = linePointsMap[key];
      if (current == null || next == null) return true;
      if (current.length != next.length) return true;
      for (int i = 0; i < current.length; i++) {
        if (current[i].x != next[i].x || current[i].y != next[i].y) {
          return true;
        }
      }
    }

    for (final key in areaPointsMap.keys) {
      final current = _currentAreaPointsMap[key];
      final next = areaPointsMap[key];
      if (current == null || next == null) return true;
      if (current.length != next.length) return true;
      for (int i = 0; i < current.length; i++) {
        if (current[i].x != next[i].x ||
            current[i].y != next[i].y ||
            current[i].baseX != next[i].baseX ||
            current[i].baseY != next[i].baseY) {
          return true;
        }
      }
    }

    for (final key in barRectsMap.keys) {
      final current = _currentBarRectsMap[key];
      final next = barRectsMap[key];
      if (current == null || next == null) return true;
      if (current.length != next.length) return true;
      for (int i = 0; i < current.length; i++) {
        if (current[i].rect != next[i].rect) {
          return true;
        }
      }
    }

    return false;
  }
}
