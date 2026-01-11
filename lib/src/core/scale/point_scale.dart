import 'scale.dart';

class PointScale<D> implements Scale<D, double> {
  List<D> _domain = [];
  List<double> _range = [0, 1];
  double _padding = 0;
  double _align = 0.5;
  bool _round = false;

  double? _cachedStep;
  Map<D, int>? _indexMap;

  PointScale({
    List<D>? domain,
    List<double>? range,
    double padding = 0,
    double align = 0.5,
    bool round = false,
  }) {
    if (domain != null) _domain = List.from(domain);
    if (range != null) _range = List.from(range);
    _padding = padding;
    _align = align;
    _round = round;
    _rescale();
  }

  @override
  List<D> get domain => _domain;

  @override
  set domain(List<D> value) {
    _domain = List.from(value);
    _indexMap = null;
    _rescale();
  }

  @override
  List<double> get range => _range;

  @override
  set range(List<double> value) {
    _range = List.from(value);
    _rescale();
  }

  double get padding => _padding;
  set padding(double value) {
    _padding = value.clamp(0, 1);
    _rescale();
  }

  double get align => _align;
  set align(double value) {
    _align = value.clamp(0, 1);
    _rescale();
  }

  bool get round => _round;
  set round(bool value) {
    _round = value;
    _rescale();
  }

  @override
  double? get bandwidth => 0;

  double get step => _cachedStep ?? 0;

  void _rescale() {
    final n = _domain.length;
    if (n == 0) {
      _cachedStep = 0;
      return;
    }

    final r0 = _range.first;
    final r1 = _range.last;
    final reverse = r1 < r0;

    var start = reverse ? r1 : r0;
    var stop = reverse ? r0 : r1;

    var step = n < 2 ? 0.0 : (stop - start) / (n - 1 + _padding * 2);
    if (_round) {
      step = step.floorToDouble();
    }

    _cachedStep = step;

    _indexMap = {};
    for (int i = 0; i < _domain.length; i++) {
      _indexMap![_domain[i]] = i;
    }
  }

  int _indexOf(D value) {
    _indexMap ??= {
      for (int i = 0; i < _domain.length; i++) _domain[i]: i
    };
    return _indexMap![value] ?? -1;
  }

  @override
  double call(D value) {
    final index = _indexOf(value);
    if (index < 0) return double.nan;

    final n = _domain.length;
    final r0 = _range.first;
    final r1 = _range.last;
    final reverse = r1 < r0;

    var start = reverse ? r1 : r0;
    var stop = reverse ? r0 : r1;

    var step = n < 2 ? 0.0 : (stop - start) / (n - 1 + _padding * 2);
    if (_round) {
      step = step.floorToDouble();
    }

    start += (stop - start - step * (n - 1)) * _align;
    if (_round) {
      start = start.roundToDouble();
    }

    var pos = start + step * index;
    if (reverse) {
      pos = r0 + r1 - pos;
    }

    return pos;
  }

  @override
  D? invert(double value) {
    if (_domain.isEmpty) return null;

    final n = _domain.length;
    final r0 = _range.first;
    final r1 = _range.last;
    final reverse = r1 < r0;

    var start = reverse ? r1 : r0;
    var stop = reverse ? r0 : r1;

    var step = n < 2 ? 0.0 : (stop - start) / (n - 1 + _padding * 2);
    if (_round) {
      step = step.floorToDouble();
    }

    start += (stop - start - step * (n - 1)) * _align;

    var targetValue = value;
    if (reverse) {
      targetValue = r0 + r1 - value;
    }

    if (step == 0) {
      return _domain.isNotEmpty ? _domain.first : null;
    }

    final index = ((targetValue - start) / step).round();
    if (index >= 0 && index < _domain.length) {
      return _domain[index];
    }
    return null;
  }

  @override
  List<D> ticks([int? count]) => _domain;

  PointScale<D> copy() {
    return PointScale<D>(
      domain: _domain,
      range: _range,
      padding: _padding,
      align: _align,
      round: _round,
    );
  }
}
