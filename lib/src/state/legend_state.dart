import 'package:flutter/material.dart';

import '../components/legend/legend_entry.dart';
import '../core/types/series_types.dart';
import 'controllers/chart_interaction_controller.dart';

class LegendStateNotifier extends ChangeNotifier {
  final Set<String> _hiddenSeries = {};
  List<LegendEntry> _entries = [];

  List<LegendEntry> get entries => _entries;

  Set<String> get hiddenSeries => Set.unmodifiable(_hiddenSeries);

  bool isHidden(String dataKey) => _hiddenSeries.contains(dataKey);

  bool isVisible(String dataKey) => !_hiddenSeries.contains(dataKey);

  void toggle(String dataKey) {
    if (_hiddenSeries.contains(dataKey)) {
      _hiddenSeries.remove(dataKey);
    } else {
      _hiddenSeries.add(dataKey);
    }
    _updateEntries();
    notifyListeners();
  }

  void hide(String dataKey) {
    if (_hiddenSeries.add(dataKey)) {
      _updateEntries();
      notifyListeners();
    }
  }

  void show(String dataKey) {
    if (_hiddenSeries.remove(dataKey)) {
      _updateEntries();
      notifyListeners();
    }
  }

  void showAll() {
    if (_hiddenSeries.isNotEmpty) {
      _hiddenSeries.clear();
      _updateEntries();
      notifyListeners();
    }
  }

  void hideAll() {
    final allKeys = _entries.map((e) => e.dataKey).toSet();
    if (_hiddenSeries.length != allKeys.length) {
      _hiddenSeries.clear();
      _hiddenSeries.addAll(allKeys);
      _updateEntries();
      notifyListeners();
    }
  }

  void setEntries(List<LegendEntry> entries) {
    _entries = entries.map((e) {
      return e.copyWith(visible: !_hiddenSeries.contains(e.dataKey));
    }).toList();
    notifyListeners();
  }

  void updateFromSeriesInfo(List<SeriesInfo> seriesInfoList) {
    _entries = seriesInfoList.map((info) {
      return LegendEntry(
        dataKey: info.dataKey,
        name: info.name ?? info.dataKey,
        color: info.color,
        iconType: LegendType.square,
        visible: !_hiddenSeries.contains(info.dataKey),
      );
    }).toList();
    notifyListeners();
  }

  void _updateEntries() {
    _entries = _entries.map((e) {
      return e.copyWith(visible: !_hiddenSeries.contains(e.dataKey));
    }).toList();
  }
}
