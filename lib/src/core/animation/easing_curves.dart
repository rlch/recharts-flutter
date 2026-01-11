import 'dart:math' as math;

import 'package:flutter/animation.dart';

class EaseBounceOutCurve extends Curve {
  const EaseBounceOutCurve();

  @override
  double transformInternal(double t) {
    const b1 = 4 / 11;
    const b2 = 6 / 11;
    const b3 = 8 / 11;
    const b4 = 3 / 4;
    const b5 = 9 / 11;
    const b6 = 10 / 11;
    const b7 = 15 / 16;
    const b8 = 21 / 22;
    const b9 = 63 / 64;
    const b0 = 1 / b1 / b1;

    if (t < b1) {
      return b0 * t * t;
    } else if (t < b3) {
      final t2 = t - b2;
      return b0 * t2 * t2 + b4;
    } else if (t < b6) {
      final t2 = t - b5;
      return b0 * t2 * t2 + b7;
    } else {
      final t2 = t - b8;
      return b0 * t2 * t2 + b9;
    }
  }
}

class EaseBounceInCurve extends Curve {
  const EaseBounceInCurve();

  static const _bounceOut = EaseBounceOutCurve();

  @override
  double transformInternal(double t) {
    return 1 - _bounceOut.transformInternal(1 - t);
  }
}

class EaseBounceInOutCurve extends Curve {
  const EaseBounceInOutCurve();

  static const _bounceIn = EaseBounceInCurve();
  static const _bounceOut = EaseBounceOutCurve();

  @override
  double transformInternal(double t) {
    if (t < 0.5) {
      return _bounceIn.transformInternal(t * 2) * 0.5;
    } else {
      return _bounceOut.transformInternal(t * 2 - 1) * 0.5 + 0.5;
    }
  }
}

class EaseElasticOutCurve extends Curve {
  const EaseElasticOutCurve({
    this.amplitude = 1.0,
    this.period = 0.3,
  });

  final double amplitude;
  final double period;

  @override
  double transformInternal(double t) {
    final a = amplitude < 1 ? 1.0 : amplitude;
    final s = period / (2 * math.pi) * math.asin(1 / a);
    return a *
            math.pow(2, -10 * t) *
            math.sin((t - s) * (2 * math.pi) / period) +
        1;
  }
}

class EaseElasticInCurve extends Curve {
  const EaseElasticInCurve({
    this.amplitude = 1.0,
    this.period = 0.3,
  });

  final double amplitude;
  final double period;

  @override
  double transformInternal(double t) {
    final a = amplitude < 1 ? 1.0 : amplitude;
    final s = period / (2 * math.pi) * math.asin(1 / a);
    return -(a *
        math.pow(2, 10 * (t - 1)) *
        math.sin((t - 1 - s) * (2 * math.pi) / period));
  }
}

class EaseElasticInOutCurve extends Curve {
  const EaseElasticInOutCurve({
    this.amplitude = 1.0,
    this.period = 0.45,
  });

  final double amplitude;
  final double period;

  @override
  double transformInternal(double t) {
    final a = amplitude < 1 ? 1.0 : amplitude;

    if (t < 0.5) {
      return -(a *
              math.pow(2, 20 * t - 10) *
              math.sin((20 * t - 11.125) * (2 * math.pi) / period)) /
          2;
    } else {
      return (a *
                  math.pow(2, -20 * t + 10) *
                  math.sin((20 * t - 11.125) * (2 * math.pi) / period)) /
              2 +
          1;
    }
  }
}

const Curve easeLinear = Curves.linear;
const Curve ease = Curves.ease;
const Curve easeCubic = Curves.easeInOut;
const Curve easeCubicIn = Curves.easeIn;
const Curve easeCubicOut = Curves.easeOut;
const Curve easeCubicInOut = Curves.easeInOut;
const Curve easeQuad = Curves.easeInOutQuad;
const Curve easeQuadIn = Curves.easeInQuad;
const Curve easeQuadOut = Curves.easeOutQuad;
const Curve easeQuadInOut = Curves.easeInOutQuad;
const Curve easeBounce = EaseBounceOutCurve();
const Curve easeBounceIn = EaseBounceInCurve();
const Curve easeBounceOut = EaseBounceOutCurve();
const Curve easeBounceInOut = EaseBounceInOutCurve();
const Curve easeElastic = EaseElasticOutCurve();
const Curve easeElasticIn = EaseElasticInCurve();
const Curve easeElasticOut = EaseElasticOutCurve();
const Curve easeElasticInOut = EaseElasticInOutCurve();

const Map<String, Curve> easingCurves = {
  'linear': easeLinear,
  'ease': ease,
  'ease-in': easeCubicIn,
  'ease-out': easeCubicOut,
  'ease-in-out': easeCubicInOut,
  'easeLinear': easeLinear,
  'easeQuad': easeQuad,
  'easeQuadIn': easeQuadIn,
  'easeQuadOut': easeQuadOut,
  'easeQuadInOut': easeQuadInOut,
  'easeCubic': easeCubic,
  'easeCubicIn': easeCubicIn,
  'easeCubicOut': easeCubicOut,
  'easeCubicInOut': easeCubicInOut,
  'easeBounce': easeBounce,
  'easeBounceIn': easeBounceIn,
  'easeBounceOut': easeBounceOut,
  'easeBounceInOut': easeBounceInOut,
  'easeElastic': easeElastic,
  'easeElasticIn': easeElasticIn,
  'easeElasticOut': easeElasticOut,
  'easeElasticInOut': easeElasticInOut,
};

Curve getCurveFromName(String name) {
  return easingCurves[name] ?? ease;
}
