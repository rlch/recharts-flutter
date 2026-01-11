import 'package:flutter/rendering.dart';

import '../polar_layout.dart';
import '../grid/polar_grid.dart';
import '../axis/polar_angle_axis.dart';
import '../axis/polar_radius_axis.dart';
import '../series/pie_series.dart';
import '../series/radial_bar_series.dart';
import '../series/radar_series.dart';
import '../../state/models/polar_data.dart';
import 'polar_grid_painter.dart';
import 'polar_angle_axis_painter.dart';
import 'polar_radius_axis_painter.dart';
import 'pie_series_painter.dart';
import 'radial_bar_series_painter.dart';
import 'radar_series_painter.dart';

class PolarChartPainter extends CustomPainter {
  final PolarLayout layout;
  final PolarGrid? grid;
  final PolarAngleAxis? angleAxis;
  final PolarRadiusAxis? radiusAxis;
  final List<PieSeries> pieSeries;
  final List<RadialBarSeries> radialBarSeries;
  final List<RadarSeries> radarSeries;
  final Map<String, List<SectorGeometry>> pieSectorsMap;
  final Map<String, List<RadialBarGeometry>> radialBarsMap;
  final Map<String, List<RadarPoint>> radarPointsMap;
  final Map<String, List<SectorGeometry>>? previousPieSectorsMap;
  final Map<String, List<RadialBarGeometry>>? previousRadialBarsMap;
  final Map<String, List<RadarPoint>>? previousRadarPointsMap;
  final double animationProgress;
  final List<String> angleLabels;
  final List<num> radiusTicks;
  final double radiusMax;
  final int dataPointCount;
  final int? activeIndex;

  PolarChartPainter({
    required this.layout,
    this.grid,
    this.angleAxis,
    this.radiusAxis,
    required this.pieSeries,
    required this.radialBarSeries,
    required this.radarSeries,
    required this.pieSectorsMap,
    required this.radialBarsMap,
    required this.radarPointsMap,
    this.previousPieSectorsMap,
    this.previousRadialBarsMap,
    this.previousRadarPointsMap,
    this.animationProgress = 1.0,
    this.angleLabels = const [],
    this.radiusTicks = const [],
    this.radiusMax = 0,
    this.dataPointCount = 0,
    this.activeIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    _paintGrid(canvas, size);

    _paintRadialBars(canvas, size);
    _paintPies(canvas, size);
    _paintRadars(canvas, size);

    _paintAxes(canvas, size);
  }

  void _paintGrid(Canvas canvas, Size size) {
    if (grid == null) return;

    final gridPainter = PolarGridPainter(
      grid: grid!,
      layout: layout,
      dataPointCount: dataPointCount,
    );
    gridPainter.paint(canvas, size);
  }

  void _paintAxes(Canvas canvas, Size size) {
    if (angleAxis != null && angleLabels.isNotEmpty) {
      final axisPainter = PolarAngleAxisPainter(
        axis: angleAxis!,
        layout: layout,
        labels: angleLabels,
      );
      axisPainter.paint(canvas, size);
    }

    if (radiusAxis != null && radiusTicks.isNotEmpty) {
      final axisPainter = PolarRadiusAxisPainter(
        axis: radiusAxis!,
        layout: layout,
        ticks: radiusTicks,
        maxValue: radiusMax,
      );
      axisPainter.paint(canvas, size);
    }
  }

  void _paintPies(Canvas canvas, Size size) {
    for (final series in pieSeries) {
      final sectors = pieSectorsMap[series.dataKey];
      if (sectors == null || sectors.isEmpty) continue;

      final previousSectors = previousPieSectorsMap?[series.dataKey];

      final painter = PieSeriesPainter(
        series: series,
        sectors: sectors,
        previousSectors: previousSectors,
        animationProgress: animationProgress,
      );
      painter.paint(canvas, size);
    }
  }

  void _paintRadialBars(Canvas canvas, Size size) {
    for (final series in radialBarSeries) {
      final bars = radialBarsMap[series.dataKey];
      if (bars == null || bars.isEmpty) continue;

      final previousBars = previousRadialBarsMap?[series.dataKey];

      final painter = RadialBarSeriesPainter(
        series: series,
        bars: bars,
        previousBars: previousBars,
        animationProgress: animationProgress,
      );
      painter.paint(canvas, size);
    }
  }

  void _paintRadars(Canvas canvas, Size size) {
    for (final series in radarSeries) {
      final points = radarPointsMap[series.dataKey];
      if (points == null || points.isEmpty) continue;

      final previousPoints = previousRadarPointsMap?[series.dataKey];

      final painter = RadarSeriesPainter(
        series: series,
        points: points,
        previousPoints: previousPoints,
        animationProgress: animationProgress,
      );
      painter.paint(canvas, size);
    }
  }

  @override
  bool shouldRepaint(covariant PolarChartPainter oldDelegate) {
    return animationProgress != oldDelegate.animationProgress ||
        pieSectorsMap != oldDelegate.pieSectorsMap ||
        radialBarsMap != oldDelegate.radialBarsMap ||
        radarPointsMap != oldDelegate.radarPointsMap ||
        activeIndex != oldDelegate.activeIndex;
  }
}
