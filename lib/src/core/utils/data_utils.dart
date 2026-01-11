import 'dart:math' as math;

int mathSign(num value) {
  if (value == 0) return 0;
  if (value > 0) return 1;
  return -1;
}

bool isPercent(dynamic value) {
  if (value is! String) return false;
  return value.endsWith('%') && value.indexOf('%') == value.length - 1;
}

bool isNumber(dynamic value) {
  if (value == null) return false;
  if (value is num) return !value.isNaN;
  return false;
}

bool isNil(dynamic value) => value == null;

bool isNumOrStr(dynamic value) => isNumber(value) || value is String;

int _idCounter = 0;
String uniqueId([String? prefix]) {
  final id = ++_idCounter;
  return '${prefix ?? ''}$id';
}

double getPercentValue(
  dynamic percent,
  double totalValue, {
  double defaultValue = 0,
  bool validate = false,
}) {
  if (!isNumber(percent) && percent is! String) {
    return defaultValue;
  }

  double value;
  if (isPercent(percent)) {
    final index = (percent as String).indexOf('%');
    value = (totalValue * double.parse(percent.substring(0, index))) / 100;
  } else {
    value = (percent is num) ? percent.toDouble() : double.tryParse(percent.toString()) ?? double.nan;
  }

  if (value.isNaN) {
    value = defaultValue;
  }

  if (validate && value > totalValue) {
    value = totalValue;
  }

  return value;
}

T? getAnyElementOfMap<T>(Map<String, T>? map) {
  if (map == null || map.isEmpty) return null;
  return map.values.first;
}

bool hasDuplicate<T>(List<T>? list) {
  if (list == null) return false;
  final cache = <T>{};
  for (final item in list) {
    if (cache.contains(item)) return true;
    cache.add(item);
  }
  return false;
}

double Function(double) interpolateNumber(num? numberA, num? numberB) {
  if (isNumber(numberA) && isNumber(numberB)) {
    return (double t) => numberA!.toDouble() + t * (numberB!.toDouble() - numberA.toDouble());
  }
  return (_) => numberB?.toDouble() ?? 0;
}

T? findEntryInArray<T>(
  List<T>? list,
  dynamic specifiedKey,
  dynamic specifiedValue,
) {
  if (list == null || list.isEmpty) return null;

  for (final entry in list) {
    if (entry == null) continue;

    dynamic entryValue;
    if (specifiedKey is Function) {
      entryValue = specifiedKey(entry);
    } else if (entry is Map) {
      entryValue = entry[specifiedKey];
    }

    if (entryValue == specifiedValue) return entry;
  }
  return null;
}

({double xmin, double xmax, double a, double b})? getLinearRegression(
  List<Map<String, num?>> data,
) {
  if (data.isEmpty) return null;

  final len = data.length;
  double xsum = 0;
  double ysum = 0;
  double xysum = 0;
  double xxsum = 0;
  double xmin = double.infinity;
  double xmax = double.negativeInfinity;

  for (int i = 0; i < len; i++) {
    final xcurrent = (data[i]['cx'] ?? 0).toDouble();
    final ycurrent = (data[i]['cy'] ?? 0).toDouble();

    xsum += xcurrent;
    ysum += ycurrent;
    xysum += xcurrent * ycurrent;
    xxsum += xcurrent * xcurrent;
    xmin = math.min(xmin, xcurrent);
    xmax = math.max(xmax, xcurrent);
  }

  final a = len * xxsum != xsum * xsum
      ? (len * xysum - xsum * ysum) / (len * xxsum - xsum * xsum)
      : 0.0;

  return (
    xmin: xmin,
    xmax: xmax,
    a: a,
    b: (ysum - a * xsum) / len,
  );
}

int compareValues(dynamic a, dynamic b) {
  if (isNumber(a) && isNumber(b)) {
    return ((a as num) - (b as num)).sign.toInt();
  }
  if (a is String && b is String) {
    return a.compareTo(b);
  }
  if (a is DateTime && b is DateTime) {
    return a.compareTo(b);
  }
  return a.toString().compareTo(b.toString());
}

List<T> getEveryNth<T>(List<T> list, int n) {
  if (n <= 0 || list.isEmpty) return [];
  final result = <T>[];
  for (int i = 0; i < list.length; i += n) {
    result.add(list[i]);
  }
  return result;
}

double roundToDecimal(double value, int decimals) {
  final factor = math.pow(10, decimals);
  return (value * factor).round() / factor;
}
