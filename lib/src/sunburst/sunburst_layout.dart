import 'dart:math' as math;
import 'dart:ui';

import 'sunburst_node.dart';

class SunburstLayout {
  static List<SunburstSector> compute({
    required SunburstNode root,
    required Offset center,
    required double innerRadius,
    required double outerRadius,
    required List<Color> colors,
    double startAngle = 0,
    double endAngle = 2 * math.pi,
  }) {
    final maxDepth = root.depth;
    if (maxDepth == 0) {
      return [
        SunburstSector(
          node: root,
          startAngle: startAngle,
          endAngle: endAngle,
          innerRadius: innerRadius,
          outerRadius: outerRadius,
          depth: 0,
          color: root.color ?? colors[0],
        ),
      ];
    }

    final ringWidth = (outerRadius - innerRadius) / (maxDepth + 1);
    final results = <SunburstSector>[];

    _computeRecursive(
      node: root,
      startAngle: startAngle,
      endAngle: endAngle,
      depth: 0,
      innerRadius: innerRadius,
      ringWidth: ringWidth,
      colors: colors,
      results: results,
      colorIndex: 0,
    );

    return results;
  }

  static int _computeRecursive({
    required SunburstNode node,
    required double startAngle,
    required double endAngle,
    required int depth,
    required double innerRadius,
    required double ringWidth,
    required List<Color> colors,
    required List<SunburstSector> results,
    required int colorIndex,
  }) {
    final sectorInnerRadius = innerRadius + depth * ringWidth;
    final sectorOuterRadius = sectorInnerRadius + ringWidth;

    final color = node.color ?? colors[colorIndex % colors.length];

    results.add(SunburstSector(
      node: node,
      startAngle: startAngle,
      endAngle: endAngle,
      innerRadius: sectorInnerRadius,
      outerRadius: sectorOuterRadius,
      depth: depth,
      color: color,
    ));

    if (node.isLeaf) return colorIndex + 1;

    final children = node.children!;
    final totalValue = node.computedValue;
    if (totalValue == 0) return colorIndex + 1;

    final angleRange = endAngle - startAngle;
    double currentAngle = startAngle;
    int currentColorIndex = colorIndex;

    for (final child in children) {
      final childValue = child.computedValue;
      final childAngle = (childValue / totalValue) * angleRange;

      currentColorIndex = _computeRecursive(
        node: child,
        startAngle: currentAngle,
        endAngle: currentAngle + childAngle,
        depth: depth + 1,
        innerRadius: innerRadius,
        ringWidth: ringWidth,
        colors: colors,
        results: results,
        colorIndex: currentColorIndex,
      );

      currentAngle += childAngle;
    }

    return currentColorIndex;
  }
}
