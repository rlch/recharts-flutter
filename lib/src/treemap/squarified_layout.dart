import 'dart:math' as math;
import 'dart:ui';

import 'treemap_node.dart';

class SquarifiedLayout {
  static List<TreemapRect> compute({
    required TreemapNode root,
    required Rect bounds,
    required List<Color> colors,
    int depth = 0,
  }) {
    final results = <TreemapRect>[];
    
    if (root.isLeaf) {
      results.add(TreemapRect(
        node: root,
        rect: bounds,
        depth: depth,
        color: colors[depth % colors.length],
      ));
      return results;
    }

    final children = root.children!;
    if (children.isEmpty) return results;

    final sortedChildren = List<TreemapNode>.from(children)
      ..sort((a, b) => b.computedValue.compareTo(a.computedValue));

    final totalValue = sortedChildren.fold<double>(
      0,
      (sum, node) => sum + node.computedValue,
    );

    if (totalValue == 0) return results;

    final rects = _squarify(
      children: sortedChildren,
      bounds: bounds,
      totalValue: totalValue,
    );

    for (int i = 0; i < rects.length; i++) {
      final node = sortedChildren[i];
      final rect = rects[i];

      if (node.isLeaf) {
        results.add(TreemapRect(
          node: node,
          rect: rect,
          depth: depth,
          color: node.color ?? colors[i % colors.length],
        ));
      } else {
        results.addAll(compute(
          root: node,
          bounds: rect,
          colors: colors,
          depth: depth + 1,
        ));
      }
    }

    return results;
  }

  static List<Rect> _squarify({
    required List<TreemapNode> children,
    required Rect bounds,
    required double totalValue,
  }) {
    if (children.isEmpty) return [];
    if (children.length == 1) return [bounds];

    final results = <Rect>[];
    var remaining = List<TreemapNode>.from(children);
    var currentBounds = bounds;
    var remainingValue = totalValue;

    while (remaining.isNotEmpty) {
      final isHorizontal = currentBounds.width >= currentBounds.height;
      final side = isHorizontal ? currentBounds.height : currentBounds.width;

      final row = _layoutRow(
        nodes: remaining,
        side: side,
        remainingValue: remainingValue,
      );

      final rowNodes = remaining.sublist(0, row.count);
      final rowValue = rowNodes.fold<double>(
        0,
        (sum, node) => sum + node.computedValue,
      );

      final rowSize = (rowValue / remainingValue) *
          (isHorizontal ? currentBounds.width : currentBounds.height);

      Rect rowBounds;
      if (isHorizontal) {
        rowBounds = Rect.fromLTWH(
          currentBounds.left,
          currentBounds.top,
          rowSize,
          currentBounds.height,
        );
        currentBounds = Rect.fromLTWH(
          currentBounds.left + rowSize,
          currentBounds.top,
          currentBounds.width - rowSize,
          currentBounds.height,
        );
      } else {
        rowBounds = Rect.fromLTWH(
          currentBounds.left,
          currentBounds.top,
          currentBounds.width,
          rowSize,
        );
        currentBounds = Rect.fromLTWH(
          currentBounds.left,
          currentBounds.top + rowSize,
          currentBounds.width,
          currentBounds.height - rowSize,
        );
      }

      final rowRects = _layoutRowRects(
        nodes: rowNodes,
        bounds: rowBounds,
        isHorizontal: isHorizontal,
        rowValue: rowValue,
      );

      results.addAll(rowRects);
      remaining = remaining.sublist(row.count);
      remainingValue -= rowValue;
    }

    return results;
  }

  static ({int count, double worstRatio}) _layoutRow({
    required List<TreemapNode> nodes,
    required double side,
    required double remainingValue,
  }) {
    if (nodes.isEmpty) return (count: 0, worstRatio: double.infinity);

    int count = 1;
    double sum = nodes[0].computedValue;
    double minValue = nodes[0].computedValue;
    double maxValue = nodes[0].computedValue;
    double worstRatio = _worstAspectRatio(sum, minValue, maxValue, side, remainingValue);

    for (int i = 1; i < nodes.length; i++) {
      final value = nodes[i].computedValue;
      final newSum = sum + value;
      final newMin = math.min(minValue, value);
      final newMax = math.max(maxValue, value);
      final newRatio = _worstAspectRatio(newSum, newMin, newMax, side, remainingValue);

      if (newRatio > worstRatio) {
        break;
      }

      count = i + 1;
      sum = newSum;
      minValue = newMin;
      maxValue = newMax;
      worstRatio = newRatio;
    }

    return (count: count, worstRatio: worstRatio);
  }

  static double _worstAspectRatio(
    double sum,
    double minValue,
    double maxValue,
    double side,
    double totalValue,
  ) {
    if (sum == 0 || totalValue == 0) return double.infinity;

    final areaRatio = sum / totalValue;
    final rowWidth = side * areaRatio;

    if (rowWidth == 0) return double.infinity;

    final minHeight = (minValue / sum) * side;
    final maxHeight = (maxValue / sum) * side;

    final ratio1 = rowWidth / minHeight;
    final ratio2 = maxHeight / rowWidth;

    return math.max(ratio1, ratio2);
  }

  static List<Rect> _layoutRowRects({
    required List<TreemapNode> nodes,
    required Rect bounds,
    required bool isHorizontal,
    required double rowValue,
  }) {
    final results = <Rect>[];
    double offset = 0;

    for (final node in nodes) {
      final fraction = rowValue > 0 ? node.computedValue / rowValue : 0.0;
      final size = fraction *
          (isHorizontal ? bounds.height : bounds.width);

      Rect rect;
      if (isHorizontal) {
        rect = Rect.fromLTWH(
          bounds.left,
          bounds.top + offset,
          bounds.width,
          size,
        );
      } else {
        rect = Rect.fromLTWH(
          bounds.left + offset,
          bounds.top,
          size,
          bounds.height,
        );
      }

      results.add(rect);
      offset += size;
    }

    return results;
  }
}
