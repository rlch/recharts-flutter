import 'package:flutter/material.dart';

import '../../core/types/chart_data.dart';
import '../../core/scale/band_scale.dart';
import '../../core/scale/linear_scale.dart';
import 'chart_brush.dart';

typedef BrushChangeCallback = void Function(int startIndex, int endIndex);

class BrushWidget extends StatefulWidget {
  final ChartBrush config;
  final ChartDataSet data;
  final String? xDataKey;
  final String? yDataKey;
  final double width;
  final double height;
  final int startIndex;
  final int endIndex;
  final BrushChangeCallback? onChange;

  const BrushWidget({
    super.key,
    required this.config,
    required this.data,
    this.xDataKey,
    this.yDataKey,
    required this.width,
    required this.height,
    required this.startIndex,
    required this.endIndex,
    this.onChange,
  });

  @override
  State<BrushWidget> createState() => _BrushWidgetState();
}

class _BrushWidgetState extends State<BrushWidget> {
  late int _startIndex;
  late int _endIndex;
  bool _isDraggingLeft = false;
  bool _isDraggingRight = false;
  bool _isDraggingCenter = false;
  double _dragStartX = 0;
  int _dragStartIndexLeft = 0;
  int _dragStartIndexRight = 0;

  @override
  void initState() {
    super.initState();
    _startIndex = widget.startIndex;
    _endIndex = widget.endIndex;
  }

  @override
  void didUpdateWidget(BrushWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.startIndex != oldWidget.startIndex) {
      _startIndex = widget.startIndex;
    }
    if (widget.endIndex != oldWidget.endIndex) {
      _endIndex = widget.endIndex;
    }
  }

  double _indexToX(int index) {
    final dataLength = widget.data.length;
    if (dataLength <= 1) return 0;
    final handleWidth = widget.config.handleWidth;
    final usableWidth = widget.width - handleWidth * 2;
    return handleWidth + (index / (dataLength - 1)) * usableWidth;
  }

  int _xToIndex(double x) {
    final dataLength = widget.data.length;
    if (dataLength <= 1) return 0;
    final handleWidth = widget.config.handleWidth;
    final usableWidth = widget.width - handleWidth * 2;
    final normalizedX = (x - handleWidth) / usableWidth;
    return (normalizedX * (dataLength - 1)).round().clamp(0, dataLength - 1);
  }

  void _onPointerDown(PointerDownEvent event) {
    final x = event.localPosition.dx;
    final handleWidth = widget.config.handleWidth;

    final leftHandleStart = _indexToX(_startIndex) - handleWidth;
    final leftHandleEnd = _indexToX(_startIndex);
    final rightHandleStart = _indexToX(_endIndex);
    final rightHandleEnd = _indexToX(_endIndex) + handleWidth;

    if (x >= leftHandleStart && x <= leftHandleEnd) {
      _isDraggingLeft = true;
      _dragStartX = x;
      _dragStartIndexLeft = _startIndex;
    } else if (x >= rightHandleStart && x <= rightHandleEnd) {
      _isDraggingRight = true;
      _dragStartX = x;
      _dragStartIndexRight = _endIndex;
    } else if (x > leftHandleEnd && x < rightHandleStart) {
      _isDraggingCenter = true;
      _dragStartX = x;
      _dragStartIndexLeft = _startIndex;
      _dragStartIndexRight = _endIndex;
    }
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (!_isDraggingLeft && !_isDraggingRight && !_isDraggingCenter) return;

    final x = event.localPosition.dx;
    final dataLength = widget.data.length;

    if (_isDraggingLeft) {
      final newIndex = _xToIndex(x);
      final clampedIndex = newIndex.clamp(0, _endIndex - 1);
      if (clampedIndex != _startIndex) {
        setState(() {
          _startIndex = clampedIndex;
        });
        widget.onChange?.call(_startIndex, _endIndex);
      }
    } else if (_isDraggingRight) {
      final newIndex = _xToIndex(x);
      final clampedIndex = newIndex.clamp(_startIndex + 1, dataLength - 1);
      if (clampedIndex != _endIndex) {
        setState(() {
          _endIndex = clampedIndex;
        });
        widget.onChange?.call(_startIndex, _endIndex);
      }
    } else if (_isDraggingCenter) {
      final dx = x - _dragStartX;
      final indexDelta = _xToIndex(_dragStartX + dx) - _xToIndex(_dragStartX);
      final windowSize = _dragStartIndexRight - _dragStartIndexLeft;

      var newStart = _dragStartIndexLeft + indexDelta;
      var newEnd = _dragStartIndexRight + indexDelta;

      if (newStart < 0) {
        newStart = 0;
        newEnd = windowSize;
      }
      if (newEnd >= dataLength) {
        newEnd = dataLength - 1;
        newStart = newEnd - windowSize;
      }

      if (newStart != _startIndex || newEnd != _endIndex) {
        setState(() {
          _startIndex = newStart;
          _endIndex = newEnd;
        });
        widget.onChange?.call(_startIndex, _endIndex);
      }
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    _isDraggingLeft = false;
    _isDraggingRight = false;
    _isDraggingCenter = false;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Listener(
        onPointerDown: _onPointerDown,
        onPointerMove: _onPointerMove,
        onPointerUp: _onPointerUp,
        child: CustomPaint(
          size: Size(widget.width, widget.height),
          painter: _BrushPainter(
            config: widget.config,
            data: widget.data,
            xDataKey: widget.xDataKey,
            yDataKey: widget.yDataKey,
            startIndex: _startIndex,
            endIndex: _endIndex,
          ),
        ),
      ),
    );
  }
}

class _BrushPainter extends CustomPainter {
  final ChartBrush config;
  final ChartDataSet data;
  final String? xDataKey;
  final String? yDataKey;
  final int startIndex;
  final int endIndex;

  _BrushPainter({
    required this.config,
    required this.data,
    this.xDataKey,
    this.yDataKey,
    required this.startIndex,
    required this.endIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final handleWidth = config.handleWidth;
    final chartArea = Rect.fromLTWH(
      handleWidth,
      0,
      size.width - handleWidth * 2,
      size.height,
    );

    _paintMiniChart(canvas, chartArea);

    _paintSelection(canvas, size, chartArea);

    _paintHandles(canvas, size);
  }

  void _paintMiniChart(Canvas canvas, Rect chartArea) {
    if (yDataKey == null || data.isEmpty) return;

    final extent = data.getExtent(yDataKey!);
    if (extent == null) return;

    final xDomain = List.generate(data.length, (i) => i);
    final xScale = BandScale(
      domain: xDomain,
      range: [chartArea.left, chartArea.right],
      paddingInner: 0.1,
      paddingOuter: 0.1,
    );

    final yScale = LinearScale(
      domain: [0, extent.$2],
      range: [chartArea.bottom, chartArea.top],
    );

    final paint = Paint()
      ..color = config.stroke.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final path = Path();
    bool first = true;

    for (int i = 0; i < data.length; i++) {
      final yValue = data[i].getNumericValue(yDataKey!);
      if (yValue == null) continue;

      final x = xScale(i) + xScale.bandwidth / 2;
      final y = yScale(yValue);

      if (first) {
        path.moveTo(x, y);
        first = false;
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  void _paintSelection(Canvas canvas, Size size, Rect chartArea) {
    final dataLength = data.length;
    if (dataLength <= 1) return;

    final handleWidth = config.handleWidth;

    double indexToX(int index) {
      final usableWidth = size.width - handleWidth * 2;
      return handleWidth + (index / (dataLength - 1)) * usableWidth;
    }

    final leftX = indexToX(startIndex);
    final rightX = indexToX(endIndex);

    final leftMask = Paint()..color = config.fill.withValues(alpha: 0.5);
    canvas.drawRect(
      Rect.fromLTRB(handleWidth, 0, leftX, size.height),
      leftMask,
    );

    final rightMask = Paint()..color = config.fill.withValues(alpha: 0.5);
    canvas.drawRect(
      Rect.fromLTRB(rightX, 0, size.width - handleWidth, size.height),
      rightMask,
    );

    final selectionStroke = Paint()
      ..color = config.stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRect(
      Rect.fromLTRB(leftX, 0, rightX, size.height),
      selectionStroke,
    );
  }

  void _paintHandles(Canvas canvas, Size size) {
    final dataLength = data.length;
    if (dataLength <= 1) return;

    final handleWidth = config.handleWidth;

    double indexToX(int index) {
      final usableWidth = size.width - handleWidth * 2;
      return handleWidth + (index / (dataLength - 1)) * usableWidth;
    }

    final leftX = indexToX(startIndex);
    final rightX = indexToX(endIndex);

    final handleFill = Paint()..color = config.handleFill;
    final handleStroke = Paint()
      ..color = config.handleStroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final leftHandle = Rect.fromLTRB(
      leftX - handleWidth,
      0,
      leftX,
      size.height,
    );
    canvas.drawRect(leftHandle, handleFill);
    canvas.drawRect(leftHandle, handleStroke);

    final rightHandle = Rect.fromLTRB(
      rightX,
      0,
      rightX + handleWidth,
      size.height,
    );
    canvas.drawRect(rightHandle, handleFill);
    canvas.drawRect(rightHandle, handleStroke);

    final gripPaint = Paint()
      ..color = config.handleStroke
      ..strokeWidth = 1;

    for (int i = -1; i <= 1; i++) {
      final y = size.height / 2 + i * 4;
      canvas.drawLine(
        Offset(leftX - handleWidth / 2 - 2, y),
        Offset(leftX - handleWidth / 2 + 2, y),
        gripPaint,
      );
      canvas.drawLine(
        Offset(rightX + handleWidth / 2 - 2, y),
        Offset(rightX + handleWidth / 2 + 2, y),
        gripPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BrushPainter oldDelegate) {
    return startIndex != oldDelegate.startIndex ||
        endIndex != oldDelegate.endIndex ||
        data != oldDelegate.data;
  }
}
