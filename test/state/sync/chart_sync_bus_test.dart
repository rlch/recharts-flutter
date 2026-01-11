import 'package:flutter_test/flutter_test.dart';
import 'package:recharts_flutter/recharts_flutter.dart';

void main() {
  setUp(() {
    ChartSyncBus.instance.reset();
  });

  group('ChartSyncBus', () {
    test('registers and receives updates', () {
      final received = <SyncHoverPayload?>[];

      ChartSyncBus.instance.register('group1', (payload) {
        received.add(payload);
      });

      ChartSyncBus.instance.notifyHover(const SyncHoverPayload(
        syncId: 'group1',
        index: 5,
      ));

      expect(received.length, 1);
      expect(received.first?.index, 5);
    });

    test('only notifies registered sync group', () {
      final group1Received = <SyncHoverPayload?>[];
      final group2Received = <SyncHoverPayload?>[];

      ChartSyncBus.instance.register('group1', (payload) {
        group1Received.add(payload);
      });
      ChartSyncBus.instance.register('group2', (payload) {
        group2Received.add(payload);
      });

      ChartSyncBus.instance.notifyHover(const SyncHoverPayload(
        syncId: 'group1',
        index: 3,
      ));

      expect(group1Received.length, 1);
      expect(group2Received.length, 0);
    });

    test('unregisters correctly', () {
      final received = <SyncHoverPayload?>[];

      void callback(SyncHoverPayload? payload) {
        received.add(payload);
      }

      final unsubscribe = ChartSyncBus.instance.register('group1', callback);

      ChartSyncBus.instance.notifyHover(const SyncHoverPayload(
        syncId: 'group1',
        index: 1,
      ));

      expect(received.length, 1);

      unsubscribe();

      ChartSyncBus.instance.notifyHover(const SyncHoverPayload(
        syncId: 'group1',
        index: 2,
      ));

      expect(received.length, 1);
    });

    test('clearHover sends null to listeners', () {
      final received = <SyncHoverPayload?>[];

      ChartSyncBus.instance.register('group1', (payload) {
        received.add(payload);
      });

      ChartSyncBus.instance.notifyHover(const SyncHoverPayload(
        syncId: 'group1',
        index: 5,
      ));

      ChartSyncBus.instance.clearHover('group1');

      expect(received.length, 2);
      expect(received.first?.index, 5);
      expect(received.last, isNull);
    });

    test('new subscribers receive current state', () {
      ChartSyncBus.instance.notifyHover(const SyncHoverPayload(
        syncId: 'group1',
        index: 7,
      ));

      final received = <SyncHoverPayload?>[];

      ChartSyncBus.instance.register('group1', (payload) {
        received.add(payload);
      });

      expect(received.length, 1);
      expect(received.first?.index, 7);
    });

    test('multiple listeners in same group', () {
      final listener1 = <SyncHoverPayload?>[];
      final listener2 = <SyncHoverPayload?>[];

      ChartSyncBus.instance.register('group1', (p) => listener1.add(p));
      ChartSyncBus.instance.register('group1', (p) => listener2.add(p));

      ChartSyncBus.instance.notifyHover(const SyncHoverPayload(
        syncId: 'group1',
        index: 10,
      ));

      expect(listener1.length, 1);
      expect(listener2.length, 1);
    });

    test('payload includes coordinate and value', () {
      SyncHoverPayload? received;

      ChartSyncBus.instance.register('group1', (payload) {
        received = payload;
      });

      ChartSyncBus.instance.notifyHover(const SyncHoverPayload(
        syncId: 'group1',
        index: 3,
        value: 'Jan',
        coordinate: Offset(100, 50),
        sourceChartId: 'chart1',
      ));

      expect(received?.index, 3);
      expect(received?.value, 'Jan');
      expect(received?.coordinate, const Offset(100, 50));
      expect(received?.sourceChartId, 'chart1');
    });

    test('getState returns current state', () {
      expect(ChartSyncBus.instance.getState('group1'), isNull);

      ChartSyncBus.instance.register('group1', (_) {});
      ChartSyncBus.instance.notifyHover(const SyncHoverPayload(
        syncId: 'group1',
        index: 5,
      ));

      final state = ChartSyncBus.instance.getState('group1');
      expect(state?.index, 5);
    });
  });

  group('SyncMethod', () {
    test('enum values exist', () {
      expect(SyncMethod.byIndex, isNotNull);
      expect(SyncMethod.byValue, isNotNull);
    });
  });
}
