import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../core/animation/easing_curves.dart';
import '../state/controllers/chart_animation_controller.dart';
import '../components/tooltip/tooltip.dart';
import 'sunburst_node.dart';
import 'sunburst_layout.dart';
import 'sunburst_painter.dart';

const defaultSunburstColors = [
  Color(0xFF8884d8),
  Color(0xFF83a6ed),
  Color(0xFF8dd1e1),
  Color(0xFF82ca9d),
  Color(0xFFa4de6c),
  Color(0xFFd0ed57),
  Color(0xFFffc658),
  Color(0xFFff8042),
];

class SunburstChart extends StatefulWidget {
  final double? width;
  final double? height;
  final SunburstNode data;
  final double padding;
  final double innerRadiusPercent;
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

  const SunburstChart({
    super.key,
    this.width,
    this.height,
    required this.data,
    this.padding = 20,
    this.innerRadiusPercent = 0.1,
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
  State<SunburstChart> createState() => _SunburstChartState();
}

class _SunburstChartState extends State<SunburstChart>
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
  void didUpdateWidget(SunburstChart oldWidget) {
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

  int? _findSectorAtPoint(Offset point, List<SunburstSector> sectors, Offset center) {
    final dx = point.dx - center.dx;
    final dy = point.dy - center.dy;
    final distance = math.sqrt(dx * dx + dy * dy);
    var angle = math.atan2(dy, dx);
    if (angle < 0) angle += 2 * math.pi;

    for (int i = sectors.length - 1; i >= 0; i--) {
      final sector = sectors[i];
      if (distance >= sector.innerRadius &&
          distance <= sector.outerRadius &&
          angle >= sector.startAngle &&
          angle <= sector.endAngle) {
        return i;
      }
    }
    return null;
  }

  void _handlePointerMove(Offset position, List<SunburstSector> sectors, Offset center) {
    final index = _findSectorAtPoint(position, sectors, center);
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

        final center = Offset(width / 2, height / 2);
        final maxRadius = (math.min(width, height) / 2) - widget.padding;
        final innerRadius = maxRadius * widget.innerRadiusPercent;
        final outerRadius = maxRadius;

        final colors = widget.colors ?? defaultSunburstColors;
        final sectors = SunburstLayout.compute(
          root: widget.data,
          center: center,
          innerRadius: innerRadius,
          outerRadius: outerRadius,
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
            painter: SunburstPainter(
              sectors: sectors,
              center: center,
              animationProgress: _animationProgress,
              activeIndex: _activeIndex,
              showLabels: widget.showLabels,
              stroke: widget.stroke,
              strokeWidth: widget.strokeWidth,
            ),
          ),
        );

        if (tooltipEnabled) {
          chartWidget = MouseRegion(
            onHover: (event) =>
                _handlePointerMove(event.localPosition, sectors, center),
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
