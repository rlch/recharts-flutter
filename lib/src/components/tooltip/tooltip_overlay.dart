import 'package:flutter/material.dart';

import 'chart_tooltip.dart';
import 'default_tooltip_content.dart';
import 'tooltip_types.dart';

class TooltipOverlay extends StatelessWidget {
  final TooltipPayload? payload;
  final ChartTooltip config;
  final Size chartSize;
  final Offset? cursorPosition;

  const TooltipOverlay({
    super.key,
    required this.payload,
    required this.config,
    required this.chartSize,
    this.cursorPosition,
  });

  @override
  Widget build(BuildContext context) {
    if (payload == null || payload!.isEmpty) {
      return const SizedBox.shrink();
    }

    final effectivePosition = config.followCursor
        ? (cursorPosition ?? payload!.coordinate)
        : payload!.coordinate;

    return AnimatedOpacity(
      opacity: payload != null ? 1.0 : 0.0,
      duration: config.animationDuration,
      child: CustomSingleChildLayout(
        delegate: _TooltipPositionDelegate(
          position: effectivePosition,
          offset: config.offset,
          chartSize: chartSize,
        ),
        child: config.contentBuilder != null
            ? config.contentBuilder!(context, payload!)
            : DefaultTooltipContent(
                payload: payload!,
                config: config,
              ),
      ),
    );
  }
}

class _TooltipPositionDelegate extends SingleChildLayoutDelegate {
  final Offset position;
  final Offset offset;
  final Size chartSize;

  _TooltipPositionDelegate({
    required this.position,
    required this.offset,
    required this.chartSize,
  });

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return constraints.loosen();
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    double x = position.dx + offset.dx;
    double y = position.dy + offset.dy;

    if (x + childSize.width > chartSize.width) {
      x = position.dx - childSize.width - offset.dx;
    }
    if (x < 0) {
      x = 0;
    }

    if (y + childSize.height > chartSize.height) {
      y = position.dy - childSize.height - offset.dy;
    }
    if (y < 0) {
      y = 0;
    }

    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_TooltipPositionDelegate oldDelegate) {
    return position != oldDelegate.position ||
        offset != oldDelegate.offset ||
        chartSize != oldDelegate.chartSize;
  }
}
