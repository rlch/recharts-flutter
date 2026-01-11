import 'package:flutter/rendering.dart';

import '../axis/x_axis.dart';
import '../axis/y_axis.dart';
import '../grid/cartesian_grid.dart';
import '../series/line_series.dart';
import '../series/area_series.dart';
import '../series/bar_series.dart';
import 'axis_painter.dart';
import 'grid_painter.dart';
import 'line_series_painter.dart';
import 'area_series_painter.dart';
import 'bar_series_painter.dart';
import '../../core/scale/scale.dart';
import '../../state/models/chart_layout.dart';
import '../../state/models/computed_data.dart';

class CartesianChartPainter extends CustomPainter {
  final ChartLayout layout;
  final CartesianGrid? grid;
  final List<XAxis> xAxes;
  final List<YAxis> yAxes;
  final List<LineSeries> lineSeries;
  final List<AreaSeries> areaSeries;
  final List<BarSeries> barSeries;
  final Scale<dynamic, double> xScale;
  final Scale<dynamic, double> yScale;
  final Map<String, List<LinePoint>> linePointsMap;
  final Map<String, List<AreaPoint>> areaPointsMap;
  final Map<String, List<BarRect>> barRectsMap;

  CartesianChartPainter({
    required this.layout,
    this.grid,
    required this.xAxes,
    required this.yAxes,
    required this.lineSeries,
    required this.areaSeries,
    required this.barSeries,
    required this.xScale,
    required this.yScale,
    required this.linePointsMap,
    required this.areaPointsMap,
    required this.barRectsMap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    _paintGrid(canvas, size);

    _paintAreas(canvas, size);

    _paintBars(canvas, size);

    _paintLines(canvas, size);

    _paintAxes(canvas, size);
  }

  void _paintGrid(Canvas canvas, Size size) {
    if (grid == null) return;

    final horizontalLines = <double>[];
    final verticalLines = <double>[];

    if (grid!.horizontalPoints != null) {
      horizontalLines.addAll(grid!.horizontalPoints!);
    } else {
      final yTicks = yScale.ticks(5);
      for (final tick in yTicks) {
        horizontalLines.add(yScale(tick));
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

      final painter = AreaSeriesPainter(series: series, points: points);
      painter.paint(canvas, size);
    }
  }

  void _paintBars(Canvas canvas, Size size) {
    for (final series in barSeries) {
      final rects = barRectsMap[series.dataKey];
      if (rects == null || rects.isEmpty) continue;

      final painter = BarSeriesPainter(series: series, rects: rects);
      painter.paint(canvas, size);
    }
  }

  void _paintLines(Canvas canvas, Size size) {
    for (final series in lineSeries) {
      final points = linePointsMap[series.dataKey];
      if (points == null || points.isEmpty) continue;

      final painter = LineSeriesPainter(series: series, points: points);
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
  bool shouldRepaint(covariant CartesianChartPainter oldDelegate) {
    return true;
  }
}
