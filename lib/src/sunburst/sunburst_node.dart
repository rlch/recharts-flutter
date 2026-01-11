import 'dart:ui';

class SunburstNode {
  final String? name;
  final double? value;
  final List<SunburstNode>? children;
  final Color? color;
  final Map<String, dynamic>? data;

  const SunburstNode({
    this.name,
    this.value,
    this.children,
    this.color,
    this.data,
  });

  double get computedValue {
    if (value != null) return value!;
    if (children == null || children!.isEmpty) return 0;
    return children!.fold(0, (sum, child) => sum + child.computedValue);
  }

  bool get isLeaf => children == null || children!.isEmpty;

  int get depth {
    if (isLeaf) return 0;
    int maxChildDepth = 0;
    for (final child in children!) {
      final childDepth = child.depth;
      if (childDepth > maxChildDepth) maxChildDepth = childDepth;
    }
    return maxChildDepth + 1;
  }

  factory SunburstNode.fromMap(Map<String, dynamic> map, {
    String nameKey = 'name',
    String valueKey = 'value',
    String childrenKey = 'children',
  }) {
    final children = map[childrenKey] as List?;
    return SunburstNode(
      name: map[nameKey]?.toString(),
      value: (map[valueKey] as num?)?.toDouble(),
      children: children?.map((c) => SunburstNode.fromMap(
        c as Map<String, dynamic>,
        nameKey: nameKey,
        valueKey: valueKey,
        childrenKey: childrenKey,
      )).toList(),
      data: map,
    );
  }
}

class SunburstSector {
  final SunburstNode node;
  final double startAngle;
  final double endAngle;
  final double innerRadius;
  final double outerRadius;
  final int depth;
  final Color color;

  const SunburstSector({
    required this.node,
    required this.startAngle,
    required this.endAngle,
    required this.innerRadius,
    required this.outerRadius,
    required this.depth,
    required this.color,
  });

  double get sweepAngle => endAngle - startAngle;
  double get midAngle => (startAngle + endAngle) / 2;
  double get midRadius => (innerRadius + outerRadius) / 2;
}
