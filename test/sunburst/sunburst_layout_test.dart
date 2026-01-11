import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:recharts_flutter/src/sunburst/sunburst_node.dart';
import 'package:recharts_flutter/src/sunburst/sunburst_layout.dart';

void main() {
  group('SunburstNode', () {
    test('creates leaf node with value', () {
      const node = SunburstNode(name: 'A', value: 100);

      expect(node.name, 'A');
      expect(node.value, 100);
      expect(node.computedValue, 100);
      expect(node.isLeaf, true);
      expect(node.depth, 0);
    });

    test('creates parent node with children', () {
      const node = SunburstNode(
        name: 'Root',
        children: [
          SunburstNode(name: 'A', value: 50),
          SunburstNode(name: 'B', value: 30),
        ],
      );

      expect(node.isLeaf, false);
      expect(node.computedValue, 80);
      expect(node.depth, 1);
    });

    test('calculates depth for nested hierarchy', () {
      const node = SunburstNode(
        name: 'Root',
        children: [
          SunburstNode(
            name: 'Level1',
            children: [
              SunburstNode(
                name: 'Level2',
                children: [
                  SunburstNode(name: 'Leaf', value: 10),
                ],
              ),
            ],
          ),
        ],
      );

      expect(node.depth, 3);
    });

    test('fromMap parses data correctly', () {
      final node = SunburstNode.fromMap({
        'name': 'Test',
        'value': 42,
      });

      expect(node.name, 'Test');
      expect(node.value, 42);
    });
  });

  group('SunburstLayout', () {
    test('computes sectors for leaf node', () {
      const node = SunburstNode(name: 'A', value: 100);
      const center = Offset(100, 100);
      final colors = [const Color(0xFF8884d8)];

      final sectors = SunburstLayout.compute(
        root: node,
        center: center,
        innerRadius: 20,
        outerRadius: 80,
        colors: colors,
      );

      expect(sectors, hasLength(1));
      expect(sectors[0].sweepAngle, closeTo(2 * math.pi, 0.01));
    });

    test('computes sectors for parent with children', () {
      const node = SunburstNode(
        name: 'Root',
        children: [
          SunburstNode(name: 'A', value: 50),
          SunburstNode(name: 'B', value: 50),
        ],
      );
      const center = Offset(100, 100);
      final colors = [
        const Color(0xFF8884d8),
        const Color(0xFF82ca9d),
      ];

      final sectors = SunburstLayout.compute(
        root: node,
        center: center,
        innerRadius: 20,
        outerRadius: 80,
        colors: colors,
      );

      expect(sectors.length, 3);

      final childSectors = sectors.where((s) => s.depth == 1).toList();
      expect(childSectors.length, 2);

      for (final sector in childSectors) {
        expect(sector.sweepAngle, closeTo(math.pi, 0.01));
      }
    });

    test('ring width divides evenly by depth', () {
      const node = SunburstNode(
        name: 'Root',
        children: [
          SunburstNode(
            name: 'Level1',
            children: [
              SunburstNode(name: 'Leaf', value: 100),
            ],
          ),
        ],
      );
      const center = Offset(100, 100);
      final colors = [const Color(0xFF8884d8)];

      final sectors = SunburstLayout.compute(
        root: node,
        center: center,
        innerRadius: 0,
        outerRadius: 90,
        colors: colors,
      );

      final depths = sectors.map((s) => s.depth).toSet();
      expect(depths, containsAll([0, 1, 2]));

      final ringWidth = 90 / 3;
      for (final sector in sectors) {
        final expectedInner = sector.depth * ringWidth;
        final expectedOuter = (sector.depth + 1) * ringWidth;
        expect(sector.innerRadius, closeTo(expectedInner, 0.1));
        expect(sector.outerRadius, closeTo(expectedOuter, 0.1));
      }
    });

    test('children angles sum to parent angle', () {
      const node = SunburstNode(
        name: 'Root',
        children: [
          SunburstNode(name: 'A', value: 30),
          SunburstNode(name: 'B', value: 50),
          SunburstNode(name: 'C', value: 20),
        ],
      );
      const center = Offset(100, 100);
      final colors = [
        const Color(0xFF8884d8),
        const Color(0xFF82ca9d),
        const Color(0xFFffc658),
      ];

      final sectors = SunburstLayout.compute(
        root: node,
        center: center,
        innerRadius: 20,
        outerRadius: 80,
        colors: colors,
      );

      final rootSector = sectors.firstWhere((s) => s.depth == 0);
      final childSectors = sectors.where((s) => s.depth == 1).toList();

      final totalChildAngle = childSectors.fold<double>(
        0,
        (sum, s) => sum + s.sweepAngle,
      );

      expect(totalChildAngle, closeTo(rootSector.sweepAngle, 0.01));
    });
  });
}
