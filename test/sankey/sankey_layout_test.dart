import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:recharts_flutter/src/sankey/sankey_data.dart';
import 'package:recharts_flutter/src/sankey/sankey_layout.dart';

void main() {
  group('SankeyNode', () {
    test('creates with required parameters', () {
      const node = SankeyNode(id: 'a', name: 'Node A');

      expect(node.id, 'a');
      expect(node.name, 'Node A');
    });

    test('fromMap parses correctly', () {
      final node = SankeyNode.fromMap({
        'id': 'test',
        'name': 'Test Node',
      });

      expect(node.id, 'test');
      expect(node.name, 'Test Node');
    });
  });

  group('SankeyLink', () {
    test('creates with required parameters', () {
      const link = SankeyLink(
        source: 'a',
        target: 'b',
        value: 100,
      );

      expect(link.source, 'a');
      expect(link.target, 'b');
      expect(link.value, 100);
    });

    test('fromMap parses correctly', () {
      final link = SankeyLink.fromMap({
        'source': 'a',
        'target': 'b',
        'value': 50,
      });

      expect(link.source, 'a');
      expect(link.target, 'b');
      expect(link.value, 50);
    });
  });

  group('SankeyData', () {
    test('creates from nodes and links', () {
      const data = SankeyData(
        nodes: [
          SankeyNode(id: 'a', name: 'A'),
          SankeyNode(id: 'b', name: 'B'),
        ],
        links: [
          SankeyLink(source: 'a', target: 'b', value: 100),
        ],
      );

      expect(data.nodes, hasLength(2));
      expect(data.links, hasLength(1));
    });

    test('fromMap parses correctly', () {
      final data = SankeyData.fromMap({
        'nodes': [
          {'id': 'a', 'name': 'A'},
          {'id': 'b', 'name': 'B'},
        ],
        'links': [
          {'source': 'a', 'target': 'b', 'value': 100},
        ],
      });

      expect(data.nodes, hasLength(2));
      expect(data.links, hasLength(1));
    });
  });

  group('SankeyLayout', () {
    test('computes layout for simple two-node graph', () {
      const data = SankeyData(
        nodes: [
          SankeyNode(id: 'a', name: 'A'),
          SankeyNode(id: 'b', name: 'B'),
        ],
        links: [
          SankeyLink(source: 'a', target: 'b', value: 100),
        ],
      );
      const bounds = Rect.fromLTWH(0, 0, 200, 100);
      final colors = [const Color(0xFF8884d8), const Color(0xFF82ca9d)];

      const layout = SankeyLayout();
      final result = layout.compute(
        data: data,
        bounds: bounds,
        colors: colors,
      );

      expect(result.nodes, hasLength(2));
      expect(result.links, hasLength(1));

      final nodeA = result.nodes.firstWhere((n) => n.node.id == 'a');
      final nodeB = result.nodes.firstWhere((n) => n.node.id == 'b');

      expect(nodeA.layer, 0);
      expect(nodeB.layer, 1);
      expect(nodeA.x, lessThan(nodeB.x));
    });

    test('assigns correct layers in chain', () {
      const data = SankeyData(
        nodes: [
          SankeyNode(id: 'a', name: 'A'),
          SankeyNode(id: 'b', name: 'B'),
          SankeyNode(id: 'c', name: 'C'),
        ],
        links: [
          SankeyLink(source: 'a', target: 'b', value: 100),
          SankeyLink(source: 'b', target: 'c', value: 100),
        ],
      );
      const bounds = Rect.fromLTWH(0, 0, 300, 100);
      final colors = [
        const Color(0xFF8884d8),
        const Color(0xFF82ca9d),
        const Color(0xFFffc658),
      ];

      const layout = SankeyLayout();
      final result = layout.compute(
        data: data,
        bounds: bounds,
        colors: colors,
      );

      final nodeA = result.nodes.firstWhere((n) => n.node.id == 'a');
      final nodeB = result.nodes.firstWhere((n) => n.node.id == 'b');
      final nodeC = result.nodes.firstWhere((n) => n.node.id == 'c');

      expect(nodeA.layer, 0);
      expect(nodeB.layer, 1);
      expect(nodeC.layer, 2);
    });

    test('handles branching correctly', () {
      const data = SankeyData(
        nodes: [
          SankeyNode(id: 'source', name: 'Source'),
          SankeyNode(id: 'a', name: 'A'),
          SankeyNode(id: 'b', name: 'B'),
        ],
        links: [
          SankeyLink(source: 'source', target: 'a', value: 60),
          SankeyLink(source: 'source', target: 'b', value: 40),
        ],
      );
      const bounds = Rect.fromLTWH(0, 0, 200, 100);
      final colors = [
        const Color(0xFF8884d8),
        const Color(0xFF82ca9d),
        const Color(0xFFffc658),
      ];

      const layout = SankeyLayout();
      final result = layout.compute(
        data: data,
        bounds: bounds,
        colors: colors,
      );

      final source = result.nodes.firstWhere((n) => n.node.id == 'source');
      final nodeA = result.nodes.firstWhere((n) => n.node.id == 'a');
      final nodeB = result.nodes.firstWhere((n) => n.node.id == 'b');

      expect(source.layer, 0);
      expect(nodeA.layer, 1);
      expect(nodeB.layer, 1);

      expect(nodeA.height, greaterThan(nodeB.height));
    });

    test('link thickness proportional to value', () {
      const data = SankeyData(
        nodes: [
          SankeyNode(id: 'a', name: 'A'),
          SankeyNode(id: 'b', name: 'B'),
          SankeyNode(id: 'c', name: 'C'),
        ],
        links: [
          SankeyLink(source: 'a', target: 'b', value: 80),
          SankeyLink(source: 'a', target: 'c', value: 20),
        ],
      );
      const bounds = Rect.fromLTWH(0, 0, 200, 100);
      final colors = [
        const Color(0xFF8884d8),
        const Color(0xFF82ca9d),
        const Color(0xFFffc658),
      ];

      const layout = SankeyLayout();
      final result = layout.compute(
        data: data,
        bounds: bounds,
        colors: colors,
      );

      final linkAB = result.links.firstWhere(
        (l) => l.link.source == 'a' && l.link.target == 'b',
      );
      final linkAC = result.links.firstWhere(
        (l) => l.link.source == 'a' && l.link.target == 'c',
      );

      expect(linkAB.thickness, greaterThan(linkAC.thickness));
      expect(linkAB.thickness / linkAC.thickness, closeTo(4, 0.5));
    });

    test('handles empty data', () {
      const data = SankeyData(nodes: [], links: []);
      const bounds = Rect.fromLTWH(0, 0, 200, 100);
      final colors = [const Color(0xFF8884d8)];

      const layout = SankeyLayout();
      final result = layout.compute(
        data: data,
        bounds: bounds,
        colors: colors,
      );

      expect(result.nodes, isEmpty);
      expect(result.links, isEmpty);
    });
  });
}
