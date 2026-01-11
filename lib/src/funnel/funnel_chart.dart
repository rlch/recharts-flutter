import 'package:flutter/material.dart';

import '../core/types/chart_data.dart';
import '../core/animation/easing_curves.dart';
import '../state/controllers/chart_animation_controller.dart';
import '../components/tooltip/tooltip.dart';
import 'funnel_series.dart';
import 'funnel_geometry.dart';
import 'funnel_painter.dart';

class FunnelChart extends StatefulWidget {
  final double? width;
  final double? height;
  final ChartData data;
  final double padding;
  final Color? backgroundColor;
  final FunnelSeries series;
  final ChartTooltip? tooltip;
  final Duration animationDuration;
  final Curve animationEasing;
  final bool isAnimationActive;
  final VoidCallback? onAnimationStart;
  final VoidCallback? onAnimationEnd;

  const FunnelChart({
    super.key,
    this.width,
    this.height,
    required this.data,
    this.padding = 20,
    this.backgroundColor,
    required this.series,
    this.tooltip,
    this.animationDuration = const Duration(milliseconds: 400),
    this.animationEasing = ease,
    this.isAnimationActive = true,
    this.onAnimationStart,
    this.onAnimationEnd,
  });

  @override
  State<FunnelChart> createState() => _FunnelChartState();
}

class _FunnelChartState extends State<FunnelChart> {
  late ChartDataSet _dataSet;

  @override
  void initState() {
    super.initState();
    _dataSet = ChartDataSet(widget.data);
  }

  @override
  void didUpdateWidget(FunnelChart oldWidget) {
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

        return _FunnelChartContent(
          width: width,
          height: height,
          dataSet: _dataSet,
          padding: widget.padding,
          backgroundColor: widget.backgroundColor,
          series: widget.series,
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

class _FunnelChartContent extends StatefulWidget {
  final double width;
  final double height;
  final ChartDataSet dataSet;
  final double padding;
  final Color? backgroundColor;
  final FunnelSeries series;
  final ChartTooltip? tooltip;
  final Duration animationDuration;
  final Curve animationEasing;
  final bool isAnimationActive;
  final VoidCallback? onAnimationStart;
  final VoidCallback? onAnimationEnd;

  const _FunnelChartContent({
    required this.width,
    required this.height,
    required this.dataSet,
    required this.padding,
    this.backgroundColor,
    required this.series,
    this.tooltip,
    required this.animationDuration,
    required this.animationEasing,
    required this.isAnimationActive,
    this.onAnimationStart,
    this.onAnimationEnd,
  });

  @override
  State<_FunnelChartContent> createState() => _FunnelChartContentState();
}

class _FunnelChartContentState extends State<_FunnelChartContent>
    with SingleTickerProviderStateMixin {
  ChartAnimationController? _animationController;
  double _animationProgress = 1.0;
  int? _activeIndex;
  bool _isFirstBuild = true;

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
    widget.onAnimationEnd?.call();
  }

  @override
  void didUpdateWidget(_FunnelChartContent oldWidget) {
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

  List<TrapezoidGeometry> _computeTrapezoids() {
    final layout = FunnelLayout.compute(
      chartWidth: widget.width,
      chartHeight: widget.height,
      padding: widget.padding,
    );

    final dataSet = widget.dataSet;
    final series = widget.series;
    final colors = series.colors ?? defaultFunnelColors;

    final values = <double>[];
    for (int i = 0; i < dataSet.length; i++) {
      final value = dataSet[i].getNumericValue(series.dataKey);
      values.add(value ?? 0);
    }

    if (values.isEmpty) return [];

    final maxValue = values.reduce((a, b) => a > b ? a : b);
    if (maxValue == 0) return [];

    final totalGap = series.gap * (values.length - 1);
    final availableHeight = layout.height - totalGap;
    final segmentHeight = availableHeight / values.length;

    final trapezoids = <TrapezoidGeometry>[];

    final orderedValues = series.reversed ? values.reversed.toList() : values;
    final orderedIndices = series.reversed
        ? List.generate(values.length, (i) => values.length - 1 - i)
        : List.generate(values.length, (i) => i);

    for (int i = 0; i < orderedValues.length; i++) {
      final actualIndex = orderedIndices[i];
      final value = orderedValues[i];
      final nextValue = i < orderedValues.length - 1 ? orderedValues[i + 1] : 0.0;

      final upperWidth = series.shape == FunnelShape.rectangle
          ? (value / maxValue) * layout.width
          : (value / maxValue) * layout.width;
      final lowerWidth = series.shape == FunnelShape.rectangle
          ? upperWidth
          : (nextValue / maxValue) * layout.width;

      final y = layout.y + i * (segmentHeight + series.gap);
      final color = colors[actualIndex % colors.length];

      final nameKey = series.nameKey ?? 'name';
      final label = dataSet[actualIndex].getStringValue(nameKey);

      trapezoids.add(TrapezoidGeometry(
        index: actualIndex,
        x: layout.x,
        y: y,
        width: layout.width,
        height: segmentHeight,
        upperWidth: upperWidth,
        lowerWidth: lowerWidth,
        color: color,
        label: label,
        value: value,
      ));
    }

    return trapezoids;
  }

  int? _findTrapezoidAtPoint(Offset point, List<TrapezoidGeometry> trapezoids) {
    for (final trapezoid in trapezoids) {
      final path = trapezoid.toPath();
      if (path.contains(point)) {
        return trapezoid.index;
      }
    }
    return null;
  }

  void _handlePointerMove(Offset position, List<TrapezoidGeometry> trapezoids) {
    final index = _findTrapezoidAtPoint(position, trapezoids);
    if (index != _activeIndex) {
      setState(() {
        _activeIndex = index;
      });
    }
  }

  void _handlePointerExit() {
    setState(() {
      _activeIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final trapezoids = _computeTrapezoids();

    if (_isFirstBuild && widget.isAnimationActive) {
      _triggerAnimation();
    }
    _isFirstBuild = false;

    final effectiveTooltip = widget.tooltip ?? const ChartTooltip();
    final tooltipEnabled = effectiveTooltip.enabled;

    Widget chartWidget = Container(
      width: widget.width,
      height: widget.height,
      color: widget.backgroundColor,
      child: CustomPaint(
        size: Size(widget.width, widget.height),
        painter: FunnelPainter(
          trapezoids: trapezoids,
          series: widget.series,
          animationProgress: _animationProgress,
          activeIndex: _activeIndex,
        ),
      ),
    );

    if (tooltipEnabled) {
      chartWidget = MouseRegion(
        onHover: (event) => _handlePointerMove(event.localPosition, trapezoids),
        onExit: (_) => _handlePointerExit(),
        child: chartWidget,
      );
    }

    return chartWidget;
  }
}
