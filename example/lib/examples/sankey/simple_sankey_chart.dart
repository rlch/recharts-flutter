import 'package:flutter/material.dart';
import 'package:recharts_flutter/recharts_flutter.dart';
import '../../data/coordinate_data.dart';

class SimpleSankeyChart extends StatelessWidget {
  const SimpleSankeyChart({super.key});

  @override
  Widget build(BuildContext context) {
    final nodeNames = (nodeLinkData['nodes'] as List).cast<Map<String, dynamic>>();
    final linkMaps = (nodeLinkData['links'] as List).cast<Map<String, dynamic>>();
    
    final nodes = nodeNames.asMap().entries.map((e) => 
      SankeyNode(id: e.key.toString(), name: e.value['name'] as String)
    ).toList();
    
    final links = linkMaps.map((l) => SankeyLink(
      source: (l['source'] as int).toString(),
      target: (l['target'] as int).toString(),
      value: (l['value'] as num).toDouble(),
    )).toList();

    return SankeyChart(
      data: SankeyData(nodes: nodes, links: links),
    );
  }

  static const String sourceCode = '''
final sankeyData = SankeyData(
  nodes: [
    SankeyNode(id: '0', name: 'Visit'),
    SankeyNode(id: '1', name: 'Direct-Favourite'),
    SankeyNode(id: '2', name: 'Page-Click'),
    SankeyNode(id: '3', name: 'Detail-Favourite'),
    SankeyNode(id: '4', name: 'Lost'),
  ],
  links: [
    SankeyLink(source: '0', target: '1', value: 3728.3),
    SankeyLink(source: '0', target: '2', value: 354170),
    SankeyLink(source: '2', target: '3', value: 291741),
    SankeyLink(source: '2', target: '4', value: 62429),
  ],
);

SankeyChart(data: sankeyData)''';
}
