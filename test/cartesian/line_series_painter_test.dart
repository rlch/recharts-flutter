import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recharts_flutter/src/cartesian/painters/line_series_painter.dart';
import 'package:recharts_flutter/src/cartesian/series/line_series.dart';
import 'package:recharts_flutter/src/state/models/computed_data.dart';

void main() {
  group('LineSeries', () {
    test('supports strokeDasharray and copyWith', () {
      const base = LineSeries(dataKey: 'value', strokeDasharray: [4, 4]);

      final updated = base.copyWith(strokeDasharray: [2, 6, 2, 6]);

      expect(base.strokeDasharray, [4, 4]);
      expect(updated.strokeDasharray, [2, 6, 2, 6]);
    });
  });

  group('LineSeriesPainter', () {
    test('renders visible gaps for dashed lines', () async {
      final solidImage = await _paintLine(
        const LineSeries(
          dataKey: 'value',
          stroke: Colors.black,
          strokeWidth: 2,
          dot: false,
        ),
      );

      final dashedImage = await _paintLine(
        const LineSeries(
          dataKey: 'value',
          stroke: Colors.black,
          strokeWidth: 2,
          dot: false,
          strokeDasharray: [4, 4],
        ),
      );

      final solidGapAlpha = await _alphaAt(solidImage, 16, 20);
      final dashedDrawAlpha = await _alphaAt(dashedImage, 12, 20);
      final dashedGapAlpha = await _alphaAt(dashedImage, 16, 20);

      expect(solidGapAlpha, greaterThan(0));
      expect(dashedDrawAlpha, greaterThan(0));
      expect(dashedGapAlpha, lessThan(solidGapAlpha));
      expect(dashedGapAlpha, lessThanOrEqualTo(16));
    });
  });
}

Future<ui.Image> _paintLine(LineSeries series) {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

  final painter = LineSeriesPainter(
    series: series,
    points: const [
      LinePoint(index: 0, x: 10, y: 20),
      LinePoint(index: 1, x: 90, y: 20),
    ],
  );

  painter.paint(canvas, const Size(100, 40));
  return recorder.endRecording().toImage(100, 40);
}

Future<int> _alphaAt(ui.Image image, int x, int y) async {
  final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
  if (byteData == null) {
    throw StateError('Failed to read image bytes');
  }

  final rgba = byteData.buffer.asUint8List();
  final pixelIndex = (y * image.width + x) * 4;
  return rgba[pixelIndex + 3];
}
