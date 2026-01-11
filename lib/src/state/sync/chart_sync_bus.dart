/// Cross-chart synchronization bus for coordinating tooltips and interactions.
///
/// Charts with the same `syncId` share interaction state. When one chart
/// hovers over an index, all synced charts show tooltips at the same index.
library;

import 'dart:ui';

/// The method used to synchronize charts.
enum SyncMethod {
  /// Sync by data index (default) - all charts show same index.
  byIndex,

  /// Sync by value on the shared axis.
  byValue,
}

/// Payload broadcast when a synced chart's hover state changes.
class SyncHoverPayload {
  /// The sync group identifier.
  final String syncId;

  /// The data index being hovered (for index sync).
  final int? index;

  /// The coordinate value on shared axis (for value sync).
  final dynamic value;

  /// The position within the source chart.
  final Offset? coordinate;

  /// The chart instance that initiated the sync event.
  final String? sourceChartId;

  const SyncHoverPayload({
    required this.syncId,
    this.index,
    this.value,
    this.coordinate,
    this.sourceChartId,
  });

  @override
  String toString() =>
      'SyncHoverPayload(syncId: $syncId, index: $index, value: $value)';
}

/// Callback signature for sync state changes.
typedef SyncStateCallback = void Function(SyncHoverPayload? payload);

/// A bus for coordinating tooltip/interaction state across multiple charts.
///
/// This is a singleton per sync group. Charts register/unregister themselves
/// and receive updates when any chart in the group changes interaction state.
///
/// ## Example
/// ```dart
/// // Chart A notifies hover
/// ChartSyncBus.instance.notifyHover(
///   payload: SyncHoverPayload(syncId: 'group1', index: 5),
/// );
///
/// // Chart B receives the update via its registered callback
/// ```
class ChartSyncBus {
  ChartSyncBus._();

  static final ChartSyncBus instance = ChartSyncBus._();

  /// Map of syncId -> list of registered callbacks.
  final Map<String, List<SyncStateCallback>> _listeners = {};

  /// Current state for each sync group.
  final Map<String, SyncHoverPayload?> _currentState = {};

  /// Registers a chart to receive sync updates.
  ///
  /// Returns a dispose function to unregister.
  VoidCallback register(String syncId, SyncStateCallback callback) {
    _listeners.putIfAbsent(syncId, () => []);
    _listeners[syncId]!.add(callback);

    // Immediately notify with current state if any
    final currentState = _currentState[syncId];
    if (currentState != null) {
      callback(currentState);
    }

    return () => unregister(syncId, callback);
  }

  /// Unregisters a chart from sync updates.
  void unregister(String syncId, SyncStateCallback callback) {
    _listeners[syncId]?.remove(callback);
    if (_listeners[syncId]?.isEmpty ?? false) {
      _listeners.remove(syncId);
      _currentState.remove(syncId);
    }
  }

  /// Notifies all charts in the sync group of a hover event.
  void notifyHover(SyncHoverPayload payload) {
    _currentState[payload.syncId] = payload;
    final listeners = _listeners[payload.syncId];
    if (listeners != null) {
      for (final callback in listeners) {
        callback(payload);
      }
    }
  }

  /// Clears the hover state for a sync group.
  void clearHover(String syncId, {String? sourceChartId}) {
    _currentState[syncId] = null;
    final listeners = _listeners[syncId];
    if (listeners != null) {
      for (final callback in listeners) {
        callback(null);
      }
    }
  }

  /// Gets the current state for a sync group.
  SyncHoverPayload? getState(String syncId) => _currentState[syncId];

  /// Clears all registered listeners (useful for testing).
  void reset() {
    _listeners.clear();
    _currentState.clear();
  }
}
