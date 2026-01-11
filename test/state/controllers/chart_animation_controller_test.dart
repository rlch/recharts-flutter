import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recharts_flutter/src/state/controllers/chart_animation_controller.dart';
import 'package:recharts_flutter/src/core/animation/easing_curves.dart';

void main() {
  group('ChartAnimationController', () {
    testWidgets('creates with default values', (tester) async {
      ChartAnimationController? controller;

      await tester.pumpWidget(
        MaterialApp(
          home: _TestWidget(
            onInit: (vsync) {
              controller = ChartAnimationController(vsync: vsync);
            },
            onDispose: (c) => c?.dispose(),
          ),
        ),
      );

      expect(controller!.progress, equals(0.0));
      expect(controller!.isAnimating, isFalse);
      expect(controller!.duration, equals(const Duration(milliseconds: 300)));
      expect(controller!.curve, equals(ease));
    });

    testWidgets('animates and calls onProgress', (tester) async {
      ChartAnimationController? controller;
      final progressValues = <double>[];

      await tester.pumpWidget(
        MaterialApp(
          home: _TestWidget(
            onInit: (vsync) {
              controller = ChartAnimationController(
                vsync: vsync,
                duration: const Duration(milliseconds: 100),
                onProgress: (value) => progressValues.add(value),
              );
            },
            onDispose: (c) => c?.dispose(),
          ),
        ),
      );

      controller!.animate();
      expect(controller!.isAnimating, isTrue);

      await tester.pump(const Duration(milliseconds: 50));
      expect(progressValues, isNotEmpty);

      await tester.pumpAndSettle();
      expect(progressValues.last, closeTo(1.0, 0.01));
    });

    testWidgets('calls onComplete when animation finishes', (tester) async {
      ChartAnimationController? controller;
      bool completed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: _TestWidget(
            onInit: (vsync) {
              controller = ChartAnimationController(
                vsync: vsync,
                duration: const Duration(milliseconds: 100),
                onComplete: () => completed = true,
              );
            },
            onDispose: (c) => c?.dispose(),
          ),
        ),
      );

      controller!.animate();
      expect(completed, isFalse);

      await tester.pumpAndSettle();
      expect(completed, isTrue);
    });

    testWidgets('reset sets progress to 0', (tester) async {
      ChartAnimationController? controller;

      await tester.pumpWidget(
        MaterialApp(
          home: _TestWidget(
            onInit: (vsync) {
              controller = ChartAnimationController(
                vsync: vsync,
                duration: const Duration(milliseconds: 200),
              );
            },
            onDispose: (c) => c?.dispose(),
          ),
        ),
      );

      controller!.animate();
      await tester.pump(const Duration(milliseconds: 100));

      controller!.reset();
      expect(controller!.progress, equals(0.0));
      expect(controller!.isAnimating, isFalse);
    });

    testWidgets('duration can be changed', (tester) async {
      ChartAnimationController? controller;

      await tester.pumpWidget(
        MaterialApp(
          home: _TestWidget(
            onInit: (vsync) {
              controller = ChartAnimationController(
                vsync: vsync,
                duration: const Duration(milliseconds: 100),
              );
            },
            onDispose: (c) => c?.dispose(),
          ),
        ),
      );

      controller!.duration = const Duration(milliseconds: 500);
      expect(controller!.duration, equals(const Duration(milliseconds: 500)));
    });

    testWidgets('curve can be changed', (tester) async {
      ChartAnimationController? controller;

      await tester.pumpWidget(
        MaterialApp(
          home: _TestWidget(
            onInit: (vsync) {
              controller = ChartAnimationController(
                vsync: vsync,
                curve: Curves.linear,
              );
            },
            onDispose: (c) => c?.dispose(),
          ),
        ),
      );

      expect(controller!.curve, equals(Curves.linear));

      controller!.curve = Curves.easeInOut;
      expect(controller!.curve, equals(Curves.easeInOut));
    });
  });
}

class _TestWidget extends StatefulWidget {
  final void Function(TickerProvider) onInit;
  final void Function(ChartAnimationController?) onDispose;

  const _TestWidget({required this.onInit, required this.onDispose});

  @override
  State<_TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<_TestWidget>
    with SingleTickerProviderStateMixin {
  ChartAnimationController? _controller;

  @override
  void initState() {
    super.initState();
    widget.onInit(this);
  }

  @override
  void dispose() {
    widget.onDispose(_controller);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
