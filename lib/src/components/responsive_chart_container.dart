import 'dart:async';

import 'package:flutter/material.dart';

typedef ResponsiveChartBuilder = Widget Function(double width, double height);

class ResponsiveChartContainer extends StatefulWidget {
  final ResponsiveChartBuilder builder;
  final double? aspectRatio;
  final double? minWidth;
  final double? maxWidth;
  final double? minHeight;
  final double? maxHeight;
  final Duration debounceDelay;

  const ResponsiveChartContainer({
    super.key,
    required this.builder,
    this.aspectRatio,
    this.minWidth,
    this.maxWidth,
    this.minHeight,
    this.maxHeight,
    this.debounceDelay = const Duration(milliseconds: 100),
  });

  @override
  State<ResponsiveChartContainer> createState() =>
      _ResponsiveChartContainerState();
}

class _ResponsiveChartContainerState extends State<ResponsiveChartContainer> {
  Size? _lastSize;
  Size? _debouncedSize;
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _handleResize(Size newSize) {
    if (_lastSize == newSize) return;

    _lastSize = newSize;

    if (widget.debounceDelay.inMilliseconds == 0) {
      _debouncedSize = newSize;
      return;
    }

    _debounceTimer?.cancel();
    _debounceTimer = Timer(widget.debounceDelay, () {
      if (mounted && _lastSize != _debouncedSize) {
        setState(() {
          _debouncedSize = _lastSize;
        });
      }
    });

    _debouncedSize ??= newSize;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height;

        if (widget.aspectRatio != null && width.isFinite) {
          height = width / widget.aspectRatio!;
        } else if (constraints.maxHeight.isFinite) {
          height = constraints.maxHeight;
        } else {
          height = 300;
        }

        if (widget.minWidth != null) {
          width = width < widget.minWidth! ? widget.minWidth! : width;
        }
        if (widget.maxWidth != null) {
          width = width > widget.maxWidth! ? widget.maxWidth! : width;
        }
        if (widget.minHeight != null) {
          height = height < widget.minHeight! ? widget.minHeight! : height;
        }
        if (widget.maxHeight != null) {
          height = height > widget.maxHeight! ? widget.maxHeight! : height;
        }

        if (width <= 0 || height <= 0) {
          return const SizedBox.shrink();
        }

        final size = Size(width, height);
        _handleResize(size);

        final effectiveSize = _debouncedSize ?? size;

        return SizedBox(
          width: effectiveSize.width,
          height: effectiveSize.height,
          child: widget.builder(effectiveSize.width, effectiveSize.height),
        );
      },
    );
  }
}
