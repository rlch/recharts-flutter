import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recharts_flutter/src/cartesian/reference/reference.dart';

void main() {
  group('ReferenceLine', () {
    test('creates horizontal line with y value', () {
      const line = ReferenceLine(y: 100);

      expect(line.y, 100);
      expect(line.x, isNull);
      expect(line.effectiveOrientation, ReferenceLineOrientation.horizontal);
    });

    test('creates vertical line with x value', () {
      const line = ReferenceLine(x: 'A');

      expect(line.x, 'A');
      expect(line.y, isNull);
      expect(line.effectiveOrientation, ReferenceLineOrientation.vertical);
    });

    test('explicit orientation overrides default', () {
      const line = ReferenceLine(
        y: 100,
        orientation: ReferenceLineOrientation.vertical,
      );

      expect(line.effectiveOrientation, ReferenceLineOrientation.vertical);
    });

    test('has correct default values', () {
      const line = ReferenceLine(y: 100);

      expect(line.stroke, const Color(0xFFCCCCCC));
      expect(line.strokeWidth, 1);
      expect(line.isFront, false);
      expect(line.labelPosition, ReferenceLineLabelPosition.end);
    });

    test('copyWith creates new line with updated values', () {
      const line = ReferenceLine(y: 100);

      final updated = line.copyWith(
        y: 200,
        stroke: Colors.red,
        label: 'Target',
      );

      expect(updated.y, 200);
      expect(updated.stroke, Colors.red);
      expect(updated.label, 'Target');
    });
  });

  group('ReferenceArea', () {
    test('isHorizontal when only y values provided', () {
      const area = ReferenceArea(y1: 100, y2: 200);

      expect(area.isHorizontal, true);
      expect(area.isVertical, false);
      expect(area.isRect, false);
    });

    test('isVertical when only x values provided', () {
      const area = ReferenceArea(x1: 'A', x2: 'C');

      expect(area.isVertical, true);
      expect(area.isHorizontal, false);
      expect(area.isRect, false);
    });

    test('isRect when both x and y values provided', () {
      const area = ReferenceArea(x1: 'A', x2: 'C', y1: 100, y2: 200);

      expect(area.isRect, true);
      expect(area.isHorizontal, false);
      expect(area.isVertical, false);
    });

    test('has correct default values', () {
      const area = ReferenceArea(y1: 100, y2: 200);

      expect(area.fill, const Color(0xFFCCCCCC));
      expect(area.fillOpacity, 0.5);
      expect(area.strokeWidth, 0);
      expect(area.isFront, false);
    });

    test('copyWith creates new area with updated values', () {
      const area = ReferenceArea(y1: 100, y2: 200);

      final updated = area.copyWith(
        y2: 300,
        fill: Colors.blue,
        label: 'Target Zone',
      );

      expect(updated.y1, 100);
      expect(updated.y2, 300);
      expect(updated.fill, Colors.blue);
      expect(updated.label, 'Target Zone');
    });
  });

  group('ReferenceDot', () {
    test('creates with x and y coordinates', () {
      const dot = ReferenceDot(x: 'B', y: 150);

      expect(dot.x, 'B');
      expect(dot.y, 150);
    });

    test('has correct default values', () {
      const dot = ReferenceDot(x: 'B', y: 150);

      expect(dot.r, 10);
      expect(dot.fill, const Color(0xFF8884d8));
      expect(dot.strokeWidth, 0);
      expect(dot.labelPosition, ReferenceDotLabelPosition.top);
      expect(dot.isFront, false);
    });

    test('copyWith creates new dot with updated values', () {
      const dot = ReferenceDot(x: 'B', y: 150);

      final updated = dot.copyWith(
        y: 200,
        r: 15,
        fill: Colors.green,
        label: 'Peak',
      );

      expect(updated.x, 'B');
      expect(updated.y, 200);
      expect(updated.r, 15);
      expect(updated.fill, Colors.green);
      expect(updated.label, 'Peak');
    });
  });

  group('ReferenceDotLabelPosition', () {
    test('has all expected values', () {
      expect(ReferenceDotLabelPosition.values, contains(ReferenceDotLabelPosition.top));
      expect(ReferenceDotLabelPosition.values, contains(ReferenceDotLabelPosition.right));
      expect(ReferenceDotLabelPosition.values, contains(ReferenceDotLabelPosition.bottom));
      expect(ReferenceDotLabelPosition.values, contains(ReferenceDotLabelPosition.left));
      expect(ReferenceDotLabelPosition.values, contains(ReferenceDotLabelPosition.center));
    });
  });

  group('ReferenceLineLabelPosition', () {
    test('has all expected values', () {
      expect(ReferenceLineLabelPosition.values, contains(ReferenceLineLabelPosition.start));
      expect(ReferenceLineLabelPosition.values, contains(ReferenceLineLabelPosition.center));
      expect(ReferenceLineLabelPosition.values, contains(ReferenceLineLabelPosition.end));
      expect(ReferenceLineLabelPosition.values, contains(ReferenceLineLabelPosition.insideStart));
      expect(ReferenceLineLabelPosition.values, contains(ReferenceLineLabelPosition.insideEnd));
    });
  });
}
