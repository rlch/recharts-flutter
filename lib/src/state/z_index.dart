/// Z-index layering system for chart components.
///
/// Controls the stacking order of chart elements. Higher z-index values
/// are rendered on top of lower values.
library;

/// Default z-index values for chart layers.
///
/// These define the default stacking order of chart elements.
/// Components are rendered from lowest to highest z-index.
enum ChartLayer {
  /// Background and grid lines (z: 0).
  grid(0),

  /// Data series (lines, bars, areas) (z: 100).
  series(100),

  /// Axes and tick marks (z: 200).
  axes(200),

  /// Reference lines, areas, and dots (z: 300).
  reference(300),

  /// Interactive cursor/crosshair (z: 400).
  cursor(400),

  /// Tooltip overlay (z: 500).
  tooltip(500),

  /// Legend (z: 600).
  legend(600);

  const ChartLayer(this.defaultZIndex);

  /// The default z-index for this layer.
  final int defaultZIndex;
}

/// Configuration for a component's z-index.
class ZIndexConfig {
  /// The z-index value. Higher values render on top.
  final int zIndex;

  /// Optional identifier for debugging.
  final String? id;

  const ZIndexConfig({
    required this.zIndex,
    this.id,
  });

  /// Creates a config from a [ChartLayer] with optional offset.
  factory ZIndexConfig.fromLayer(ChartLayer layer, {int offset = 0}) {
    return ZIndexConfig(zIndex: layer.defaultZIndex + offset);
  }

  @override
  String toString() => 'ZIndexConfig(zIndex: $zIndex, id: $id)';
}

/// Registry for tracking component z-indexes in a chart.
///
/// Used to properly order overlapping elements in the render tree.
class ZIndexRegistry {
  final Map<String, ZIndexConfig> _components = {};

  /// Registers a component with its z-index configuration.
  void register(String componentId, ZIndexConfig config) {
    _components[componentId] = config;
  }

  /// Unregisters a component.
  void unregister(String componentId) {
    _components.remove(componentId);
  }

  /// Gets the z-index for a component, or default layer value.
  int getZIndex(String componentId, {ChartLayer? defaultLayer}) {
    return _components[componentId]?.zIndex ??
        defaultLayer?.defaultZIndex ??
        0;
  }

  /// Returns all registered components sorted by z-index (ascending).
  List<String> getSortedComponents() {
    final entries = _components.entries.toList()
      ..sort((a, b) => a.value.zIndex.compareTo(b.value.zIndex));
    return entries.map((e) => e.key).toList();
  }

  /// Clears all registered components.
  void clear() {
    _components.clear();
  }
}

/// Compares two z-index values for sorting.
///
/// Returns negative if [a] should render before [b] (lower z-index).
int compareZIndex(int a, int b) => a.compareTo(b);

/// Sorts a list of items by their z-index using a getter function.
List<T> sortByZIndex<T>(List<T> items, int Function(T) getZIndex) {
  return List.of(items)..sort((a, b) => compareZIndex(getZIndex(a), getZIndex(b)));
}
