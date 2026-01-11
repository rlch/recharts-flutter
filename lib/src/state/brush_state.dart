import 'package:flutter/foundation.dart';

class BrushWindow {
  final int startIndex;
  final int endIndex;

  const BrushWindow({
    required this.startIndex,
    required this.endIndex,
  });

  int get length => endIndex - startIndex + 1;

  bool contains(int index) => index >= startIndex && index <= endIndex;

  BrushWindow copyWith({
    int? startIndex,
    int? endIndex,
  }) {
    return BrushWindow(
      startIndex: startIndex ?? this.startIndex,
      endIndex: endIndex ?? this.endIndex,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrushWindow &&
          startIndex == other.startIndex &&
          endIndex == other.endIndex;

  @override
  int get hashCode => Object.hash(startIndex, endIndex);
}

class BrushStateNotifier extends ChangeNotifier {
  BrushWindow _window;
  final int _dataLength;

  BrushStateNotifier({
    required int dataLength,
    int? initialStartIndex,
    int? initialEndIndex,
  })  : _dataLength = dataLength,
        _window = BrushWindow(
          startIndex: initialStartIndex ?? 0,
          endIndex: initialEndIndex ?? (dataLength > 0 ? dataLength - 1 : 0),
        );

  BrushWindow get window => _window;
  int get startIndex => _window.startIndex;
  int get endIndex => _window.endIndex;
  int get dataLength => _dataLength;

  void setWindow(int startIndex, int endIndex) {
    final newStart = startIndex.clamp(0, _dataLength - 1);
    final newEnd = endIndex.clamp(newStart, _dataLength - 1);

    if (newStart != _window.startIndex || newEnd != _window.endIndex) {
      _window = BrushWindow(startIndex: newStart, endIndex: newEnd);
      notifyListeners();
    }
  }

  void setStartIndex(int startIndex) {
    final newStart = startIndex.clamp(0, _window.endIndex);
    if (newStart != _window.startIndex) {
      _window = _window.copyWith(startIndex: newStart);
      notifyListeners();
    }
  }

  void setEndIndex(int endIndex) {
    final newEnd = endIndex.clamp(_window.startIndex, _dataLength - 1);
    if (newEnd != _window.endIndex) {
      _window = _window.copyWith(endIndex: newEnd);
      notifyListeners();
    }
  }

  void pan(int delta) {
    final windowSize = _window.endIndex - _window.startIndex;
    var newStart = _window.startIndex + delta;
    var newEnd = _window.endIndex + delta;

    if (newStart < 0) {
      newStart = 0;
      newEnd = windowSize;
    }
    if (newEnd >= _dataLength) {
      newEnd = _dataLength - 1;
      newStart = newEnd - windowSize;
    }

    if (newStart != _window.startIndex) {
      _window = BrushWindow(startIndex: newStart, endIndex: newEnd);
      notifyListeners();
    }
  }

  void reset() {
    final newWindow = BrushWindow(
      startIndex: 0,
      endIndex: _dataLength > 0 ? _dataLength - 1 : 0,
    );
    if (_window != newWindow) {
      _window = newWindow;
      notifyListeners();
    }
  }
}

List<T> filterByBrushWindow<T>(List<T> data, BrushWindow window) {
  if (window.startIndex == 0 && window.endIndex >= data.length - 1) {
    return data;
  }
  return data.sublist(
    window.startIndex,
    (window.endIndex + 1).clamp(0, data.length),
  );
}
