import 'package:flutter/material.dart';

import '../core/animation/easing_curves.dart';
import '../state/controllers/chart_animation_controller.dart';
import '../components/tooltip/tooltip.dart';
import 'sankey_data.dart';
import 'sankey_layout.dart';
import 'sankey_painter.dart';

const defaultSankeyColors = [
  Color(0xFF8884d8),
  Color(0xFF83a6ed),
  Color(0xFF8dd1e1),
  Color(0xFF82ca9d),
  Color(0xFFa4de6c),
  Color(0xFFd0ed57),
  Color(0xFFffc658),
  Color(0xFFff8042),
];

class SankeyChart extends StatefulWidget {
  final double? width;
  final double? height;
  final SankeyData data;
  final double padding;
  final double nodeWidth;
  final double nodePadding;
  final Color? backgroundColor;
  final List<Color>? colors;
  final Color? nodeStroke;
  final double nodeStrokeWidth;
  final bool showLabels;
  final int iterations;
  final ChartTooltip? tooltip;
  final Duration animationDuration;
  final Curve animationEasing;
  final bool isAnimationActive;
  final VoidCallback? onAnimationStart;
  final VoidCallback? onAnimationEnd;

  const SankeyChart({
    super.key,
    this.width,
    this.height,
    required this.data,
    this.padding = 40,
    this.nodeWidth = 24,
    this.nodePadding = 8,
    this.backgroundColor,
    this.colors,
    this.nodeStroke,
    this.nodeStrokeWidth = 1,
    this.showLabels = true,
    this.iterations = 32,
    this.tooltip,
    this.animationDuration = const Duration(milliseconds: 400),
    this.animationEasing = ease,
    this.isAnimationActive = true,
    this.onAnimationStart,
    this.onAnimationEnd,
  });

  @override
  State<SankeyChart> createState() => _SankeyChartState();
}

class _SankeyChartState extends State<SankeyChart>
    with SingleTickerProviderStateMixin {
  ChartAnimationController? _animationController;
  double _animationProgress = 1.0;
  int? _activeNodeIndex;
  int? _activeLinkIndex;
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
  void didUpdateWidget(SankeyChart oldWidget) {
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

  ({int? nodeIndex, int? linkIndex}) _findElementAtPoint(
    Offset point,
    List<SankeyNodeGeometry> nodes,
    List<SankeyLinkGeometry> links,
  ) {
    for (int i = 0; i < nodes.length; i++) {
      if (nodes[i].rect.contains(point)) {
        return (nodeIndex: i, linkIndex: null);
      }
    }

    return (nodeIndex: null, linkIndex: null);
  }

  void _handlePointerMove(
    Offset position,
    List<SankeyNodeGeometry> nodes,
    List<SankeyLinkGeometry> links,
  ) {
    final result = _findElementAtPoint(position, nodes, links);
    if (result.nodeIndex != _activeNodeIndex ||
        result.linkIndex != _activeLinkIndex) {
      setState(() {
        _activeNodeIndex = result.nodeIndex;
        _activeLinkIndex = result.linkIndex;
      });
    }
  }

  void _handlePointerExit() {
    setState(() {
      _activeNodeIndex = null;
      _activeLinkIndex = null;
    });
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

        final bounds = Rect.fromLTWH(
          widget.padding,
          widget.padding,
          width - widget.padding * 2,
          height - widget.padding * 2,
        );

        final colors = widget.colors ?? defaultSankeyColors;
        final layout = SankeyLayout(
          nodeWidth: widget.nodeWidth,
          nodePadding: widget.nodePadding,
          iterations: widget.iterations,
        );

        final result = layout.compute(
          data: widget.data,
          bounds: bounds,
          colors: colors,
        );

        if (_isFirstBuild && widget.isAnimationActive) {
          _triggerAnimation();
        }
        _isFirstBuild = false;

        final effectiveTooltip = widget.tooltip ?? const ChartTooltip();
        final tooltipEnabled = effectiveTooltip.enabled;

        Widget chartWidget = Container(
          width: width,
          height: height,
          color: widget.backgroundColor,
          child: CustomPaint(
            size: Size(width, height),
            painter: SankeyPainter(
              nodes: result.nodes,
              links: result.links,
              nodeWidth: widget.nodeWidth,
              animationProgress: _animationProgress,
              activeNodeIndex: _activeNodeIndex,
              activeLinkIndex: _activeLinkIndex,
              showLabels: widget.showLabels,
              nodeStroke: widget.nodeStroke,
              nodeStrokeWidth: widget.nodeStrokeWidth,
            ),
          ),
        );

        if (tooltipEnabled) {
          chartWidget = MouseRegion(
            onHover: (event) =>
                _handlePointerMove(event.localPosition, result.nodes, result.links),
            onExit: (_) => _handlePointerExit(),
            child: chartWidget,
          );
        }

        return chartWidget;
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
