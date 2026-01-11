import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recharts_flutter/recharts_flutter.dart';

void main() {
  group('ChartWidget', () {
    testWidgets('renders with specified dimensions', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ChartWidget(
            width: 400,
            height: 300,
          ),
        ),
      );

      final sizeFinder = find.byType(SizedBox);
      expect(sizeFinder, findsOneWidget);

      final sizedBox = tester.widget<SizedBox>(sizeFinder);
      expect(sizedBox.width, 400);
      expect(sizedBox.height, 300);
    });

    testWidgets('renders with background color', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ChartWidget(
            width: 400,
            height: 300,
            backgroundColor: Colors.white,
          ),
        ),
      );

      final containerFinder = find.byType(Container);
      expect(containerFinder, findsWidgets);
    });

    testWidgets('renders children in stack', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChartWidget(
            width: 400,
            height: 300,
            children: [
              Container(key: const Key('child1')),
              Container(key: const Key('child2')),
            ],
          ),
        ),
      );

      expect(find.byKey(const Key('child1')), findsOneWidget);
      expect(find.byKey(const Key('child2')), findsOneWidget);
    });
  });
}
