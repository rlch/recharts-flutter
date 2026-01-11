import 'package:flutter/material.dart';

class ChartWidget extends StatelessWidget {
  final double width;
  final double height;
  final List<Map<String, dynamic>>? data;
  final List<Widget> children;
  final EdgeInsets margin;
  final Color? backgroundColor;

  const ChartWidget({
    super.key,
    required this.width,
    required this.height,
    this.data,
    this.children = const [],
    this.margin = EdgeInsets.zero,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Container(
        color: backgroundColor,
        child: CustomPaint(
          size: Size(width, height),
          painter: _ChartPainter(margin: margin),
          child: Stack(
            children: children,
          ),
        ),
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  final EdgeInsets margin;

  _ChartPainter({required this.margin});

  @override
  void paint(Canvas canvas, Size size) {
    // Stub implementation - will be expanded in Phase 1
  }

  @override
  bool shouldRepaint(covariant _ChartPainter oldDelegate) {
    return margin != oldDelegate.margin;
  }
}
