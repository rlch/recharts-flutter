import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:recharts_flutter/src/components/tooltip/tooltip.dart';

void main() {
  group('ChartTooltip', () {
    test('has correct defaults', () {
      const tooltip = ChartTooltip();

      expect(tooltip.enabled, true);
      expect(tooltip.trigger, TooltipTrigger.hover);
      expect(tooltip.backgroundColor, const Color(0xFFFFFFFF));
      expect(tooltip.borderRadius, 4);
      expect(tooltip.followCursor, true);
      expect(tooltip.showLabel, true);
      expect(tooltip.showSeriesName, true);
    });

    test('copyWith preserves existing values', () {
      const tooltip = ChartTooltip(
        enabled: false,
        trigger: TooltipTrigger.click,
      );

      final updated = tooltip.copyWith(
        backgroundColor: Colors.black,
      );

      expect(updated.enabled, false);
      expect(updated.trigger, TooltipTrigger.click);
      expect(updated.backgroundColor, Colors.black);
    });
  });

  group('TooltipOverlay', () {
    testWidgets('renders nothing when payload is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 300,
              child: TooltipOverlay(
                payload: null,
                config: ChartTooltip(),
                chartSize: Size(400, 300),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('renders nothing when payload is empty', (tester) async {
      const emptyPayload = TooltipPayload(
        index: 0,
        label: 'Test',
        entries: [],
        coordinate: Offset(100, 100),
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 300,
              child: TooltipOverlay(
                payload: emptyPayload,
                config: ChartTooltip(),
                chartSize: Size(400, 300),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('renders tooltip content when payload is valid', (tester) async {
      const payload = TooltipPayload(
        index: 0,
        label: 'January',
        entries: [
          TooltipEntry(name: 'Value', value: 100, color: Color(0xFF8884d8)),
        ],
        coordinate: Offset(100, 100),
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 300,
              child: TooltipOverlay(
                payload: payload,
                config: ChartTooltip(),
                chartSize: Size(400, 300),
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('January'), findsOneWidget);
      expect(find.text('Value'), findsOneWidget);
      expect(find.text('100'), findsOneWidget);
    });

    testWidgets('uses custom content builder', (tester) async {
      const payload = TooltipPayload(
        index: 0,
        label: 'Test',
        entries: [
          TooltipEntry(name: 'Value', value: 100, color: Color(0xFF8884d8)),
        ],
        coordinate: Offset(100, 100),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 300,
              child: TooltipOverlay(
                payload: payload,
                config: ChartTooltip(
                  contentBuilder: (context, p) => Container(
                    key: const Key('custom-tooltip'),
                    child: Text('Custom: ${p.label}'),
                  ),
                ),
                chartSize: const Size(400, 300),
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.byKey(const Key('custom-tooltip')), findsOneWidget);
      expect(find.text('Custom: Test'), findsOneWidget);
    });
  });

  group('DefaultTooltipContent', () {
    testWidgets('renders label when showLabel is true', (tester) async {
      const payload = TooltipPayload(
        index: 0,
        label: 'Test Label',
        entries: [
          TooltipEntry(name: 'Value', value: 100, color: Color(0xFF8884d8)),
        ],
        coordinate: Offset.zero,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DefaultTooltipContent(
              payload: payload,
              config: ChartTooltip(showLabel: true),
            ),
          ),
        ),
      );

      expect(find.text('Test Label'), findsOneWidget);
    });

    testWidgets('hides label when showLabel is false', (tester) async {
      const payload = TooltipPayload(
        index: 0,
        label: 'Test Label',
        entries: [
          TooltipEntry(name: 'Value', value: 100, color: Color(0xFF8884d8)),
        ],
        coordinate: Offset.zero,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DefaultTooltipContent(
              payload: payload,
              config: ChartTooltip(showLabel: false),
            ),
          ),
        ),
      );

      expect(find.text('Test Label'), findsNothing);
    });

    testWidgets('renders all entries', (tester) async {
      const payload = TooltipPayload(
        index: 0,
        label: 'Test',
        entries: [
          TooltipEntry(name: 'Value1', value: 100, color: Color(0xFF8884d8)),
          TooltipEntry(name: 'Value2', value: 200, color: Color(0xFF82ca9d)),
        ],
        coordinate: Offset.zero,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DefaultTooltipContent(
              payload: payload,
              config: ChartTooltip(),
            ),
          ),
        ),
      );

      expect(find.text('Value1'), findsOneWidget);
      expect(find.text('Value2'), findsOneWidget);
      expect(find.text('100'), findsOneWidget);
      expect(find.text('200'), findsOneWidget);
    });

    testWidgets('applies custom separator', (tester) async {
      const payload = TooltipPayload(
        index: 0,
        label: 'Test',
        entries: [
          TooltipEntry(name: 'Value', value: 100, color: Color(0xFF8884d8)),
        ],
        coordinate: Offset.zero,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DefaultTooltipContent(
              payload: payload,
              config: ChartTooltip(separator: ' = '),
            ),
          ),
        ),
      );

      expect(find.text(' = '), findsOneWidget);
    });
  });
}
