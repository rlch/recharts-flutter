import 'package:flutter/material.dart';

import '../core/animation/easing_curves.dart';
import '../state/controllers/chart_animation_controller.dart';
import '../components/tooltip/tooltip.dart';
import 'treemap_node.dart';
import 'squarified_layout.dart';
import 'treemap_painter.dart';

const defaultTreemapColors = [
  Color(0xFF8884d8),
  Color(0xFF83a6ed),
  Color(0xFF8dd1e1),
  Color(0xFF82ca9d),
  Color(0xFFa4de6c),
  Color(0xFFd0ed57),
  Color(0xFFffc658),
  Color(0xFFff8042),
];

class TreemapChart extends StatefulWidget {
  final double? width;
  final double? height;
  final TreemapNode data;
  final double padding;
  final double cellPadding;
  final Color? backgroundColor;
  final List<Color>? colors;
  final Color? stroke;
  final double strokeWidth;
  final bool showLabels;
  final ChartTooltip? tooltip;
  final Duration animationDuration;
  final Curve animationEasing;
  final bool isAnimationActive;
  final VoidCallback? onAnimationStart;
  final VoidCallback? onAnimationEnd;

  const TreemapChart({
    super.key,
    this.width,
    this.height,
    required this.data,
    this.padding = 20,
    this.cellPadding = 2,
    this.backgroundColor,
    this.colors,
    this.stroke,
    this.strokeWidth = 1,
    this.showLabels = true,
    this.tooltip,
    this.animationDuration = const Duration(milliseconds: 400),
    this.animationEasing = ease,
    this.isAnimationActive = true,
    this.onAnimationStart,
    this.onAnimationEnd,
  });

  @override
  State<TreemapChart> createState() => _TreemapChartState();
}

class _TreemapChartState extends State<TreemapChart>
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
  void didUpdateWidget(TreemapChart oldWidget) {
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

  int? _findRectAtPoint(Offset point, List<TreemapRect> rects) {
    for (int i = 0; i < rects.length; i++) {
      if (rects[i].rect.contains(point)) {
        return i;
      }
    }
    return null;
  }

  void _handlePointerMove(Offset position, List<TreemapRect> rects) {
    final index = _findRectAtPoint(position, rects);
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

        final colors = widget.colors ?? defaultTreemapColors;
        final rects = SquarifiedLayout.compute(
          root: widget.data,
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
            painter: TreemapPainter(
              rects: rects,
              animationProgress: _animationProgress,
              activeIndex: _activeIndex,
              showLabels: widget.showLabels,
              stroke: widget.stroke,
              strokeWidth: widget.strokeWidth,
              padding: widget.cellPadding,
            ),
          ),
        );

        if (tooltipEnabled) {
          chartWidget = MouseRegion(
            onHover: (event) => _handlePointerMove(event.localPosition, rects),
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
