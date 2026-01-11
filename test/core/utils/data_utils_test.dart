import 'package:flutter_test/flutter_test.dart';
import 'package:recharts_flutter/src/core/utils/data_utils.dart';

void main() {
  group('mathSign', () {
    test('returns 0 for 0', () {
      expect(mathSign(0), 0);
    });

    test('returns 1 for positive numbers', () {
      expect(mathSign(5), 1);
      expect(mathSign(0.1), 1);
      expect(mathSign(1000), 1);
    });

    test('returns -1 for negative numbers', () {
      expect(mathSign(-5), -1);
      expect(mathSign(-0.1), -1);
      expect(mathSign(-1000), -1);
    });
  });

  group('isPercent', () {
    test('returns true for percent strings', () {
      expect(isPercent('50%'), true);
      expect(isPercent('0%'), true);
      expect(isPercent('100%'), true);
      expect(isPercent('33.33%'), true);
    });

    test('returns false for non-percent values', () {
      expect(isPercent('50'), false);
      expect(isPercent(50), false);
      expect(isPercent('%50'), false);
      expect(isPercent('50%%'), false);
      expect(isPercent(null), false);
    });
  });

  group('isNumber', () {
    test('returns true for valid numbers', () {
      expect(isNumber(0), true);
      expect(isNumber(1), true);
      expect(isNumber(-1), true);
      expect(isNumber(3.14), true);
      expect(isNumber(double.infinity), true);
    });

    test('returns false for non-numbers', () {
      expect(isNumber(double.nan), false);
      expect(isNumber(null), false);
      expect(isNumber('5'), false);
      expect(isNumber([]), false);
    });
  });

  group('isNil', () {
    test('returns true for null', () {
      expect(isNil(null), true);
    });

    test('returns false for non-null values', () {
      expect(isNil(0), false);
      expect(isNil(''), false);
      expect(isNil([]), false);
      expect(isNil(false), false);
    });
  });

  group('isNumOrStr', () {
    test('returns true for numbers and strings', () {
      expect(isNumOrStr(0), true);
      expect(isNumOrStr(3.14), true);
      expect(isNumOrStr('hello'), true);
      expect(isNumOrStr(''), true);
    });

    test('returns false for other types', () {
      expect(isNumOrStr(null), false);
      expect(isNumOrStr([]), false);
      expect(isNumOrStr({}), false);
    });
  });

  group('uniqueId', () {
    test('generates unique ids', () {
      final id1 = uniqueId();
      final id2 = uniqueId();
      expect(id1, isNot(equals(id2)));
    });

    test('uses prefix when provided', () {
      final id = uniqueId('test-');
      expect(id.startsWith('test-'), true);
    });
  });

  group('getPercentValue', () {
    test('calculates percent of total', () {
      expect(getPercentValue('50%', 100), 50);
      expect(getPercentValue('25%', 200), 50);
      expect(getPercentValue('100%', 50), 50);
    });

    test('returns numeric value directly', () {
      expect(getPercentValue(30, 100), 30);
      expect(getPercentValue(30.5, 100), 30.5);
    });

    test('returns default for invalid input', () {
      expect(getPercentValue(null, 100), 0);
      expect(getPercentValue(null, 100, defaultValue: 10), 10);
    });

    test('validates against total when requested', () {
      expect(getPercentValue(150, 100, validate: true), 100);
      expect(getPercentValue('150%', 100, validate: true), 100);
    });
  });

  group('hasDuplicate', () {
    test('returns false for lists without duplicates', () {
      expect(hasDuplicate([1, 2, 3]), false);
      expect(hasDuplicate(['a', 'b', 'c']), false);
    });

    test('returns true for lists with duplicates', () {
      expect(hasDuplicate([1, 2, 1]), true);
      expect(hasDuplicate(['a', 'a']), true);
    });

    test('returns false for null', () {
      expect(hasDuplicate(null), false);
    });

    test('returns false for empty list', () {
      expect(hasDuplicate([]), false);
    });
  });

  group('interpolateNumber', () {
    test('interpolates between two numbers', () {
      final fn = interpolateNumber(0, 100);
      expect(fn(0), 0);
      expect(fn(0.5), 50);
      expect(fn(1), 100);
    });

    test('handles extrapolation', () {
      final fn = interpolateNumber(0, 100);
      expect(fn(2), 200);
      expect(fn(-1), -100);
    });

    test('returns constant when first number is invalid', () {
      final fn = interpolateNumber(null, 50);
      expect(fn(0), 50);
      expect(fn(0.5), 50);
      expect(fn(1), 50);
    });
  });

  group('getLinearRegression', () {
    test('returns null for empty data', () {
      expect(getLinearRegression([]), null);
    });

    test('calculates regression for points on a line', () {
      final result = getLinearRegression([
        {'cx': 0, 'cy': 0},
        {'cx': 1, 'cy': 2},
        {'cx': 2, 'cy': 4},
      ]);

      expect(result, isNotNull);
      expect(result!.xmin, 0);
      expect(result.xmax, 2);
      expect(result.a, closeTo(2, 0.0001));
      expect(result.b, closeTo(0, 0.0001));
    });
  });

  group('compareValues', () {
    test('compares numbers', () {
      expect(compareValues(1, 2), lessThan(0));
      expect(compareValues(2, 1), greaterThan(0));
      expect(compareValues(1, 1), 0);
    });

    test('compares strings', () {
      expect(compareValues('a', 'b'), lessThan(0));
      expect(compareValues('b', 'a'), greaterThan(0));
      expect(compareValues('a', 'a'), 0);
    });

    test('compares dates', () {
      final earlier = DateTime(2023, 1, 1);
      final later = DateTime(2023, 12, 31);
      expect(compareValues(earlier, later), lessThan(0));
      expect(compareValues(later, earlier), greaterThan(0));
    });
  });

  group('getEveryNth', () {
    test('returns every nth element', () {
      expect(getEveryNth([1, 2, 3, 4, 5], 2), [1, 3, 5]);
      expect(getEveryNth([1, 2, 3, 4, 5, 6], 3), [1, 4]);
    });

    test('returns all elements when n is 1', () {
      expect(getEveryNth([1, 2, 3], 1), [1, 2, 3]);
    });

    test('returns empty for n <= 0', () {
      expect(getEveryNth([1, 2, 3], 0), []);
      expect(getEveryNth([1, 2, 3], -1), []);
    });

    test('returns empty for empty list', () {
      expect(getEveryNth([], 2), []);
    });
  });

  group('roundToDecimal', () {
    test('rounds to specified decimals', () {
      expect(roundToDecimal(3.14159, 2), 3.14);
      expect(roundToDecimal(3.145, 2), 3.15);
      expect(roundToDecimal(3.14159, 0), 3);
      expect(roundToDecimal(3.14159, 4), 3.1416);
    });
  });
}
