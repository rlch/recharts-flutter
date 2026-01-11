import 'package:flutter_test/flutter_test.dart';
import 'package:recharts_flutter/src/state/brush_state.dart';

void main() {
  group('BrushWindow', () {
    test('creates with start and end index', () {
      const window = BrushWindow(startIndex: 2, endIndex: 5);

      expect(window.startIndex, 2);
      expect(window.endIndex, 5);
      expect(window.length, 4);
    });

    test('contains checks if index is in range', () {
      const window = BrushWindow(startIndex: 2, endIndex: 5);

      expect(window.contains(0), false);
      expect(window.contains(1), false);
      expect(window.contains(2), true);
      expect(window.contains(3), true);
      expect(window.contains(5), true);
      expect(window.contains(6), false);
    });

    test('copyWith creates new window with updated values', () {
      const window = BrushWindow(startIndex: 2, endIndex: 5);

      final updated = window.copyWith(startIndex: 3);
      expect(updated.startIndex, 3);
      expect(updated.endIndex, 5);
    });

    test('equality works correctly', () {
      const w1 = BrushWindow(startIndex: 2, endIndex: 5);
      const w2 = BrushWindow(startIndex: 2, endIndex: 5);
      const w3 = BrushWindow(startIndex: 3, endIndex: 5);

      expect(w1, equals(w2));
      expect(w1, isNot(equals(w3)));
    });
  });

  group('BrushStateNotifier', () {
    test('initializes with default window spanning all data', () {
      final notifier = BrushStateNotifier(dataLength: 10);

      expect(notifier.startIndex, 0);
      expect(notifier.endIndex, 9);
    });

    test('initializes with custom start and end indices', () {
      final notifier = BrushStateNotifier(
        dataLength: 10,
        initialStartIndex: 2,
        initialEndIndex: 7,
      );

      expect(notifier.startIndex, 2);
      expect(notifier.endIndex, 7);
    });

    test('setWindow updates both indices', () {
      final notifier = BrushStateNotifier(dataLength: 10);

      notifier.setWindow(2, 6);

      expect(notifier.startIndex, 2);
      expect(notifier.endIndex, 6);
    });

    test('setWindow clamps values to valid range', () {
      final notifier = BrushStateNotifier(dataLength: 10);

      notifier.setWindow(-5, 15);

      expect(notifier.startIndex, 0);
      expect(notifier.endIndex, 9);
    });

    test('setStartIndex clamps to not exceed endIndex', () {
      final notifier = BrushStateNotifier(
        dataLength: 10,
        initialStartIndex: 2,
        initialEndIndex: 5,
      );

      notifier.setStartIndex(7);

      expect(notifier.startIndex, 5);
    });

    test('setEndIndex clamps to not go below startIndex', () {
      final notifier = BrushStateNotifier(
        dataLength: 10,
        initialStartIndex: 5,
        initialEndIndex: 8,
      );

      notifier.setEndIndex(3);

      expect(notifier.endIndex, 5);
    });

    test('pan moves window within bounds', () {
      final notifier = BrushStateNotifier(
        dataLength: 10,
        initialStartIndex: 2,
        initialEndIndex: 5,
      );

      notifier.pan(2);

      expect(notifier.startIndex, 4);
      expect(notifier.endIndex, 7);
    });

    test('pan stops at left edge', () {
      final notifier = BrushStateNotifier(
        dataLength: 10,
        initialStartIndex: 2,
        initialEndIndex: 5,
      );

      notifier.pan(-5);

      expect(notifier.startIndex, 0);
      expect(notifier.endIndex, 3);
    });

    test('pan stops at right edge', () {
      final notifier = BrushStateNotifier(
        dataLength: 10,
        initialStartIndex: 5,
        initialEndIndex: 8,
      );

      notifier.pan(5);

      expect(notifier.startIndex, 6);
      expect(notifier.endIndex, 9);
    });

    test('reset restores full window', () {
      final notifier = BrushStateNotifier(
        dataLength: 10,
        initialStartIndex: 3,
        initialEndIndex: 6,
      );

      notifier.reset();

      expect(notifier.startIndex, 0);
      expect(notifier.endIndex, 9);
    });

    test('notifies listeners on changes', () {
      final notifier = BrushStateNotifier(dataLength: 10);

      int notifyCount = 0;
      notifier.addListener(() {
        notifyCount++;
      });

      notifier.setWindow(2, 5);
      expect(notifyCount, 1);

      notifier.setStartIndex(3);
      expect(notifyCount, 2);

      notifier.setEndIndex(7);
      expect(notifyCount, 3);
    });

    test('does not notify if value unchanged', () {
      final notifier = BrushStateNotifier(
        dataLength: 10,
        initialStartIndex: 2,
        initialEndIndex: 5,
      );

      int notifyCount = 0;
      notifier.addListener(() {
        notifyCount++;
      });

      notifier.setWindow(2, 5);
      expect(notifyCount, 0);
    });
  });

  group('filterByBrushWindow', () {
    test('returns full data when window spans all', () {
      final data = [1, 2, 3, 4, 5];
      const window = BrushWindow(startIndex: 0, endIndex: 4);

      final result = filterByBrushWindow(data, window);

      expect(result, data);
    });

    test('returns subset when window is smaller', () {
      final data = [1, 2, 3, 4, 5];
      const window = BrushWindow(startIndex: 1, endIndex: 3);

      final result = filterByBrushWindow(data, window);

      expect(result, [2, 3, 4]);
    });

    test('handles edge cases correctly', () {
      final data = [1, 2, 3, 4, 5];
      const window = BrushWindow(startIndex: 0, endIndex: 0);

      final result = filterByBrushWindow(data, window);

      expect(result, [1]);
    });
  });
}
