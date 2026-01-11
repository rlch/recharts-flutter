import 'package:flutter/material.dart';

import '../core/types/chart_data.dart';
import '../core/animation/easing_curves.dart';
import '../state/controllers/chart_animation_controller.dart';
import '../state/controllers/polar_hit_testing.dart';
import '../state/models/polar_data.dart';
import '../state/providers/polar_geometry_provider.dart';
import '../state/providers/polar_tooltip_provider.dart';
import '../components/tooltip/tooltip.dart';
import 'polar_layout.dart';
import 'axis/polar_angle_axis.dart';
import 'axis/polar_radius_axis.dart';
import 'grid/polar_grid.dart';
import 'series/pie_series.dart';
import 'series/radial_bar_series.dart';
import 'series/radar_series.dart';
import 'painters/polar_chart_painter.dart';

class PolarChartWidget extends StatefulWidget {
  final double? width;
  final double? height;
  final ChartData data;
  final double padding;
  final double? innerRadiusPercent;
  final double? outerRadiusPercent;
  final Color? backgroundColor;
  final PolarAngleAxis? angleAxis;
  final PolarRadiusAxis? radiusAxis;
  final PolarGrid? grid;
  final List<PieSeries> pieSeries;
  final List<RadialBarSeries> radialBarSeries;
  final List<RadarSeries> radarSeries;
  final ChartTooltip? tooltip;
  final Duration animationDuration;
  final Curve animationEasing;
  final bool isAnimationActive;
  final VoidCallback? onAnimationStart;
  final VoidCallback? onAnimationEnd;

  const PolarChartWidget({
    super.key,
    this.width,
    this.height,
    required this.data,
    this.padding = 20,
    this.innerRadiusPercent,
    this.outerRadiusPercent,
    this.backgroundColor,
    this.angleAxis,
    this.radiusAxis,
    this.grid,
    this.pieSeries = const [],
    this.radialBarSeries = const [],
    this.radarSeries = const [],
    this.tooltip,
    this.animationDuration = const Duration(milliseconds: 400),
    this.animationEasing = ease,
    this.isAnimationActive = true,
    this.onAnimationStart,
    this.onAnimationEnd,
  });

  @override
  State<PolarChartWidget> createState() => _PolarChartWidgetState();
}

class _PolarChartWidgetState extends State<PolarChartWidget> {
  late ChartDataSet _dataSet;

  @override
  void initState() {
    super.initState();
    _dataSet = ChartDataSet(widget.data);
  }

  @override
  void didUpdateWidget(PolarChartWidget oldWidget) {
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

        return _PolarChartContent(
          width: width,
          height: height,
          dataSet: _dataSet,
          padding: widget.padding,
          innerRadiusPercent: widget.innerRadiusPercent,
          outerRadiusPercent: widget.outerRadiusPercent,
          backgroundColor: widget.backgroundColor,
          angleAxis: widget.angleAxis,
          radiusAxis: widget.radiusAxis,
          grid: widget.grid,
          pieSeries: widget.pieSeries,
          radialBarSeries: widget.radialBarSeries,
          radarSeries: widget.radarSeries,
          tooltip: widget.tooltip,
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

class _PolarChartContent extends StatefulWidget {
  final double width;
  final double height;
  final ChartDataSet dataSet;
  final double padding;
  final double? innerRadiusPercent;
  final double? outerRadiusPercent;
  final Color? backgroundColor;
  final PolarAngleAxis? angleAxis;
  final PolarRadiusAxis? radiusAxis;
  final PolarGrid? grid;
  final List<PieSeries> pieSeries;
  final List<RadialBarSeries> radialBarSeries;
  final List<RadarSeries> radarSeries;
  final ChartTooltip? tooltip;
  final Duration animationDuration;
  final Curve animationEasing;
  final bool isAnimationActive;
  final VoidCallback? onAnimationStart;
  final VoidCallback? onAnimationEnd;

  const _PolarChartContent({
    required this.width,
    required this.height,
    required this.dataSet,
    required this.padding,
    this.innerRadiusPercent,
    this.outerRadiusPercent,
    this.backgroundColor,
    this.angleAxis,
    this.radiusAxis,
    this.grid,
    required this.pieSeries,
    required this.radialBarSeries,
    required this.radarSeries,
    this.tooltip,
    required this.animationDuration,
    required this.animationEasing,
    required this.isAnimationActive,
    this.onAnimationStart,
    this.onAnimationEnd,
  });

  @override
  State<_PolarChartContent> createState() => _PolarChartContentState();
}

class _PolarChartContentState extends State<_PolarChartContent>
    with SingleTickerProviderStateMixin {
  ChartAnimationController? _animationController;
  double _animationProgress = 1.0;

  Map<String, List<SectorGeometry>>? _previousPieSectorsMap;
  Map<String, List<RadialBarGeometry>>? _previousRadialBarsMap;
  Map<String, List<RadarPoint>>? _previousRadarPointsMap;

  Map<String, List<SectorGeometry>> _currentPieSectorsMap = {};
  Map<String, List<RadialBarGeometry>> _currentRadialBarsMap = {};
  Map<String, List<RadarPoint>> _currentRadarPointsMap = {};

  bool _isFirstBuild = true;

  PolarTooltipPayload? _activeTooltip;
  Offset? _activeCoordinate;
  int? _activeIndex;

  @override
  void initState() {
    super.initState();
    _initAnimationController();
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
    _previousPieSectorsMap = null;
    _previousRadialBarsMap = null;
    _previousRadarPointsMap = null;
    widget.onAnimationEnd?.call();
  }

  @override
  void didUpdateWidget(_PolarChartContent oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.animationDuration != oldWidget.animationDuration) {
      _animationController?.duration = widget.animationDuration;
    }
    if (widget.animationEasing != oldWidget.animationEasing) {
      _animationController?.curve = widget.animationEasing;
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void _triggerAnimation() {
    if (!widget.isAnimationActive) {
      _animationProgress = 1.0;
      return;
    }

    widget.onAnimationStart?.call();
    _animationController?.animate();
  }

  void _handlePointerMove(Offset position, PolarLayout layout) {
    final result = _findElementAtPoint(position);
    if (result != null) {
      setState(() {
        _activeTooltip = result;
        _activeCoordinate = position;
        _activeIndex = result.sectorIndex;
      });
    }
  }

  void _handlePointerExit() {
    setState(() {
      _activeTooltip = null;
      _activeCoordinate = null;
      _activeIndex = null;
    });
  }

  PolarTooltipPayload? _findElementAtPoint(Offset point) {
    for (final entry in _currentPieSectorsMap.entries) {
      final index = findPieSectorAtPoint(point, entry.value);
      if (index != null) {
        return buildPieTooltipPayload(
          sectors: entry.value,
          sectorIndex: index,
          coordinate: point,
        );
      }
    }

    for (final entry in _currentRadialBarsMap.entries) {
      final index = findRadialBarAtPoint(point, entry.value);
      if (index != null) {
        return buildRadialBarTooltipPayload(
          bars: entry.value,
          barIndex: index,
          coordinate: point,
        );
      }
    }

    for (int i = 0; i < widget.radarSeries.length; i++) {
      final series = widget.radarSeries[i];
      final points = _currentRadarPointsMap[series.dataKey];
      if (points == null) continue;

      final index = findRadarPointAtPoint(point, points);
      if (index != null) {
        return buildRadarTooltipPayload(
          points: points,
          pointIndex: index,
          coordinate: point,
          seriesColor: series.stroke,
          seriesName: series.name ?? series.dataKey,
        );
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final layout = PolarLayout.compute(
      width: widget.width,
      height: widget.height,
      padding: widget.padding,
      innerRadiusPercent: widget.innerRadiusPercent,
      outerRadiusPercent: widget.outerRadiusPercent,
    );

    final pieSectorsMap = <String, List<SectorGeometry>>{};
    for (final series in widget.pieSeries) {
      pieSectorsMap[series.dataKey] = computePieSectors(
        data: widget.dataSet,
        series: series,
        layout: layout,
      );
    }

    final radialBarsMap = <String, List<RadialBarGeometry>>{};
    for (final series in widget.radialBarSeries) {
      radialBarsMap[series.dataKey] = computeRadialBars(
        data: widget.dataSet,
        series: series,
        layout: layout,
      );
    }

    final angleDataKey = widget.angleAxis?.dataKey ?? 'name';

    double? maxRadarValue;
    for (final series in widget.radarSeries) {
      final extent = widget.dataSet.getExtent(series.dataKey);
      if (extent != null) {
        if (maxRadarValue == null || extent.$2 > maxRadarValue) {
          maxRadarValue = extent.$2;
        }
      }
    }

    final radarPointsMap = <String, List<RadarPoint>>{};
    for (final series in widget.radarSeries) {
      radarPointsMap[series.dataKey] = computeRadarPoints(
        data: widget.dataSet,
        series: series,
        layout: layout,
        angleDataKey: angleDataKey,
        maxValue: maxRadarValue,
      );
    }

    final dataChanged = _hasDataChanged(pieSectorsMap, radialBarsMap, radarPointsMap);

    if (dataChanged && !_isFirstBuild && widget.isAnimationActive) {
      _previousPieSectorsMap = Map.from(_currentPieSectorsMap);
      _previousRadialBarsMap = Map.from(_currentRadialBarsMap);
      _previousRadarPointsMap = Map.from(_currentRadarPointsMap);
      _triggerAnimation();
    }

    _currentPieSectorsMap = pieSectorsMap;
    _currentRadialBarsMap = radialBarsMap;
    _currentRadarPointsMap = radarPointsMap;

    if (_isFirstBuild && widget.isAnimationActive) {
      _triggerAnimation();
    }
    _isFirstBuild = false;

    final angleLabels = <String>[];
    if (widget.angleAxis != null && widget.radarSeries.isNotEmpty) {
      for (int i = 0; i < widget.dataSet.length; i++) {
        final label = widget.dataSet[i].getStringValue(angleDataKey) ?? '$i';
        angleLabels.add(label);
      }
    }

    List<num> radiusTicks = [];
    double radiusMax = 0;
    if (widget.radiusAxis != null && maxRadarValue != null) {
      radiusMax = maxRadarValue;
      final tickCount = widget.radiusAxis!.tickCount;
      final step = radiusMax / tickCount;
      for (int i = 1; i <= tickCount; i++) {
        radiusTicks.add((step * i).roundToDouble());
      }
    }

    final effectiveTooltip = widget.tooltip ?? const ChartTooltip();
    final tooltipEnabled = effectiveTooltip.enabled;

    Widget chartWidget = Container(
      width: widget.width,
      height: widget.height,
      color: widget.backgroundColor,
      child: CustomPaint(
        size: Size(widget.width, widget.height),
        painter: PolarChartPainter(
          layout: layout,
          grid: widget.grid,
          angleAxis: widget.angleAxis,
          radiusAxis: widget.radiusAxis,
          pieSeries: widget.pieSeries,
          radialBarSeries: widget.radialBarSeries,
          radarSeries: widget.radarSeries,
          pieSectorsMap: pieSectorsMap,
          radialBarsMap: radialBarsMap,
          radarPointsMap: radarPointsMap,
          previousPieSectorsMap: _previousPieSectorsMap,
          previousRadialBarsMap: _previousRadialBarsMap,
          previousRadarPointsMap: _previousRadarPointsMap,
          animationProgress: _animationProgress,
          angleLabels: angleLabels,
          radiusTicks: radiusTicks,
          radiusMax: radiusMax,
          dataPointCount: widget.dataSet.length,
          activeIndex: _activeIndex,
        ),
      ),
    );

    if (tooltipEnabled) {
      chartWidget = Stack(
        children: [
          chartWidget,
          if (_activeTooltip != null)
            Positioned.fill(
              child: TooltipOverlay(
                payload: _activeTooltip,
                config: effectiveTooltip,
                chartSize: Size(widget.width, widget.height),
                cursorPosition: _activeCoordinate,
              ),
            ),
        ],
      );

      final trigger = effectiveTooltip.trigger;
      if (trigger == TooltipTrigger.hover) {
        chartWidget = MouseRegion(
          onHover: (event) => _handlePointerMove(event.localPosition, layout),
          onExit: (_) => _handlePointerExit(),
          child: chartWidget,
        );
      } else if (trigger == TooltipTrigger.click) {
        chartWidget = GestureDetector(
          onTapDown: (details) =>
              _handlePointerMove(details.localPosition, layout),
          child: chartWidget,
        );
      }
    }

    return chartWidget;
  }

  bool _hasDataChanged(
    Map<String, List<SectorGeometry>> pieSectorsMap,
    Map<String, List<RadialBarGeometry>> radialBarsMap,
    Map<String, List<RadarPoint>> radarPointsMap,
  ) {
    if (_currentPieSectorsMap.isEmpty &&
        _currentRadialBarsMap.isEmpty &&
        _currentRadarPointsMap.isEmpty) {
      return false;
    }

    if (pieSectorsMap.length != _currentPieSectorsMap.length ||
        radialBarsMap.length != _currentRadialBarsMap.length ||
        radarPointsMap.length != _currentRadarPointsMap.length) {
      return true;
    }

    for (final key in pieSectorsMap.keys) {
      final current = _currentPieSectorsMap[key];
      final next = pieSectorsMap[key];
      if (current == null || next == null) return true;
      if (current.length != next.length) return true;
    }

    for (final key in radialBarsMap.keys) {
      final current = _currentRadialBarsMap[key];
      final next = radialBarsMap[key];
      if (current == null || next == null) return true;
      if (current.length != next.length) return true;
    }

    for (final key in radarPointsMap.keys) {
      final current = _currentRadarPointsMap[key];
      final next = radarPointsMap[key];
      if (current == null || next == null) return true;
      if (current.length != next.length) return true;
    }

    return false;
  }
}
