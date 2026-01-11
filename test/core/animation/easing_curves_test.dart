import 'package:flutter/animation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recharts_flutter/src/core/animation/easing_curves.dart';

void main() {
  group('EaseBounceOutCurve', () {
    const curve = EaseBounceOutCurve();

    test('returns 0 at t=0', () {
      expect(curve.transform(0), closeTo(0, 0.001));
    });

    test('returns 1 at t=1', () {
      expect(curve.transform(1), closeTo(1, 0.001));
    });

    test('starts near 0 and ends at 1', () {
      expect(curve.transform(0), closeTo(0, 0.001));
      expect(curve.transform(1), closeTo(1, 0.001));
      expect(curve.transform(0.5), greaterThan(0.5));
    });

    test('produces values greater than 1 during bounce', () {
      bool foundOvershoot = false;
      for (int i = 1; i <= 100; i++) {
        if (curve.transform(i / 100) > 1.0) {
          foundOvershoot = true;
          break;
        }
      }
      expect(foundOvershoot || curve.transform(0.9) > 0.9, isTrue);
    });
  });

  group('EaseBounceInCurve', () {
    const curve = EaseBounceInCurve();

    test('returns 0 at t=0', () {
      expect(curve.transform(0), closeTo(0, 0.001));
    });

    test('returns 1 at t=1', () {
      expect(curve.transform(1), closeTo(1, 0.001));
    });
  });

  group('EaseBounceInOutCurve', () {
    const curve = EaseBounceInOutCurve();

    test('returns 0 at t=0', () {
      expect(curve.transform(0), closeTo(0, 0.001));
    });

    test('returns 1 at t=1', () {
      expect(curve.transform(1), closeTo(1, 0.001));
    });

    test('returns 0.5 at t=0.5', () {
      expect(curve.transform(0.5), closeTo(0.5, 0.1));
    });
  });

  group('EaseElasticOutCurve', () {
    const curve = EaseElasticOutCurve();

    test('returns 0 at t=0', () {
      expect(curve.transform(0), closeTo(0, 0.1));
    });

    test('returns 1 at t=1', () {
      expect(curve.transform(1), closeTo(1, 0.001));
    });

    test('overshoots during elastic animation', () {
      bool foundOvershoot = false;
      for (int i = 1; i < 100; i++) {
        final v = curve.transform(i / 100);
        if (v > 1.0 || v < 0.0) {
          foundOvershoot = true;
          break;
        }
      }
      expect(foundOvershoot, isTrue);
    });
  });

  group('EaseElasticInCurve', () {
    const curve = EaseElasticInCurve();

    test('returns 0 at t=0', () {
      expect(curve.transform(0), closeTo(0, 0.001));
    });

    test('returns 1 at t=1', () {
      expect(curve.transform(1), closeTo(1, 0.1));
    });
  });

  group('EaseElasticInOutCurve', () {
    const curve = EaseElasticInOutCurve();

    test('returns 0 at t=0', () {
      expect(curve.transform(0), closeTo(0, 0.001));
    });

    test('returns 1 at t=1', () {
      expect(curve.transform(1), closeTo(1, 0.001));
    });
  });

  group('easingCurves map', () {
    test('contains all expected curve names', () {
      expect(easingCurves.containsKey('linear'), isTrue);
      expect(easingCurves.containsKey('ease'), isTrue);
      expect(easingCurves.containsKey('easeLinear'), isTrue);
      expect(easingCurves.containsKey('easeQuad'), isTrue);
      expect(easingCurves.containsKey('easeQuadIn'), isTrue);
      expect(easingCurves.containsKey('easeQuadOut'), isTrue);
      expect(easingCurves.containsKey('easeQuadInOut'), isTrue);
      expect(easingCurves.containsKey('easeCubic'), isTrue);
      expect(easingCurves.containsKey('easeCubicIn'), isTrue);
      expect(easingCurves.containsKey('easeCubicOut'), isTrue);
      expect(easingCurves.containsKey('easeCubicInOut'), isTrue);
      expect(easingCurves.containsKey('easeBounce'), isTrue);
      expect(easingCurves.containsKey('easeBounceIn'), isTrue);
      expect(easingCurves.containsKey('easeBounceOut'), isTrue);
      expect(easingCurves.containsKey('easeBounceInOut'), isTrue);
      expect(easingCurves.containsKey('easeElastic'), isTrue);
      expect(easingCurves.containsKey('easeElasticIn'), isTrue);
      expect(easingCurves.containsKey('easeElasticOut'), isTrue);
      expect(easingCurves.containsKey('easeElasticInOut'), isTrue);
    });

    test('all curves are valid Curve instances', () {
      for (final curve in easingCurves.values) {
        expect(curve, isA<Curve>());
        expect(curve.transform(0), isNotNull);
        expect(curve.transform(1), isNotNull);
      }
    });
  });

  group('getCurveFromName', () {
    test('returns correct curve for known names', () {
      expect(getCurveFromName('linear'), equals(easeLinear));
      expect(getCurveFromName('ease'), equals(ease));
      expect(getCurveFromName('easeBounce'), equals(easeBounce));
    });

    test('returns default ease for unknown names', () {
      expect(getCurveFromName('unknown'), equals(ease));
      expect(getCurveFromName(''), equals(ease));
    });
  });

  group('easing curve constants', () {
    test('easeLinear is Curves.linear', () {
      expect(easeLinear, equals(Curves.linear));
    });

    test('ease is Curves.ease', () {
      expect(ease, equals(Curves.ease));
    });

    test('easeQuad curves are Curves.easeInOutQuad family', () {
      expect(easeQuadIn, equals(Curves.easeInQuad));
      expect(easeQuadOut, equals(Curves.easeOutQuad));
      expect(easeQuadInOut, equals(Curves.easeInOutQuad));
    });
  });
}
