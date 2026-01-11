import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:recharts_flutter/src/treemap/treemap_node.dart';
import 'package:recharts_flutter/src/treemap/squarified_layout.dart';

void main() {
  group('TreemapNode', () {
    test('creates leaf node with value', () {
      const node = TreemapNode(name: 'A', value: 100);

      expect(node.name, 'A');
      expect(node.value, 100);
      expect(node.computedValue, 100);
      expect(node.isLeaf, true);
    });

    test('creates parent node with children', () {
      const node = TreemapNode(
        name: 'Root',
        children: [
          TreemapNode(name: 'A', value: 50),
          TreemapNode(name: 'B', value: 30),
          TreemapNode(name: 'C', value: 20),
        ],
      );

      expect(node.isLeaf, false);
      expect(node.computedValue, 100);
    });

    test('fromMap parses data correctly', () {
      final node = TreemapNode.fromMap({
        'name': 'Test',
        'value': 42,
      });

      expect(node.name, 'Test');
      expect(node.value, 42);
    });

    test('fromMap handles nested children', () {
      final node = TreemapNode.fromMap({
        'name': 'Root',
        'children': [
          {'name': 'A', 'value': 50},
          {'name': 'B', 'value': 30},
        ],
      });

      expect(node.children, hasLength(2));
      expect(node.computedValue, 80);
    });
  });

  group('SquarifiedLayout', () {
    test('computes layout for leaf node', () {
      const node = TreemapNode(name: 'A', value: 100);
      const bounds = Rect.fromLTWH(0, 0, 100, 100);
      final colors = [const Color(0xFF8884d8)];

      final rects = SquarifiedLayout.compute(
        root: node,
        bounds: bounds,
        colors: colors,
      );

      expect(rects, hasLength(1));
      expect(rects[0].rect, bounds);
    });

    test('computes layout for multiple children', () {
      const node = TreemapNode(
        name: 'Root',
        children: [
          TreemapNode(name: 'A', value: 50),
          TreemapNode(name: 'B', value: 30),
          TreemapNode(name: 'C', value: 20),
        ],
      );
      const bounds = Rect.fromLTWH(0, 0, 100, 100);
      final colors = [
        const Color(0xFF8884d8),
        const Color(0xFF82ca9d),
        const Color(0xFFffc658),
      ];

      final rects = SquarifiedLayout.compute(
        root: node,
        bounds: bounds,
        colors: colors,
      );

      expect(rects, hasLength(3));

      final totalArea = rects.fold<double>(
        0,
        (sum, r) => sum + r.rect.width * r.rect.height,
      );
      expect(totalArea, closeTo(10000, 1));
    });

    test('larger values get larger areas', () {
      const node = TreemapNode(
        name: 'Root',
        children: [
          TreemapNode(name: 'Large', value: 80),
          TreemapNode(name: 'Small', value: 20),
        ],
      );
      const bounds = Rect.fromLTWH(0, 0, 100, 100);
      final colors = [const Color(0xFF8884d8), const Color(0xFF82ca9d)];

      final rects = SquarifiedLayout.compute(
        root: node,
        bounds: bounds,
        colors: colors,
      );

      final largeRect = rects.firstWhere((r) => r.node.name == 'Large');
      final smallRect = rects.firstWhere((r) => r.node.name == 'Small');

      final largeArea = largeRect.rect.width * largeRect.rect.height;
      final smallArea = smallRect.rect.width * smallRect.rect.height;

      expect(largeArea, greaterThan(smallArea));
      expect(largeArea / smallArea, closeTo(4, 0.5));
    });

    test('handles nested hierarchy', () {
      const node = TreemapNode(
        name: 'Root',
        children: [
          TreemapNode(
            name: 'Group1',
            children: [
              TreemapNode(name: 'A', value: 30),
              TreemapNode(name: 'B', value: 20),
            ],
          ),
          TreemapNode(name: 'C', value: 50),
        ],
      );
      const bounds = Rect.fromLTWH(0, 0, 100, 100);
      final colors = [
        const Color(0xFF8884d8),
        const Color(0xFF82ca9d),
        const Color(0xFFffc658),
      ];

      final rects = SquarifiedLayout.compute(
        root: node,
        bounds: bounds,
        colors: colors,
      );

      expect(rects.length, greaterThanOrEqualTo(3));
    });

    test('squarified layout minimizes aspect ratios', () {
      const node = TreemapNode(
        name: 'Root',
        children: [
          TreemapNode(name: 'A', value: 6),
          TreemapNode(name: 'B', value: 6),
          TreemapNode(name: 'C', value: 4),
          TreemapNode(name: 'D', value: 3),
          TreemapNode(name: 'E', value: 2),
          TreemapNode(name: 'F', value: 2),
          TreemapNode(name: 'G', value: 1),
        ],
      );
      const bounds = Rect.fromLTWH(0, 0, 100, 100);
      final colors = [
        const Color(0xFF8884d8),
        const Color(0xFF82ca9d),
        const Color(0xFFffc658),
        const Color(0xFFff8042),
        const Color(0xFF8dd1e1),
        const Color(0xFFa4de6c),
        const Color(0xFFd0ed57),
      ];

      final rects = SquarifiedLayout.compute(
        root: node,
        bounds: bounds,
        colors: colors,
      );

      for (final rect in rects) {
        final aspectRatio = rect.rect.width / rect.rect.height;
        expect(aspectRatio, greaterThan(0.2));
        expect(aspectRatio, lessThan(5));
      }
    });
  });
}
