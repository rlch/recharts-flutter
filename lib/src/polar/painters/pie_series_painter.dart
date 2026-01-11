import 'package:flutter/rendering.dart';

import '../../state/models/polar_data.dart';
import '../series/pie_series.dart';
import '../../core/utils/polar_utils.dart';

class PieSeriesPainter {
  final PieSeries series;
  final List<SectorGeometry> sectors;
  final List<SectorGeometry>? previousSectors;
  final double animationProgress;

  PieSeriesPainter({
    required this.series,
    required this.sectors,
    this.previousSectors,
    this.animationProgress = 1.0,
  });

  void paint(Canvas canvas, Size size) {
    if (sectors.isEmpty) return;

    for (final sector in sectors) {
      final animatedSector = _getAnimatedSector(sector);
      _paintSector(canvas, animatedSector);

      if (series.label && animationProgress >= 1.0) {
        _paintLabel(canvas, sector);
      }
    }
  }

  SectorGeometry _getAnimatedSector(SectorGeometry sector) {
    if (previousSectors == null || animationProgress >= 1.0) {
      return sector.copyWith(
        startAngle: _lerpAngle(sector.startAngle, sector.startAngle, animationProgress),
        endAngle: _lerpAngle(sector.startAngle, sector.endAngle, animationProgress),
      );
    }

    final prev = previousSectors!.length > sector.index
        ? previousSectors![sector.index]
        : null;

    if (prev == null) {
      return sector.copyWith(
        endAngle: _lerp(sector.startAngle, sector.endAngle, animationProgress),
      );
    }

    return sector.copyWith(
      startAngle: _lerp(prev.startAngle, sector.startAngle, animationProgress),
      endAngle: _lerp(prev.endAngle, sector.endAngle, animationProgress),
      innerRadius: _lerp(prev.innerRadius, sector.innerRadius, animationProgress),
      outerRadius: _lerp(prev.outerRadius, sector.outerRadius, animationProgress),
    );
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;

  double _lerpAngle(double a, double b, double t) {
    return a + (b - a) * t;
  }

  void _paintSector(Canvas canvas, SectorGeometry sector) {
    final path = _createSectorPath(sector);

    final fillPaint = Paint()
      ..color = sector.color
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, fillPaint);

    if (series.stroke != null && series.strokeWidth > 0) {
      final strokePaint = Paint()
        ..color = series.stroke!
        ..style = PaintingStyle.stroke
        ..strokeWidth = series.strokeWidth;

      canvas.drawPath(path, strokePaint);
    }
  }

  Path _createSectorPath(SectorGeometry sector) {
    final path = Path();

    final startAngleRad = degreeToRadian(sector.startAngle);
    final endAngleRad = degreeToRadian(sector.endAngle);
    final sweepAngle = endAngleRad - startAngleRad;

    if (sector.innerRadius > 0) {
      final outerStart = polarToCartesian(
        sector.cx,
        sector.cy,
        sector.outerRadius,
        sector.startAngle,
      );
      path.moveTo(outerStart.x, outerStart.y);

      path.arcTo(
        Rect.fromCircle(
          center: Offset(sector.cx, sector.cy),
          radius: sector.outerRadius,
        ),
        -startAngleRad,
        -sweepAngle,
        false,
      );

      final innerEnd = polarToCartesian(
        sector.cx,
        sector.cy,
        sector.innerRadius,
        sector.endAngle,
      );
      path.lineTo(innerEnd.x, innerEnd.y);

      path.arcTo(
        Rect.fromCircle(
          center: Offset(sector.cx, sector.cy),
          radius: sector.innerRadius,
        ),
        -endAngleRad,
        sweepAngle,
        false,
      );

      path.close();
    } else {
      path.moveTo(sector.cx, sector.cy);

      final startPoint = polarToCartesian(
        sector.cx,
        sector.cy,
        sector.outerRadius,
        sector.startAngle,
      );
      path.lineTo(startPoint.x, startPoint.y);

      path.arcTo(
        Rect.fromCircle(
          center: Offset(sector.cx, sector.cy),
          radius: sector.outerRadius,
        ),
        -startAngleRad,
        -sweepAngle,
        false,
      );

      path.close();
    }

    return path;
  }

  void _paintLabel(Canvas canvas, SectorGeometry sector) {
    final labelRadius = (sector.innerRadius + sector.outerRadius) / 2;
    final labelAngle = sector.midAngle;
    final labelPos = polarToCartesian(sector.cx, sector.cy, labelRadius, labelAngle);

    final text = '${(sector.percent * 100).toStringAsFixed(1)}%';

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(
        labelPos.x - textPainter.width / 2,
        labelPos.y - textPainter.height / 2,
      ),
    );
  }
}
