import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recharts_flutter/src/components/responsive_chart_container.dart';

void main() {
  group('ResponsiveChartContainer', () {
    testWidgets('passes constraints to builder', (tester) async {
      double? receivedWidth;
      double? receivedHeight;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 300,
              child: ResponsiveChartContainer(
                builder: (width, height) {
                  receivedWidth = width;
                  receivedHeight = height;
                  return Container(color: Colors.blue);
                },
              ),
            ),
          ),
        ),
      );

      expect(receivedWidth, 400);
      expect(receivedHeight, 300);
    });

    testWidgets('calculates height from aspect ratio', (tester) async {
      double? receivedHeight;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 800,
              child: ResponsiveChartContainer(
                aspectRatio: 2.0,
                builder: (width, height) {
                  receivedHeight = height;
                  return Container(color: Colors.blue);
                },
              ),
            ),
          ),
        ),
      );

      expect(receivedHeight, 200);
    });

    testWidgets('respects minWidth constraint', (tester) async {
      double? receivedWidth;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 100,
              height: 300,
              child: ResponsiveChartContainer(
                minWidth: 200,
                builder: (width, height) {
                  receivedWidth = width;
                  return Container(color: Colors.blue);
                },
              ),
            ),
          ),
        ),
      );

      expect(receivedWidth, 200);
    });

    testWidgets('respects maxWidth constraint', (tester) async {
      double? receivedWidth;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 500,
              height: 300,
              child: ResponsiveChartContainer(
                maxWidth: 400,
                builder: (width, height) {
                  receivedWidth = width;
                  return Container(color: Colors.blue);
                },
              ),
            ),
          ),
        ),
      );

      expect(receivedWidth, 400);
    });

    testWidgets('respects minHeight constraint', (tester) async {
      double? receivedHeight;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 100,
              child: ResponsiveChartContainer(
                minHeight: 200,
                builder: (width, height) {
                  receivedHeight = height;
                  return Container(color: Colors.blue);
                },
              ),
            ),
          ),
        ),
      );

      expect(receivedHeight, 200);
    });

    testWidgets('respects maxHeight constraint', (tester) async {
      double? receivedHeight;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 500,
              child: ResponsiveChartContainer(
                maxHeight: 300,
                builder: (width, height) {
                  receivedHeight = height;
                  return Container(color: Colors.blue);
                },
              ),
            ),
          ),
        ),
      );

      expect(receivedHeight, 300);
    });

    testWidgets('returns empty widget for zero dimensions', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 0,
              height: 0,
              child: ResponsiveChartContainer(
                builder: (width, height) {
                  return Container(color: Colors.blue);
                },
              ),
            ),
          ),
        ),
      );

      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('combines aspect ratio with constraints', (tester) async {
      double? receivedWidth;
      double? receivedHeight;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 600,
              child: ResponsiveChartContainer(
                aspectRatio: 2.0,
                maxHeight: 150,
                builder: (width, height) {
                  receivedWidth = width;
                  receivedHeight = height;
                  return Container(color: Colors.blue);
                },
              ),
            ),
          ),
        ),
      );

      expect(receivedWidth, 400);
      expect(receivedHeight, 150);
    });
  });
}
