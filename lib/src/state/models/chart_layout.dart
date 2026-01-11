import 'dart:ui';

class ChartLayout {
  final double width;
  final double height;
  final ChartMargin margin;
  final Rect plotArea;

  const ChartLayout({
    required this.width,
    required this.height,
    required this.margin,
    required this.plotArea,
  });

  factory ChartLayout.compute({
    required double width,
    required double height,
    ChartMargin? margin,
  }) {
    final m = margin ?? const ChartMargin();
    final plotArea = Rect.fromLTWH(
      m.left,
      m.top,
      width - m.left - m.right,
      height - m.top - m.bottom,
    );
    return ChartLayout(
      width: width,
      height: height,
      margin: m,
      plotArea: plotArea,
    );
  }

  double get plotWidth => plotArea.width;
  double get plotHeight => plotArea.height;
  double get plotLeft => plotArea.left;
  double get plotTop => plotArea.top;
  double get plotRight => plotArea.right;
  double get plotBottom => plotArea.bottom;
}

class ChartMargin {
  final double top;
  final double right;
  final double bottom;
  final double left;

  const ChartMargin({
    this.top = 5,
    this.right = 5,
    this.bottom = 30,
    this.left = 60,
  });

  const ChartMargin.all(double value)
      : top = value,
        right = value,
        bottom = value,
        left = value;

  const ChartMargin.symmetric({double horizontal = 0, double vertical = 0})
      : left = horizontal,
        right = horizontal,
        top = vertical,
        bottom = vertical;

  ChartMargin copyWith({
    double? top,
    double? right,
    double? bottom,
    double? left,
  }) {
    return ChartMargin(
      top: top ?? this.top,
      right: right ?? this.right,
      bottom: bottom ?? this.bottom,
      left: left ?? this.left,
    );
  }
}
