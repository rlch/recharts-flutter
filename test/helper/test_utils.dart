import 'package:flutter/widgets.dart';

Widget testableWidget(Widget child) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: const MediaQueryData(),
      child: child,
    ),
  );
}

bool approximatelyEqual(double a, double b, {double epsilon = 1e-10}) {
  return (a - b).abs() < epsilon;
}
