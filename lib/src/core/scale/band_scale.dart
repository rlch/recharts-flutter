import 'scale.dart';

class BandScale<D> implements Scale<D, double> {
  List<D> _domain = [];
  List<double> _range = [0, 1];
  double _paddingInner = 0;
  double _paddingOuter = 0;
  double _align = 0.5;
  bool _round = false;

  double? _cachedBandwidth;
  double? _cachedStep;
  Map<D, int>? _indexMap;

  BandScale({
    List<D>? domain,
    List<double>? range,
    double paddingInner = 0,
    double paddingOuter = 0,
    double padding = 0,
    double align = 0.5,
    bool round = false,
  }) {
    if (domain != null) _domain = List.from(domain);
    if (range != null) _range = List.from(range);
    _paddingInner = padding > 0 ? padding : paddingInner;
    _paddingOuter = padding > 0 ? padding : paddingOuter;
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

  double get paddingInner => _paddingInner;
  set paddingInner(double value) {
    _paddingInner = value.clamp(0, 1);
    _rescale();
  }

  double get paddingOuter => _paddingOuter;
  set paddingOuter(double value) {
    _paddingOuter = value.clamp(0, 1);
    _rescale();
  }

  void setPadding(double value) {
    _paddingInner = value.clamp(0, 1);
    _paddingOuter = value.clamp(0, 1);
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
  double get bandwidth => _cachedBandwidth ?? 0;

  double get step => _cachedStep ?? 0;

  void _rescale() {
    final n = _domain.length;
    final r0 = _range.first;
    final r1 = _range.last;
    final reverse = r1 < r0;

    var start = reverse ? r1 : r0;
    var stop = reverse ? r0 : r1;

    var step = (stop - start) / (n - _paddingInner + _paddingOuter * 2).clamp(1, double.infinity);
    if (_round) {
      step = step.floorToDouble();
    }

    start += (stop - start - step * (n - _paddingInner)) * _align;

    var bw = step * (1 - _paddingInner);
    if (_round) {
      start = start.roundToDouble();
      bw = bw.roundToDouble();
    }

    _cachedStep = step;
    _cachedBandwidth = bw;

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

    final r0 = _range.first;
    final r1 = _range.last;
    final reverse = r1 < r0;

    var start = reverse ? r1 : r0;
    var stop = reverse ? r0 : r1;

    final n = _domain.length;
    var step = (stop - start) / (n - _paddingInner + _paddingOuter * 2).clamp(1, double.infinity);
    if (_round) {
      step = step.floorToDouble();
    }

    start += (stop - start - step * (n - _paddingInner)) * _align;
    if (_round) {
      start = start.roundToDouble();
    }

    var pos = start + step * index;
    if (reverse) {
      pos = r0 + r1 - pos - bandwidth;
    }

    return pos;
  }

  @override
  D? invert(double value) {
    if (_domain.isEmpty) return null;

    final r0 = _range.first;
    final r1 = _range.last;
    final reverse = r1 < r0;

    var start = reverse ? r1 : r0;
    var stop = reverse ? r0 : r1;

    final n = _domain.length;
    var step = (stop - start) / (n - _paddingInner + _paddingOuter * 2).clamp(1, double.infinity);
    if (_round) {
      step = step.floorToDouble();
    }

    start += (stop - start - step * (n - _paddingInner)) * _align;

    var targetValue = value;
    if (reverse) {
      targetValue = r0 + r1 - value - bandwidth;
    }

    final index = ((targetValue - start) / step).floor();
    if (index >= 0 && index < _domain.length) {
      return _domain[index];
    }
    return null;
  }

  @override
  List<D> ticks([int? count]) => _domain;

  BandScale<D> copy() {
    return BandScale<D>(
      domain: _domain,
      range: _range,
      paddingInner: _paddingInner,
      paddingOuter: _paddingOuter,
      align: _align,
      round: _round,
    );
  }
}
