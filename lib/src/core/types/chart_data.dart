typedef ChartData = List<Map<String, dynamic>>;

class ChartDataPoint {
  final Map<String, dynamic> _data;

  const ChartDataPoint(this._data);

  dynamic operator [](String key) => _data[key];

  bool containsKey(String key) => _data.containsKey(key);

  T? getValue<T>(String key) {
    final value = _data[key];
    if (value is T) return value;
    return null;
  }

  double? getNumericValue(String key) {
    final value = _data[key];
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  String? getStringValue(String key) {
    final value = _data[key];
    if (value == null) return null;
    return value.toString();
  }

  Map<String, dynamic> toMap() => Map.from(_data);

  @override
  String toString() => 'ChartDataPoint($_data)';
}

class ChartDataSet {
  final List<ChartDataPoint> points;

  ChartDataSet(List<Map<String, dynamic>> data)
      : points = data.map((d) => ChartDataPoint(d)).toList();

  int get length => points.length;
  bool get isEmpty => points.isEmpty;
  bool get isNotEmpty => points.isNotEmpty;

  ChartDataPoint operator [](int index) => points[index];

  Iterable<double> getNumericValues(String key) {
    return points
        .map((p) => p.getNumericValue(key))
        .where((v) => v != null)
        .cast<double>();
  }

  (double, double)? getExtent(String key) {
    final values = getNumericValues(key).toList();
    if (values.isEmpty) return null;

    double min = values.first;
    double max = values.first;

    for (final v in values) {
      if (v < min) min = v;
      if (v > max) max = v;
    }

    return (min, max);
  }

  List<T> getUniqueValues<T>(String key) {
    final seen = <T>{};
    final result = <T>[];

    for (final point in points) {
      final value = point[key];
      if (value is T && !seen.contains(value)) {
        seen.add(value);
        result.add(value);
      }
    }

    return result;
  }
}
