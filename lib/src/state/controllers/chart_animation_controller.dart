import 'package:flutter/animation.dart';

import '../../core/animation/easing_curves.dart';

typedef AnimationProgressCallback = void Function(double progress);
typedef AnimationCompleteCallback = void Function();

class ChartAnimationController {
  ChartAnimationController({
    required TickerProvider vsync,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = ease,
    AnimationProgressCallback? onProgress,
    AnimationCompleteCallback? onComplete,
  })  : _duration = duration,
        _curve = curve,
        _onProgress = onProgress,
        _onComplete = onComplete {
    _controller = AnimationController(
      vsync: vsync,
      duration: duration,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: curve,
    );
    _controller.addListener(_handleAnimationUpdate);
    _controller.addStatusListener(_handleAnimationStatus);
  }

  late final AnimationController _controller;
  late CurvedAnimation _animation;
  Duration _duration;
  Curve _curve;
  AnimationProgressCallback? _onProgress;
  AnimationCompleteCallback? _onComplete;

  double get progress => _animation.value;
  bool get isAnimating => _controller.isAnimating;
  AnimationStatus get status => _controller.status;

  Duration get duration => _duration;
  set duration(Duration value) {
    _duration = value;
    _controller.duration = value;
  }

  Curve get curve => _curve;
  set curve(Curve value) {
    _curve = value;
    _animation.dispose();
    _animation = CurvedAnimation(
      parent: _controller,
      curve: value,
    );
  }

  set onProgress(AnimationProgressCallback? callback) {
    _onProgress = callback;
  }

  set onComplete(AnimationCompleteCallback? callback) {
    _onComplete = callback;
  }

  void _handleAnimationUpdate() {
    _onProgress?.call(_animation.value);
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _onComplete?.call();
    }
  }

  void animate({bool fromStart = true}) {
    if (fromStart) {
      _controller.forward(from: 0);
    } else {
      _controller.forward();
    }
  }

  void reset() {
    _controller.reset();
  }

  void stop() {
    _controller.stop();
  }

  void dispose() {
    _controller.removeListener(_handleAnimationUpdate);
    _controller.removeStatusListener(_handleAnimationStatus);
    _animation.dispose();
    _controller.dispose();
  }
}
