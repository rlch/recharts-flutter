import 'dart:math' as math;
import 'dart:ui';

import 'sankey_data.dart';

class SankeyLayout {
  final double nodeWidth;
  final double nodePadding;
  final int iterations;

  const SankeyLayout({
    this.nodeWidth = 24,
    this.nodePadding = 8,
    this.iterations = 32,
  });

  ({List<SankeyNodeGeometry> nodes, List<SankeyLinkGeometry> links}) compute({
    required SankeyData data,
    required Rect bounds,
    required List<Color> colors,
  }) {
    if (data.nodes.isEmpty) {
      return (nodes: [], links: []);
    }

    final nodeMap = <String, _NodeState>{};
    for (int i = 0; i < data.nodes.length; i++) {
      final node = data.nodes[i];
      nodeMap[node.id] = _NodeState(
        node: node,
        sourceLinks: [],
        targetLinks: [],
        value: 0,
        layer: 0,
        y: 0,
        color: node.color ?? colors[i % colors.length],
      );
    }

    for (final link in data.links) {
      final source = nodeMap[link.source];
      final target = nodeMap[link.target];
      if (source != null && target != null) {
        source.sourceLinks.add(link);
        target.targetLinks.add(link);
      }
    }

    for (final state in nodeMap.values) {
      final outValue = state.sourceLinks.fold<double>(0, (sum, l) => sum + l.value);
      final inValue = state.targetLinks.fold<double>(0, (sum, l) => sum + l.value);
      state.value = math.max(outValue, inValue);
      if (state.value == 0 && state.node.value != null) {
        state.value = state.node.value!;
      }
    }

    _computeLayers(nodeMap, data.links);

    final layers = _groupByLayer(nodeMap);
    final numLayers = layers.length;
    if (numLayers == 0) {
      return (nodes: [], links: []);
    }

    final availableWidth = bounds.width - nodeWidth;
    final layerWidth = numLayers > 1 ? availableWidth / (numLayers - 1) : 0.0;

    for (int i = 0; i < layers.length; i++) {
      final x = bounds.left + i * layerWidth;
      for (final state in layers[i]) {
        state.x = x;
      }
    }

    _initializeYPositions(layers, bounds);

    for (int i = 0; i < iterations; i++) {
      _relaxRightToLeft(layers, bounds);
      _relaxLeftToRight(layers, bounds);
    }

    final nodeGeometries = <SankeyNodeGeometry>[];
    for (final state in nodeMap.values) {
      nodeGeometries.add(SankeyNodeGeometry(
        node: state.node,
        x: state.x,
        y: state.y,
        width: nodeWidth,
        height: state.height,
        value: state.value,
        layer: state.layer,
        color: state.color,
      ));
    }

    final linkGeometries = <SankeyLinkGeometry>[];
    final sourceOffsets = <String, double>{};
    final targetOffsets = <String, double>{};

    for (final link in data.links) {
      final sourceState = nodeMap[link.source];
      final targetState = nodeMap[link.target];
      if (sourceState == null || targetState == null) continue;

      final sourceNodeGeo = nodeGeometries.firstWhere(
        (n) => n.node.id == link.source,
      );
      final targetNodeGeo = nodeGeometries.firstWhere(
        (n) => n.node.id == link.target,
      );

      final totalSourceValue = sourceState.value;
      final totalTargetValue = targetState.value;

      final thickness = totalSourceValue > 0
          ? (link.value / totalSourceValue) * sourceState.height
          : 0.0;

      final sourceOffset = sourceOffsets[link.source] ?? 0;
      final targetOffset = targetOffsets[link.target] ?? 0;

      final sourceY = sourceState.y + sourceOffset + thickness / 2;
      final targetY = targetState.y + targetOffset +
          (totalTargetValue > 0
              ? (link.value / totalTargetValue) * targetState.height / 2
              : 0);

      sourceOffsets[link.source] = sourceOffset + thickness;
      targetOffsets[link.target] = targetOffset +
          (totalTargetValue > 0
              ? (link.value / totalTargetValue) * targetState.height
              : 0);

      linkGeometries.add(SankeyLinkGeometry(
        link: link,
        sourceNode: sourceNodeGeo,
        targetNode: targetNodeGeo,
        sourceY: sourceY,
        targetY: targetY,
        thickness: thickness,
        color: link.color ?? sourceState.color.withValues(alpha: 0.5),
      ));
    }

    return (nodes: nodeGeometries, links: linkGeometries);
  }

  void _computeLayers(Map<String, _NodeState> nodeMap, List<SankeyLink> links) {
    final remaining = Set<String>.from(nodeMap.keys);
    int layer = 0;

    while (remaining.isNotEmpty) {
      final currentLayer = <String>[];

      for (final id in remaining) {
        final state = nodeMap[id]!;
        final allSourcesAssigned = state.targetLinks.every((link) {
          final sourceState = nodeMap[link.source];
          return sourceState == null || !remaining.contains(link.source);
        });

        if (allSourcesAssigned) {
          currentLayer.add(id);
          state.layer = layer;
        }
      }

      if (currentLayer.isEmpty) {
        for (final id in remaining) {
          nodeMap[id]!.layer = layer;
        }
        break;
      }

      remaining.removeAll(currentLayer);
      layer++;
    }
  }

  List<List<_NodeState>> _groupByLayer(Map<String, _NodeState> nodeMap) {
    final maxLayer = nodeMap.values.fold<int>(0, (max, s) => math.max(max, s.layer));
    final layers = List.generate(maxLayer + 1, (_) => <_NodeState>[]);

    for (final state in nodeMap.values) {
      layers[state.layer].add(state);
    }

    return layers;
  }

  void _initializeYPositions(List<List<_NodeState>> layers, Rect bounds) {
    for (final layer in layers) {
      if (layer.isEmpty) continue;

      final totalValue = layer.fold<double>(0, (sum, s) => sum + s.value);
      final availableHeight = bounds.height - (layer.length - 1) * nodePadding;
      
      double y = bounds.top;
      for (final state in layer) {
        final height = totalValue > 0
            ? (state.value / totalValue) * availableHeight
            : availableHeight / layer.length;
        state.height = height;
        state.y = y;
        y += height + nodePadding;
      }
    }
  }

  void _relaxLeftToRight(List<List<_NodeState>> layers, Rect bounds) {
    for (int i = 1; i < layers.length; i++) {
      for (final state in layers[i]) {
        if (state.targetLinks.isEmpty) continue;

        double weightedY = 0;
        double totalWeight = 0;

        for (final link in state.targetLinks) {
          final sourceState = layers[state.layer > 0 ? state.layer - 1 : 0]
              .cast<_NodeState?>()
              .firstWhere((s) => s?.node.id == link.source, orElse: () => null);
          if (sourceState != null) {
            weightedY += (sourceState.y + sourceState.height / 2) * link.value;
            totalWeight += link.value;
          }
        }

        if (totalWeight > 0) {
          final targetY = weightedY / totalWeight - state.height / 2;
          state.y = targetY.clamp(bounds.top, bounds.bottom - state.height);
        }
      }

      _resolveCollisions(layers[i], bounds);
    }
  }

  void _relaxRightToLeft(List<List<_NodeState>> layers, Rect bounds) {
    for (int i = layers.length - 2; i >= 0; i--) {
      for (final state in layers[i]) {
        if (state.sourceLinks.isEmpty) continue;

        double weightedY = 0;
        double totalWeight = 0;

        for (final link in state.sourceLinks) {
          final targetState = layers[math.min(state.layer + 1, layers.length - 1)]
              .cast<_NodeState?>()
              .firstWhere((s) => s?.node.id == link.target, orElse: () => null);
          if (targetState != null) {
            weightedY += (targetState.y + targetState.height / 2) * link.value;
            totalWeight += link.value;
          }
        }

        if (totalWeight > 0) {
          final targetY = weightedY / totalWeight - state.height / 2;
          state.y = targetY.clamp(bounds.top, bounds.bottom - state.height);
        }
      }

      _resolveCollisions(layers[i], bounds);
    }
  }

  void _resolveCollisions(List<_NodeState> layer, Rect bounds) {
    layer.sort((a, b) => a.y.compareTo(b.y));

    double y = bounds.top;
    for (final state in layer) {
      final dy = y - state.y;
      if (dy > 0) {
        state.y += dy;
      }
      y = state.y + state.height + nodePadding;
    }

    y = bounds.bottom;
    for (int i = layer.length - 1; i >= 0; i--) {
      final state = layer[i];
      final dy = state.y + state.height - y;
      if (dy > 0) {
        state.y -= dy;
      }
      y = state.y - nodePadding;
    }
  }
}

class _NodeState {
  final SankeyNode node;
  final List<SankeyLink> sourceLinks;
  final List<SankeyLink> targetLinks;
  double value;
  int layer;
  double x = 0;
  double y;
  double height = 0;
  final Color color;

  _NodeState({
    required this.node,
    required this.sourceLinks,
    required this.targetLinks,
    required this.value,
    required this.layer,
    required this.y,
    required this.color,
  });
}
