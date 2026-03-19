import 'package:flutter/rendering.dart';

import '../axis/x_axis.dart';
import '../axis/y_axis.dart';
import '../grid/cartesian_grid.dart';
import '../series/line_series.dart';
import '../series/area_series.dart';
import '../series/bar_series.dart';
import '../reference/reference_line.dart';
import '../reference/reference_line_painter.dart';
import 'axis_painter.dart';
import 'grid_painter.dart';
import 'animated_line_series_painter.dart';
import 'animated_area_series_painter.dart';
import 'animated_bar_series_painter.dart';
import 'cursor_painter.dart';
import '../../core/scale/scale.dart';
import '../../state/models/chart_layout.dart';
import '../../state/models/computed_data.dart';
import '../../components/tooltip/tooltip_types.dart';

class AnimatedCartesianChartPainter extends CustomPainter {
  final ChartLayout layout;
  final CartesianGrid? grid;
  final List<XAxis> xAxes;
  final List<YAxis> yAxes;
  final List<LineSeries> lineSeries;
  final List<AreaSeries> areaSeries;
  final List<BarSeries> barSeries;
  final List<ReferenceLine> referenceLines;
  final Scale<dynamic, double> xScale;
  final Scale<dynamic, double> yScale;
  final Map<String, List<LinePoint>> linePointsMap;
  final Map<String, List<AreaPoint>> areaPointsMap;
  final Map<String, List<BarRect>> barRectsMap;
  final Map<String, List<LinePoint>>? previousLinePointsMap;
  final Map<String, List<AreaPoint>>? previousAreaPointsMap;
  final Map<String, List<BarRect>>? previousBarRectsMap;
  final double animationProgress;
  final CursorConfig? cursorConfig;
  final double? activeX;
  final List<Offset?> activePoints;

  AnimatedCartesianChartPainter({
    required this.layout,
    this.grid,
    required this.xAxes,
    required this.yAxes,
    required this.lineSeries,
    required this.areaSeries,
    required this.barSeries,
    this.referenceLines = const [],
    required this.xScale,
    required this.yScale,
    required this.linePointsMap,
    required this.areaPointsMap,
    required this.barRectsMap,
    this.previousLinePointsMap,
    this.previousAreaPointsMap,
    this.previousBarRectsMap,
    this.animationProgress = 1.0,
    this.cursorConfig,
    this.activeX,
    this.activePoints = const [],
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    _paintGrid(canvas, size);

    _paintReferenceLines(canvas, size, isFront: false);

    _paintAreas(canvas, size);

    _paintBars(canvas, size);

    _paintLines(canvas, size);

    _paintAxes(canvas, size);

    _paintReferenceLines(canvas, size, isFront: true);

    _paintCursor(canvas, size);
  }

  void _paintReferenceLines(Canvas canvas, Size size, {required bool isFront}) {
    for (final line in referenceLines) {
      if (line.isFront != isFront) continue;

      final painter = ReferenceLinePainter(
        line: line,
        layout: layout,
        xScale: xScale,
        yScale: yScale,
      );
      painter.paint(canvas, size);
    }
  }

  void _paintCursor(Canvas canvas, Size size) {
    if (cursorConfig == null || activeX == null) return;

    final seriesColors = <Color>[
      ...lineSeries.map((s) => s.stroke),
      ...areaSeries.map((s) => s.stroke),
      ...barSeries.map((s) => s.fill),
    ];

    final cursorPainter = CursorPainter(
      config: cursorConfig!,
      layout: layout,
      activeX: activeX,
      activePoints: activePoints,
      seriesColors: seriesColors,
    );
    cursorPainter.paint(canvas, size);
  }

  void _paintGrid(Canvas canvas, Size size) {
    if (grid == null) return;

    final horizontalLines = <double>[];
    final verticalLines = <double>[];

    if (grid!.horizontalPoints != null) {
      horizontalLines.addAll(grid!.horizontalPoints!);
    } else {
      final yTicks = yScale.ticks(5);
      final yBandwidth = yScale.bandwidth ?? 0;
      for (final tick in yTicks) {
        horizontalLines.add(yScale(tick) + yBandwidth / 2);
      }
    }

    if (grid!.verticalPoints != null) {
      verticalLines.addAll(grid!.verticalPoints!);
    } else {
      final xTicks = xScale.ticks(5);
      final bandwidth = xScale.bandwidth ?? 0;
      for (final tick in xTicks) {
        verticalLines.add(xScale(tick) + bandwidth / 2);
      }
    }

    final gridPainter = GridPainter(
      grid: grid!,
      layout: layout,
      horizontalLines: horizontalLines,
      verticalLines: verticalLines,
    );
    gridPainter.paint(canvas, size);
  }

  void _paintAreas(Canvas canvas, Size size) {
    for (final series in areaSeries) {
      final points = areaPointsMap[series.dataKey];
      if (points == null || points.isEmpty) continue;

      final previousPoints = previousAreaPointsMap?[series.dataKey];

      final painter = AnimatedAreaSeriesPainter(
        series: series,
        currentPoints: points,
        previousPoints: previousPoints,
        animationProgress: animationProgress,
      );
      painter.paint(canvas, size);
    }
  }

  void _paintBars(Canvas canvas, Size size) {
    for (final series in barSeries) {
      final rects = barRectsMap[series.dataKey];
      if (rects == null || rects.isEmpty) continue;

      final previousRects = previousBarRectsMap?[series.dataKey];

      final painter = AnimatedBarSeriesPainter(
        series: series,
        currentRects: rects,
        previousRects: previousRects,
        animationProgress: animationProgress,
      );
      painter.paint(canvas, size);
    }
  }

  void _paintLines(Canvas canvas, Size size) {
    for (final series in lineSeries) {
      final points = linePointsMap[series.dataKey];
      if (points == null || points.isEmpty) continue;

      final previousPoints = previousLinePointsMap?[series.dataKey];

      final painter = AnimatedLineSeriesPainter(
        series: series,
        currentPoints: points,
        previousPoints: previousPoints,
        animationProgress: animationProgress,
      );
      painter.paint(canvas, size);
    }
  }

  void _paintAxes(Canvas canvas, Size size) {
    for (final axis in xAxes) {
      if (axis.hide) continue;

      final axisY = axis.orientation == AxisOrientation.top
          ? layout.plotTop
          : layout.plotBottom;

      final painter = AxisPainter.fromXAxis(
        axis: axis,
        scale: xScale,
        axisY: axisY,
        plotLeft: layout.plotLeft,
        plotRight: layout.plotRight,
      );
      painter.paint(canvas, size);
    }

    for (final axis in yAxes) {
      if (axis.hide) continue;

      final axisX = axis.orientation == AxisOrientation.right
          ? layout.plotRight
          : layout.plotLeft;

      final painter = AxisPainter.fromYAxis(
        axis: axis,
        scale: yScale,
        axisX: axisX,
        plotTop: layout.plotTop,
        plotBottom: layout.plotBottom,
      );
      painter.paint(canvas, size);
    }
  }

  @override
  bool shouldRepaint(covariant AnimatedCartesianChartPainter oldDelegate) {
    return animationProgress != oldDelegate.animationProgress ||
        referenceLines != oldDelegate.referenceLines ||
        linePointsMap != oldDelegate.linePointsMap ||
        areaPointsMap != oldDelegate.areaPointsMap ||
        barRectsMap != oldDelegate.barRectsMap ||
        activeX != oldDelegate.activeX;
  }
}
