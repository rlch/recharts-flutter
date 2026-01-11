import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recharts_flutter/src/components/legend/legend.dart';
import 'package:recharts_flutter/src/core/types/series_types.dart';

void main() {
  group('LegendEntry', () {
    test('creates entry with default values', () {
      const entry = LegendEntry(
        dataKey: 'value',
        name: 'Value',
        color: Colors.blue,
      );

      expect(entry.dataKey, 'value');
      expect(entry.name, 'Value');
      expect(entry.color, Colors.blue);
      expect(entry.iconType, LegendType.square);
      expect(entry.visible, true);
    });

    test('toggleVisibility flips visible state', () {
      const entry = LegendEntry(
        dataKey: 'value',
        name: 'Value',
        color: Colors.blue,
        visible: true,
      );

      final toggled = entry.toggleVisibility();
      expect(toggled.visible, false);

      final toggledBack = toggled.toggleVisibility();
      expect(toggledBack.visible, true);
    });

    test('copyWith creates new entry with updated values', () {
      const entry = LegendEntry(
        dataKey: 'value',
        name: 'Value',
        color: Colors.blue,
      );

      final updated = entry.copyWith(
        name: 'New Name',
        visible: false,
      );

      expect(updated.dataKey, 'value');
      expect(updated.name, 'New Name');
      expect(updated.color, Colors.blue);
      expect(updated.visible, false);
    });
  });

  group('ChartLegend', () {
    test('has correct default values', () {
      const legend = ChartLegend();

      expect(legend.enabled, true);
      expect(legend.layout, LegendLayout.horizontal);
      expect(legend.align, LegendAlign.center);
      expect(legend.verticalAlign, LegendVerticalAlign.bottom);
      expect(legend.iconSize, 14);
      expect(legend.itemGap, 10);
      expect(legend.interactive, true);
    });

    test('copyWith creates new config with updated values', () {
      const legend = ChartLegend();

      final updated = legend.copyWith(
        layout: LegendLayout.vertical,
        interactive: false,
      );

      expect(updated.layout, LegendLayout.vertical);
      expect(updated.interactive, false);
      expect(updated.enabled, true);
    });
  });

  group('DefaultLegendContent', () {
    testWidgets('renders legend items', (tester) async {
      final entries = [
        const LegendEntry(
          dataKey: 'revenue',
          name: 'Revenue',
          color: Colors.blue,
        ),
        const LegendEntry(
          dataKey: 'profit',
          name: 'Profit',
          color: Colors.green,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DefaultLegendContent(
              entries: entries,
              config: const ChartLegend(),
            ),
          ),
        ),
      );

      expect(find.text('Revenue'), findsOneWidget);
      expect(find.text('Profit'), findsOneWidget);
    });

    testWidgets('handles item tap callback', (tester) async {
      final entries = [
        const LegendEntry(
          dataKey: 'revenue',
          name: 'Revenue',
          color: Colors.blue,
        ),
      ];

      LegendEntry? tappedEntry;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DefaultLegendContent(
              entries: entries,
              config: const ChartLegend(),
              onItemTap: (entry) {
                tappedEntry = entry;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Revenue'));
      await tester.pumpAndSettle();

      expect(tappedEntry, isNotNull);
      expect(tappedEntry!.dataKey, 'revenue');
    });

    testWidgets('shows reduced opacity for hidden entries', (tester) async {
      final entries = [
        const LegendEntry(
          dataKey: 'revenue',
          name: 'Revenue',
          color: Colors.blue,
          visible: false,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DefaultLegendContent(
              entries: entries,
              config: const ChartLegend(),
            ),
          ),
        ),
      );

      final opacityFinder = find.byType(Opacity);
      expect(opacityFinder, findsOneWidget);

      final opacity = tester.widget<Opacity>(opacityFinder);
      expect(opacity.opacity, 0.3);
    });

    testWidgets('renders vertical layout', (tester) async {
      final entries = [
        const LegendEntry(
          dataKey: 'a',
          name: 'A',
          color: Colors.blue,
        ),
        const LegendEntry(
          dataKey: 'b',
          name: 'B',
          color: Colors.red,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DefaultLegendContent(
              entries: entries,
              config: const ChartLegend(layout: LegendLayout.vertical),
            ),
          ),
        ),
      );

      expect(find.byType(Column), findsOneWidget);
    });
  });

  group('LegendWidget', () {
    testWidgets('returns empty when disabled', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LegendWidget(
              entries: [],
              config: ChartLegend(enabled: false),
            ),
          ),
        ),
      );

      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('returns empty when no entries', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LegendWidget(
              entries: [],
              config: ChartLegend(),
            ),
          ),
        ),
      );

      expect(find.byType(SizedBox), findsOneWidget);
    });
  });
}
