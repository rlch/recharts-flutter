import 'dart:ui';

class SankeyNode {
  final String id;
  final String? name;
  final double? value;
  final Color? color;
  final Map<String, dynamic>? data;

  const SankeyNode({
    required this.id,
    this.name,
    this.value,
    this.color,
    this.data,
  });

  factory SankeyNode.fromMap(Map<String, dynamic> map, {
    String idKey = 'id',
    String nameKey = 'name',
  }) {
    return SankeyNode(
      id: map[idKey]?.toString() ?? '',
      name: map[nameKey]?.toString(),
      data: map,
    );
  }
}

class SankeyLink {
  final String source;
  final String target;
  final double value;
  final Color? color;
  final Map<String, dynamic>? data;

  const SankeyLink({
    required this.source,
    required this.target,
    required this.value,
    this.color,
    this.data,
  });

  factory SankeyLink.fromMap(Map<String, dynamic> map, {
    String sourceKey = 'source',
    String targetKey = 'target',
    String valueKey = 'value',
  }) {
    return SankeyLink(
      source: map[sourceKey]?.toString() ?? '',
      target: map[targetKey]?.toString() ?? '',
      value: (map[valueKey] as num?)?.toDouble() ?? 0,
      data: map,
    );
  }
}

class SankeyData {
  final List<SankeyNode> nodes;
  final List<SankeyLink> links;

  const SankeyData({
    required this.nodes,
    required this.links,
  });

  factory SankeyData.fromMap(Map<String, dynamic> map, {
    String nodesKey = 'nodes',
    String linksKey = 'links',
  }) {
    final nodesList = (map[nodesKey] as List?)
            ?.map((n) => SankeyNode.fromMap(n as Map<String, dynamic>))
            .toList() ??
        [];
    final linksList = (map[linksKey] as List?)
            ?.map((l) => SankeyLink.fromMap(l as Map<String, dynamic>))
            .toList() ??
        [];
    return SankeyData(nodes: nodesList, links: linksList);
  }
}

class SankeyNodeGeometry {
  final SankeyNode node;
  final double x;
  final double y;
  final double width;
  final double height;
  final double value;
  final int layer;
  final Color color;

  const SankeyNodeGeometry({
    required this.node,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.value,
    required this.layer,
    required this.color,
  });

  Rect get rect => Rect.fromLTWH(x, y, width, height);
  Offset get center => Offset(x + width / 2, y + height / 2);
  double get leftY => y + height / 2;
  double get rightY => y + height / 2;
}

class SankeyLinkGeometry {
  final SankeyLink link;
  final SankeyNodeGeometry sourceNode;
  final SankeyNodeGeometry targetNode;
  final double sourceY;
  final double targetY;
  final double thickness;
  final Color color;

  const SankeyLinkGeometry({
    required this.link,
    required this.sourceNode,
    required this.targetNode,
    required this.sourceY,
    required this.targetY,
    required this.thickness,
    required this.color,
  });
}
