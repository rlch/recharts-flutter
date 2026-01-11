import 'package:flutter_test/flutter_test.dart';
import 'package:recharts_flutter/src/core/scale/band_scale.dart';

void main() {
  group('BandScale', () {
    group('constructor', () {
      test('creates with default values', () {
        final scale = BandScale<String>();
        expect(scale.domain, []);
        expect(scale.range, [0, 1]);
      });

      test('creates with custom domain and range', () {
        final scale = BandScale<String>(
          domain: ['a', 'b', 'c'],
          range: [0, 300],
        );
        expect(scale.domain, ['a', 'b', 'c']);
        expect(scale.range, [0, 300]);
      });
    });

    group('call', () {
      test('maps domain values to band positions', () {
        final scale = BandScale<String>(
          domain: ['a', 'b', 'c'],
          range: [0, 300],
        );

        final a = scale('a');
        final b = scale('b');
        final c = scale('c');

        expect(a, lessThan(b));
        expect(b, lessThan(c));
      });

      test('returns NaN for unknown values', () {
        final scale = BandScale<String>(
          domain: ['a', 'b', 'c'],
          range: [0, 300],
        );

        expect(scale('unknown').isNaN, true);
      });

      test('handles single item domain', () {
        final scale = BandScale<String>(
          domain: ['a'],
          range: [0, 300],
        );

        expect(scale('a').isNaN, false);
      });
    });

    group('bandwidth', () {
      test('returns positive bandwidth', () {
        final scale = BandScale<String>(
          domain: ['a', 'b', 'c'],
          range: [0, 300],
        );

        expect(scale.bandwidth, greaterThan(0));
      });

      test('bandwidth decreases with more domain values', () {
        final scale3 = BandScale<String>(
          domain: ['a', 'b', 'c'],
          range: [0, 300],
        );
        final scale5 = BandScale<String>(
          domain: ['a', 'b', 'c', 'd', 'e'],
          range: [0, 300],
        );

        expect(scale3.bandwidth, greaterThan(scale5.bandwidth));
      });
    });

    group('padding', () {
      test('paddingInner reduces bandwidth', () {
        final scaleNoPadding = BandScale<String>(
          domain: ['a', 'b', 'c'],
          range: [0, 300],
          paddingInner: 0,
        );
        final scaleWithPadding = BandScale<String>(
          domain: ['a', 'b', 'c'],
          range: [0, 300],
          paddingInner: 0.5,
        );

        expect(scaleWithPadding.bandwidth, lessThan(scaleNoPadding.bandwidth));
      });

      test('setPadding sets both inner and outer', () {
        final scale = BandScale<String>(
          domain: ['a', 'b', 'c'],
          range: [0, 300],
        );

        scale.setPadding(0.2);

        expect(scale.paddingInner, 0.2);
        expect(scale.paddingOuter, 0.2);
      });
    });

    group('round', () {
      test('rounds positions when enabled', () {
        final scale = BandScale<String>(
          domain: ['a', 'b', 'c'],
          range: [0, 100],
          round: true,
        );

        expect(scale('a') % 1, 0);
        expect(scale.bandwidth % 1, 0);
      });
    });

    group('invert', () {
      test('returns domain value for position', () {
        final scale = BandScale<String>(
          domain: ['a', 'b', 'c'],
          range: [0, 300],
        );

        final aPos = scale('a');
        expect(scale.invert(aPos + scale.bandwidth / 2), 'a');
      });

      test('returns null for out of range', () {
        final scale = BandScale<String>(
          domain: ['a', 'b', 'c'],
          range: [0, 300],
        );

        expect(scale.invert(-100), isNull);
        expect(scale.invert(400), isNull);
      });
    });

    group('ticks', () {
      test('returns domain values', () {
        final scale = BandScale<String>(
          domain: ['a', 'b', 'c'],
          range: [0, 300],
        );

        expect(scale.ticks(), ['a', 'b', 'c']);
      });
    });

    group('copy', () {
      test('creates independent copy', () {
        final original = BandScale<String>(
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
