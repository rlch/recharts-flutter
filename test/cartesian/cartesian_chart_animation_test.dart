import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recharts_flutter/recharts_flutter.dart';

void main() {
  group('CartesianChartWidget animations', () {
    final testData = [
      {'name': 'A', 'value': 100},
      {'name': 'B', 'value': 200},
      {'name': 'C', 'value': 150},
    ];

    testWidgets('renders chart with default animation settings', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 300,
              child: CartesianChartWidget(
                data: testData,
                lineSeries: [
                  LineSeries(dataKey: 'value'),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('renders chart with animations disabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 300,
              child: CartesianChartWidget(
                data: testData,
                isAnimationActive: false,
                lineSeries: [
                  LineSeries(dataKey: 'value'),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('triggers animation on data change', (tester) async {
      bool animationStarted = false;
      bool animationEnded = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: _AnimatedChartTestWidget(
              initialData: testData,
              onAnimationStart: () => animationStarted = true,
              onAnimationEnd: () => animationEnded = true,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      animationStarted = false;
      animationEnded = false;

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(animationStarted, isTrue);

      await tester.pumpAndSettle();
      expect(animationEnded, isTrue);
    });

    testWidgets('respects custom animation duration', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 300,
              child: CartesianChartWidget(
                data: testData,
                animationDuration: const Duration(milliseconds: 500),
                lineSeries: [
                  LineSeries(dataKey: 'value'),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('respects custom easing curve', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 300,
              child: CartesianChartWidget(
                data: testData,
                animationEasing: easeBounce,
                lineSeries: [
                  LineSeries(dataKey: 'value'),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('animates bar series', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 300,
              child: CartesianChartWidget(
                data: testData,
                barSeries: [
                  BarSeries(dataKey: 'value', fill: Colors.blue),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();

      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('animates area series', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 300,
              child: CartesianChartWidget(
                data: testData,
                areaSeries: [
                  AreaSeries(dataKey: 'value'),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();

      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('handles empty data gracefully', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 300,
              child: CartesianChartWidget(
                data: const [],
                lineSeries: [
                  LineSeries(dataKey: 'value'),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('handles data with more points', (tester) async {
      final shortData = [
        {'name': 'A', 'value': 100},
        {'name': 'B', 'value': 200},
      ];

      final longData = [
        {'name': 'A', 'value': 100},
        {'name': 'B', 'value': 200},
        {'name': 'C', 'value': 150},
        {'name': 'D', 'value': 180},
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: _DataChangeWidget(
              initialData: shortData,
              updatedData: longData,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('handles data with fewer points', (tester) async {
      final longData = [
        {'name': 'A', 'value': 100},
        {'name': 'B', 'value': 200},
        {'name': 'C', 'value': 150},
        {'name': 'D', 'value': 180},
      ];

      final shortData = [
        {'name': 'A', 'value': 100},
        {'name': 'B', 'value': 200},
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: _DataChangeWidget(
              initialData: longData,
              updatedData: shortData,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byType(CustomPaint), findsWidgets);
    });
  });
}

class _AnimatedChartTestWidget extends StatefulWidget {
  final List<Map<String, dynamic>> initialData;
  final VoidCallback? onAnimationStart;
  final VoidCallback? onAnimationEnd;

  const _AnimatedChartTestWidget({
    required this.initialData,
    this.onAnimationStart,
    this.onAnimationEnd,
  });

  @override
  State<_AnimatedChartTestWidget> createState() =>
      _AnimatedChartTestWidgetState();
}

class _AnimatedChartTestWidgetState extends State<_AnimatedChartTestWidget> {
  late List<Map<String, dynamic>> _data;

  @override
  void initState() {
    super.initState();
    _data = widget.initialData;
  }

  void _updateData() {
    setState(() {
      _data = _data.map((item) {
        return {
          ...item,
          'value': (item['value'] as int) + 50,
        };
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CartesianChartWidget(
            data: _data,
            animationDuration: const Duration(milliseconds: 100),
            onAnimationStart: widget.onAnimationStart,
            onAnimationEnd: widget.onAnimationEnd,
            lineSeries: [
              LineSeries(dataKey: 'value'),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: _updateData,
          child: const Text('Update'),
        ),
      ],
    );
  }
}

class _DataChangeWidget extends StatefulWidget {
  final List<Map<String, dynamic>> initialData;
  final List<Map<String, dynamic>> updatedData;

  const _DataChangeWidget({
    required this.initialData,
    required this.updatedData,
  });

  @override
  State<_DataChangeWidget> createState() => _DataChangeWidgetState();
}

class _DataChangeWidgetState extends State<_DataChangeWidget> {
  late List<Map<String, dynamic>> _data;

  @override
  void initState() {
    super.initState();
    _data = widget.initialData;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CartesianChartWidget(
            data: _data,
            animationDuration: const Duration(milliseconds: 100),
            lineSeries: [
              LineSeries(dataKey: 'value'),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _data = widget.updatedData;
            });
          },
          child: const Text('Update'),
        ),
      ],
    );
  }
}
