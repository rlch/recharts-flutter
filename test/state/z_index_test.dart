import 'package:flutter_test/flutter_test.dart';
import 'package:recharts_flutter/recharts_flutter.dart';

void main() {
  group('ChartLayer', () {
    test('has correct default z-index values', () {
      expect(ChartLayer.grid.defaultZIndex, 0);
      expect(ChartLayer.series.defaultZIndex, 100);
      expect(ChartLayer.axes.defaultZIndex, 200);
      expect(ChartLayer.reference.defaultZIndex, 300);
      expect(ChartLayer.cursor.defaultZIndex, 400);
      expect(ChartLayer.tooltip.defaultZIndex, 500);
      expect(ChartLayer.legend.defaultZIndex, 600);
    });

    test('layers are ordered correctly', () {
      final layers = ChartLayer.values.toList()
        ..sort((a, b) => a.defaultZIndex.compareTo(b.defaultZIndex));

      expect(layers, [
        ChartLayer.grid,
        ChartLayer.series,
        ChartLayer.axes,
        ChartLayer.reference,
        ChartLayer.cursor,
        ChartLayer.tooltip,
        ChartLayer.legend,
      ]);
    });
  });

  group('ZIndexConfig', () {
    test('creates with zIndex', () {
      const config = ZIndexConfig(zIndex: 150);
      expect(config.zIndex, 150);
      expect(config.id, isNull);
    });

    test('creates with id', () {
      const config = ZIndexConfig(zIndex: 100, id: 'lineSeries1');
      expect(config.zIndex, 100);
      expect(config.id, 'lineSeries1');
    });

    test('fromLayer creates correct config', () {
      final config = ZIndexConfig.fromLayer(ChartLayer.series);
      expect(config.zIndex, 100);
    });

    test('fromLayer with offset', () {
      final config = ZIndexConfig.fromLayer(ChartLayer.series, offset: 10);
      expect(config.zIndex, 110);
    });
  });

  group('ZIndexRegistry', () {
    late ZIndexRegistry registry;

    setUp(() {
      registry = ZIndexRegistry();
    });

    test('registers and retrieves component', () {
      registry.register('tooltip', const ZIndexConfig(zIndex: 500));
      expect(registry.getZIndex('tooltip'), 500);
    });

    test('returns default layer value for unregistered', () {
      expect(
        registry.getZIndex('unknown', defaultLayer: ChartLayer.series),
        100,
      );
    });

    test('returns 0 for unregistered without default', () {
      expect(registry.getZIndex('unknown'), 0);
    });

    test('unregisters component', () {
      registry.register('tooltip', const ZIndexConfig(zIndex: 500));
      registry.unregister('tooltip');
      expect(registry.getZIndex('tooltip'), 0);
    });

    test('getSortedComponents returns in z-index order', () {
      registry.register('tooltip', const ZIndexConfig(zIndex: 500));
      registry.register('grid', const ZIndexConfig(zIndex: 0));
      registry.register('series', const ZIndexConfig(zIndex: 100));

      final sorted = registry.getSortedComponents();
      expect(sorted, ['grid', 'series', 'tooltip']);
    });

    test('clear removes all components', () {
      registry.register('tooltip', const ZIndexConfig(zIndex: 500));
      registry.register('grid', const ZIndexConfig(zIndex: 0));
      registry.clear();

      expect(registry.getSortedComponents(), isEmpty);
    });
  });

  group('sortByZIndex', () {
    test('sorts items by z-index', () {
      final items = [
        (name: 'tooltip', z: 500),
        (name: 'grid', z: 0),
        (name: 'series', z: 100),
      ];

      final sorted = sortByZIndex(items, (item) => item.z);

      expect(sorted.map((i) => i.name).toList(), ['grid', 'series', 'tooltip']);
    });
  });

  group('compareZIndex', () {
    test('returns negative when a < b', () {
      expect(compareZIndex(0, 100), lessThan(0));
    });

    test('returns positive when a > b', () {
      expect(compareZIndex(100, 0), greaterThan(0));
    });

    test('returns zero when equal', () {
      expect(compareZIndex(100, 100), 0);
    });
  });
}
