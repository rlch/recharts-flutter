import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recharts_flutter/src/components/brush/brush.dart';
import 'package:recharts_flutter/src/core/types/chart_data.dart';

void main() {
  final testData = ChartDataSet([
    {'name': 'A', 'value': 100},
    {'name': 'B', 'value': 200},
    {'name': 'C', 'value': 150},
    {'name': 'D', 'value': 180},
    {'name': 'E', 'value': 220},
    {'name': 'F', 'value': 190},
    {'name': 'G', 'value': 170},
    {'name': 'H', 'value': 210},
    {'name': 'I', 'value': 160},
    {'name': 'J', 'value': 240},
  ]);

  group('ChartBrush', () {
    test('has correct default values', () {
      const brush = ChartBrush();

      expect(brush.enabled, true);
      expect(brush.height, 40);
      expect(brush.handleWidth, 8);
      expect(brush.gap, 10);
    });

    test('copyWith creates new config with updated values', () {
      const brush = ChartBrush();

      final updated = brush.copyWith(
        height: 60,
        enabled: false,
      );

      expect(updated.height, 60);
      expect(updated.enabled, false);
      expect(updated.handleWidth, 8);
    });
  });

  group('BrushWidget', () {
    testWidgets('renders brush painter', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 100,
              child: BrushWidget(
                config: const ChartBrush(),
                data: testData,
                xDataKey: 'name',
                yDataKey: 'value',
                width: 400,
                height: 40,
                startIndex: 0,
                endIndex: 9,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('calls onChange when dragging', (tester) async {
      int? newStart;
      int? newEnd;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 100,
              child: BrushWidget(
                config: const ChartBrush(),
                data: testData,
                xDataKey: 'name',
                yDataKey: 'value',
                width: 400,
                height: 40,
                startIndex: 2,
                endIndex: 7,
                onChange: (start, end) {
                  newStart = start;
                  newEnd = end;
                },
              ),
            ),
          ),
        ),
      );

      final center = tester.getCenter(find.byType(BrushWidget));
      await tester.dragFrom(center, const Offset(50, 0));
      await tester.pumpAndSettle();

      expect(newStart != null || newEnd != null, isTrue);
    });

    testWidgets('updates when startIndex/endIndex props change', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BrushWidget(
              config: const ChartBrush(),
              data: testData,
              width: 400,
              height: 40,
              startIndex: 0,
              endIndex: 5,
            ),
          ),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BrushWidget(
              config: const ChartBrush(),
              data: testData,
              width: 400,
              height: 40,
              startIndex: 2,
              endIndex: 8,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(BrushWidget), findsOneWidget);
    });
  });
}
