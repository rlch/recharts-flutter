import 'dart:ui';

class TreemapNode {
  final String? name;
  final double? value;
  final List<TreemapNode>? children;
  final Color? color;
  final Map<String, dynamic>? data;

  const TreemapNode({
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

  factory TreemapNode.fromMap(Map<String, dynamic> map, {
    String nameKey = 'name',
    String valueKey = 'value',
    String childrenKey = 'children',
  }) {
    final children = map[childrenKey] as List?;
    return TreemapNode(
      name: map[nameKey]?.toString(),
      value: (map[valueKey] as num?)?.toDouble(),
      children: children?.map((c) => TreemapNode.fromMap(
        c as Map<String, dynamic>,
        nameKey: nameKey,
        valueKey: valueKey,
        childrenKey: childrenKey,
      )).toList(),
      data: map,
    );
  }
}

class TreemapRect {
  final TreemapNode node;
  final Rect rect;
  final int depth;
  final Color color;

  const TreemapRect({
    required this.node,
    required this.rect,
    required this.depth,
    required this.color,
  });
}
