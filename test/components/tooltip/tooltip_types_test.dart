import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:recharts_flutter/src/components/tooltip/tooltip_types.dart';

void main() {
  group('TooltipEntry', () {
    test('formats integer value correctly', () {
      const entry = TooltipEntry(
        name: 'Test',
        value: 100,
        color: Color(0xFF8884d8),
      );

      expect(entry.formattedValue, '100');
    });

    test('formats double value correctly', () {
      const entry = TooltipEntry(
        name: 'Test',
        value: 123.45,
        color: Color(0xFF8884d8),
      );

      expect(entry.formattedValue, '123.45');
    });

    test('formats whole double without decimals', () {
      const entry = TooltipEntry(
        name: 'Test',
        value: 100.0,
        color: Color(0xFF8884d8),
      );

      expect(entry.formattedValue, '100');
    });

    test('handles null value', () {
      const entry = TooltipEntry(
        name: 'Test',
        value: null,
        color: Color(0xFF8884d8),
      );

      expect(entry.formattedValue, '');
    });

    test('handles string value', () {
      const entry = TooltipEntry(
        name: 'Test',
        value: 'Hello',
        color: Color(0xFF8884d8),
      );

      expect(entry.formattedValue, 'Hello');
    });

    test('formats tooltip as percentage when enabled', () {
      const entry = TooltipEntry(
        name: 'Test',
        value: 100,
        color: Color(0xFF8884d8),
        percentValue: 0.375,
        usePercentTooltipLabel: true,
      );

      expect(entry.formattedValue, '38%');
      expect(entry.formattedPercentValue, '38%');
    });
  });

  group('TooltipPayload', () {
    test('isEmpty returns true when no entries', () {
      const payload = TooltipPayload(
        index: 0,
        label: 'Test',
        entries: [],
        coordinate: Offset.zero,
      );

      expect(payload.isEmpty, true);
      expect(payload.isNotEmpty, false);
    });

    test('isNotEmpty returns true when has entries', () {
      const payload = TooltipPayload(
        index: 0,
        label: 'Test',
        entries: [
          TooltipEntry(name: 'A', value: 100, color: Color(0xFF8884d8)),
        ],
        coordinate: Offset.zero,
      );

      expect(payload.isEmpty, false);
      expect(payload.isNotEmpty, true);
    });

    test('stores all properties correctly', () {
      const payload = TooltipPayload(
        index: 5,
        label: 'May',
        entries: [
          TooltipEntry(name: 'Value', value: 250, color: Color(0xFF8884d8)),
          TooltipEntry(name: 'Value2', value: 180, color: Color(0xFF82ca9d)),
        ],
        coordinate: Offset(100, 150),
      );

      expect(payload.index, 5);
      expect(payload.label, 'May');
      expect(payload.entries.length, 2);
      expect(payload.coordinate, const Offset(100, 150));
    });
  });

  group('CursorConfig', () {
    test('has correct defaults', () {
      const config = CursorConfig();

      expect(config.show, true);
      expect(config.color, const Color(0xFF999999));
      expect(config.strokeWidth, 1);
      expect(config.dashPattern, [4, 4]);
      expect(config.activeDotRadius, 6);
      expect(config.activeDotStrokeWidth, 2);
    });

    test('copyWith works correctly', () {
      const config = CursorConfig();
      final updated = config.copyWith(
        show: false,
        color: const Color(0xFF000000),
        strokeWidth: 2,
      );

      expect(updated.show, false);
      expect(updated.color, const Color(0xFF000000));
      expect(updated.strokeWidth, 2);
      expect(updated.dashPattern, config.dashPattern);
    });
  });
}
