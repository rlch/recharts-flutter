import 'dart:math' as math;

import 'scale.dart';

class LinearScale implements Scale<num, double> {
  List<num> _domain = [0, 1];
  List<double> _range = [0, 1];
  bool _nice = false;
  int _niceCount = 10;

  bool clamp;

  LinearScale({
    List<num>? domain,
    List<double>? range,
    this.clamp = false,
    bool nice = false,
    int niceCount = 10,
  }) {
    if (domain != null) _domain = List.from(domain);
    if (range != null) _range = List.from(range);
    _nice = nice;
    _niceCount = niceCount;
    if (_nice) _nicefy();
  }

  @override
  List<num> get domain => _domain;

  @override
  set domain(List<num> value) {
    _domain = List.from(value);
    if (_nice) _nicefy();
  }

  @override
  List<double> get range => _range;

  @override
  set range(List<double> value) {
    _range = List.from(value);
  }

  @override
  double? get bandwidth => null;

  void _nicefy() {
    if (_domain.length < 2) return;

    final d0 = _domain.first.toDouble();
    final d1 = _domain.last.toDouble();
    final span = d1 - d0;

    if (span == 0) return;

    final step = _niceStep(span / _niceCount);
    final start = (d0 / step).floor() * step;
    final stop = (d1 / step).ceil() * step;

    _domain = [start, stop];
  }

  double _niceStep(double step) {
    if (step <= 0) return 1;

    final magnitude = (math.log(step) / math.ln10).floor();
    final power = math.pow(10, magnitude).toDouble();
    final error = step / power;

    double niceStep;
    if (error >= math.sqrt(50)) {
      niceStep = 10 * power;
    } else if (error >= math.sqrt(10)) {
      niceStep = 5 * power;
    } else if (error >= math.sqrt(2)) {
      niceStep = 2 * power;
    } else {
      niceStep = power;
    }

    return niceStep;
  }

  @override
  double call(num value) {
    if (_domain.length < 2 || _range.length < 2) return _range.first;

    final d0 = _domain.first.toDouble();
    final d1 = _domain.last.toDouble();
    final r0 = _range.first;
    final r1 = _range.last;

    if (d0 == d1) return (r0 + r1) / 2;

    var t = (value.toDouble() - d0) / (d1 - d0);

    if (clamp) {
      t = t.clamp(0, 1);
    }

    return r0 + t * (r1 - r0);
  }

  @override
  num? invert(double value) {
    if (_domain.length < 2 || _range.length < 2) return null;

    final d0 = _domain.first.toDouble();
    final d1 = _domain.last.toDouble();
    final r0 = _range.first;
    final r1 = _range.last;

    if (r0 == r1) return (d0 + d1) / 2;

    var t = (value - r0) / (r1 - r0);

    if (clamp) {
      t = t.clamp(0, 1);
    }

    return d0 + t * (d1 - d0);
  }

  @override
  List<num> ticks([int? count]) {
    count ??= 10;
    if (_domain.length < 2) return [];

    final d0 = _domain.first.toDouble();
    final d1 = _domain.last.toDouble();
    final step = _tickStep(d0, d1, count);

    if (step == 0 || step.isInfinite || step.isNaN) {
      return [d0];
    }

    final start = (d0 / step).ceil() * step;
    final stop = (d1 / step).floor() * step;

    final result = <num>[];
    var current = start;
    while (current <= stop + step * 0.5) {
      result.add(current);
      current += step;
    }

    return result;
  }

  double _tickStep(double start, double stop, int count) {
    final step0 = (stop - start).abs() / math.max(0, count);
    var step1 = math.pow(10, (math.log(step0) / math.ln10).floor()).toDouble();
    final error = step0 / step1;

    if (error >= math.sqrt(50)) {
      step1 *= 10;
    } else if (error >= math.sqrt(10)) {
      step1 *= 5;
    } else if (error >= math.sqrt(2)) {
      step1 *= 2;
    }

    return stop < start ? -step1 : step1;
  }

  LinearScale copy() {
    return LinearScale(
      domain: _domain,
      range: _range,
      clamp: clamp,
      nice: _nice,
      niceCount: _niceCount,
    );
  }
}
