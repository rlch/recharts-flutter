import 'package:flutter_test/flutter_test.dart';
import 'package:recharts_flutter/src/core/scale/linear_scale.dart';

void main() {
  group('LinearScale', () {
    group('constructor', () {
      test('creates with default domain and range', () {
        final scale = LinearScale();
        expect(scale.domain, [0, 1]);
        expect(scale.range, [0, 1]);
      });

      test('creates with custom domain and range', () {
        final scale = LinearScale(domain: [0, 100], range: [0, 1000]);
        expect(scale.domain, [0, 100]);
        expect(scale.range, [0, 1000]);
      });
    });

    group('call', () {
      test('maps domain to range linearly', () {
        final scale = LinearScale(domain: [0, 100], range: [0, 1000]);
        expect(scale(0), 0);
        expect(scale(50), 500);
        expect(scale(100), 1000);
      });

      test('handles reversed range', () {
        final scale = LinearScale(domain: [0, 100], range: [1000, 0]);
        expect(scale(0), 1000);
        expect(scale(50), 500);
        expect(scale(100), 0);
      });

      test('handles reversed domain', () {
        final scale = LinearScale(domain: [100, 0], range: [0, 1000]);
        expect(scale(100), 0);
        expect(scale(50), 500);
        expect(scale(0), 1000);
      });

      test('extrapolates beyond domain by default', () {
        final scale = LinearScale(domain: [0, 100], range: [0, 1000]);
        expect(scale(150), 1500);
        expect(scale(-50), -500);
      });

      test('clamps when clamp is true', () {
        final scale = LinearScale(domain: [0, 100], range: [0, 1000], clamp: true);
        expect(scale(150), 1000);
        expect(scale(-50), 0);
      });
    });

    group('invert', () {
      test('inverts range to domain', () {
        final scale = LinearScale(domain: [0, 100], range: [0, 1000]);
        expect(scale.invert(0), 0);
        expect(scale.invert(500), 50);
        expect(scale.invert(1000), 100);
      });

      test('handles reversed range', () {
        final scale = LinearScale(domain: [0, 100], range: [1000, 0]);
        expect(scale.invert(1000), 0);
        expect(scale.invert(500), 50);
        expect(scale.invert(0), 100);
      });
    });

    group('ticks', () {
      test('generates ticks within domain', () {
        final scale = LinearScale(domain: [0, 100], range: [0, 1000]);
        final ticks = scale.ticks(10);
        expect(ticks.length, greaterThan(0));
        expect(ticks.first, greaterThanOrEqualTo(0));
        expect(ticks.last, lessThanOrEqualTo(100));
      });

      test('generates approximately the requested number of ticks', () {
        final scale = LinearScale(domain: [0, 100], range: [0, 1000]);
        final ticks5 = scale.ticks(5);
        final ticks20 = scale.ticks(20);

        expect(ticks5.length, lessThan(ticks20.length));
      });

      test('handles small domains', () {
        final scale = LinearScale(domain: [0, 1], range: [0, 100]);
        final ticks = scale.ticks(5);
        expect(ticks.length, greaterThan(0));
      });
    });

    group('nice', () {
      test('extends domain to nice values', () {
        final scale = LinearScale(domain: [0.5, 99.5], nice: true);
        expect(scale.domain.first, lessThanOrEqualTo(0));
        expect(scale.domain.last, greaterThanOrEqualTo(100));
      });
    });

    group('bandwidth', () {
      test('returns null for linear scale', () {
        final scale = LinearScale();
        expect(scale.bandwidth, isNull);
      });
    });

    group('copy', () {
      test('creates independent copy', () {
        final original = LinearScale(domain: [0, 100], range: [0, 1000]);
        final copy = original.copy();

        copy.domain = [0, 50];

        expect(original.domain, [0, 100]);
        expect(copy.domain, [0, 50]);
      });
    });
  });
}
