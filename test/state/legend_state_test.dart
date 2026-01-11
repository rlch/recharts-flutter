import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recharts_flutter/src/state/legend_state.dart';
import 'package:recharts_flutter/src/components/legend/legend_entry.dart';
import 'package:recharts_flutter/src/core/types/series_types.dart';
import 'package:recharts_flutter/src/state/controllers/chart_interaction_controller.dart';

void main() {
  group('LegendStateNotifier', () {
    test('initial state has no hidden series', () {
      final notifier = LegendStateNotifier();

      expect(notifier.hiddenSeries, isEmpty);
      expect(notifier.entries, isEmpty);
    });

    test('toggle adds and removes series from hidden set', () {
      final notifier = LegendStateNotifier();
      notifier.setEntries([
        const LegendEntry(
          dataKey: 'revenue',
          name: 'Revenue',
          color: Colors.blue,
        ),
      ]);

      notifier.toggle('revenue');
      expect(notifier.isHidden('revenue'), true);
      expect(notifier.isVisible('revenue'), false);

      notifier.toggle('revenue');
      expect(notifier.isHidden('revenue'), false);
      expect(notifier.isVisible('revenue'), true);
    });

    test('hide adds series to hidden set', () {
      final notifier = LegendStateNotifier();
      notifier.setEntries([
        const LegendEntry(
          dataKey: 'revenue',
          name: 'Revenue',
          color: Colors.blue,
        ),
      ]);

      notifier.hide('revenue');
      expect(notifier.isHidden('revenue'), true);

      notifier.hide('revenue');
      expect(notifier.isHidden('revenue'), true);
    });

    test('show removes series from hidden set', () {
      final notifier = LegendStateNotifier();
      notifier.setEntries([
        const LegendEntry(
          dataKey: 'revenue',
          name: 'Revenue',
          color: Colors.blue,
        ),
      ]);

      notifier.hide('revenue');
      notifier.show('revenue');
      expect(notifier.isHidden('revenue'), false);
    });

    test('showAll clears hidden set', () {
      final notifier = LegendStateNotifier();
      notifier.setEntries([
        const LegendEntry(dataKey: 'a', name: 'A', color: Colors.blue),
        const LegendEntry(dataKey: 'b', name: 'B', color: Colors.red),
      ]);

      notifier.hide('a');
      notifier.hide('b');
      notifier.showAll();

      expect(notifier.hiddenSeries, isEmpty);
    });

    test('hideAll hides all entries', () {
      final notifier = LegendStateNotifier();
      notifier.setEntries([
        const LegendEntry(dataKey: 'a', name: 'A', color: Colors.blue),
        const LegendEntry(dataKey: 'b', name: 'B', color: Colors.red),
      ]);

      notifier.hideAll();

      expect(notifier.isHidden('a'), true);
      expect(notifier.isHidden('b'), true);
    });

    test('setEntries updates entry visibility based on hidden set', () {
      final notifier = LegendStateNotifier();

      notifier.hide('revenue');

      notifier.setEntries([
        const LegendEntry(dataKey: 'revenue', name: 'Revenue', color: Colors.blue),
        const LegendEntry(dataKey: 'profit', name: 'Profit', color: Colors.green),
      ]);

      final revenueEntry = notifier.entries.firstWhere((e) => e.dataKey == 'revenue');
      final profitEntry = notifier.entries.firstWhere((e) => e.dataKey == 'profit');

      expect(revenueEntry.visible, false);
      expect(profitEntry.visible, true);
    });

    test('updateFromSeriesInfo creates entries from series info', () {
      final notifier = LegendStateNotifier();

      notifier.updateFromSeriesInfo([
        const SeriesInfo(
          dataKey: 'revenue',
          name: 'Revenue',
          color: Colors.blue,
          legendType: LegendType.line,
        ),
      ]);

      expect(notifier.entries.length, 1);
      expect(notifier.entries.first.dataKey, 'revenue');
      expect(notifier.entries.first.name, 'Revenue');
    });

    test('notifies listeners on state changes', () {
      final notifier = LegendStateNotifier();
      notifier.setEntries([
        const LegendEntry(dataKey: 'a', name: 'A', color: Colors.blue),
      ]);

      int notifyCount = 0;
      notifier.addListener(() {
        notifyCount++;
      });

      notifier.toggle('a');
      expect(notifyCount, 1);

      notifier.show('a');
      expect(notifyCount, 2);

      notifier.hide('a');
      expect(notifyCount, 3);
    });
  });

  group('SeriesInfo', () {
    test('creates with required fields', () {
      const info = SeriesInfo(
        dataKey: 'value',
        color: Colors.blue,
      );

      expect(info.dataKey, 'value');
      expect(info.name, isNull);
      expect(info.color, Colors.blue);
      expect(info.legendType, LegendType.square);
    });

    test('creates with all fields', () {
      const info = SeriesInfo(
        dataKey: 'value',
        name: 'My Value',
        color: Colors.red,
        legendType: LegendType.circle,
      );

      expect(info.dataKey, 'value');
      expect(info.name, 'My Value');
      expect(info.color, Colors.red);
      expect(info.legendType, LegendType.circle);
    });
  });
}
