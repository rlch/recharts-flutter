import 'package:flutter_test/flutter_test.dart';
import 'package:recharts_flutter/src/core/scale/point_scale.dart';

void main() {
  group('PointScale', () {
    group('constructor', () {
      test('creates with default values', () {
        final scale = PointScale<String>();
        expect(scale.domain, []);
        expect(scale.range, [0, 1]);
      });

      test('creates with custom domain and range', () {
        final scale = PointScale<String>(
          domain: ['a', 'b', 'c'],
          range: [0, 300],
        );
        expect(scale.domain, ['a', 'b', 'c']);
        expect(scale.range, [0, 300]);
      });
    });

    group('call', () {
      test('maps domain values to point positions', () {
        final scale = PointScale<String>(
          domain: ['a', 'b', 'c'],
          range: [0, 200],
        );

        expect(scale('a'), closeTo(0, 0.0001));
        expect(scale('b'), closeTo(100, 0.0001));
        expect(scale('c'), closeTo(200, 0.0001));
      });

      test('returns NaN for unknown values', () {
        final scale = PointScale<String>(
          domain: ['a', 'b', 'c'],
          range: [0, 300],
        );

        expect(scale('unknown').isNaN, true);
      });

      test('handles single item domain', () {
        final scale = PointScale<String>(
          domain: ['a'],
          range: [0, 300],
        );

        expect(scale('a').isNaN, false);
      });

      test('handles two item domain', () {
        final scale = PointScale<String>(
          domain: ['a', 'b'],
          range: [0, 100],
        );

        expect(scale('a'), closeTo(0, 0.0001));
        expect(scale('b'), closeTo(100, 0.0001));
      });
    });

    group('bandwidth', () {
      test('returns 0 for point scale', () {
        final scale = PointScale<String>(
          domain: ['a', 'b', 'c'],
          range: [0, 300],
        );

        expect(scale.bandwidth, 0);
      });
    });

    group('step', () {
      test('returns distance between points', () {
        final scale = PointScale<String>(
          domain: ['a', 'b', 'c'],
          range: [0, 200],
        );

        expect(scale.step, closeTo(100, 0.0001));
      });
    });

    group('padding', () {
      test('adds space at edges', () {
        final scaleNoPadding = PointScale<String>(
          domain: ['a', 'b'],
          range: [0, 100],
          padding: 0,
        );
        final scaleWithPadding = PointScale<String>(
          domain: ['a', 'b'],
          range: [0, 100],
          padding: 0.5,
        );

        expect(scaleNoPadding('a'), 0);
        expect(scaleWithPadding('a'), greaterThan(0));
      });
    });

    group('round', () {
      test('rounds positions when enabled', () {
        final scale = PointScale<String>(
          domain: ['a', 'b', 'c', 'd', 'e'],
          range: [0, 100],
          round: true,
        );

        expect(scale('a') % 1, 0);
        expect(scale('b') % 1, 0);
      });
    });

    group('invert', () {
      test('returns nearest domain value for position', () {
        final scale = PointScale<String>(
          domain: ['a', 'b', 'c'],
          range: [0, 200],
        );

        expect(scale.invert(0), 'a');
        expect(scale.invert(100), 'b');
        expect(scale.invert(200), 'c');
      });

      test('returns null for empty domain', () {
        final scale = PointScale<String>(range: [0, 100]);
        expect(scale.invert(50), isNull);
      });
    });

    group('ticks', () {
      test('returns domain values', () {
        final scale = PointScale<String>(
          domain: ['a', 'b', 'c'],
          range: [0, 300],
        );

        expect(scale.ticks(), ['a', 'b', 'c']);
      });
    });

    group('copy', () {
      test('creates independent copy', () {
        final original = PointScale<String>(
          domain: ['a', 'b', 'c'],
          range: [0, 300],
        );
        final copy = original.copy();

        copy.domain = ['x', 'y'];

        expect(original.domain, ['a', 'b', 'c']);
        expect(copy.domain, ['x', 'y']);
      });
    });
  });
}
