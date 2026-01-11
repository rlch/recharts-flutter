import 'dart:ui';

Offset lerpOffset(Offset a, Offset b, double t) {
  return Offset.lerp(a, b, t)!;
}

List<Offset> interpolatePoints(List<Offset> from, List<Offset> to, double t) {
  if (from.isEmpty && to.isEmpty) return [];
  if (from.isEmpty) {
    final anchor = to.first;
    return to.map((p) => lerpOffset(anchor, p, t)).toList();
  }
  if (to.isEmpty) {
    final anchor = from.last;
    return from.map((p) => lerpOffset(p, anchor, t)).toList();
  }

  final maxLength = from.length > to.length ? from.length : to.length;
  final result = <Offset>[];

  for (int i = 0; i < maxLength; i++) {
    final fromPoint = i < from.length ? from[i] : from.last;
    final toPoint = i < to.length ? to[i] : to.last;
    result.add(lerpOffset(fromPoint, toPoint, t));
  }

  return result;
}

Rect lerpRect(Rect a, Rect b, double t) {
  return Rect.lerp(a, b, t)!;
}

List<Rect> interpolateRects(List<Rect> from, List<Rect> to, double t) {
  if (from.isEmpty && to.isEmpty) return [];

  if (from.isEmpty) {
    return to.map((rect) {
      final collapsed = Rect.fromLTWH(
        rect.left,
        rect.bottom,
        rect.width,
        0,
      );
      return lerpRect(collapsed, rect, t);
    }).toList();
  }

  if (to.isEmpty) {
    return from.map((rect) {
      final collapsed = Rect.fromLTWH(
        rect.left,
        rect.bottom,
        rect.width,
        0,
      );
      return lerpRect(rect, collapsed, t);
    }).toList();
  }

  final maxLength = from.length > to.length ? from.length : to.length;
  final result = <Rect>[];

  for (int i = 0; i < maxLength; i++) {
    final fromRect = i < from.length ? from[i] : _collapsedRect(from.last);
    final toRect = i < to.length ? to[i] : _collapsedRect(to.last);
    result.add(lerpRect(fromRect, toRect, t));
  }

  return result;
}

Rect _collapsedRect(Rect reference) {
  return Rect.fromLTWH(
    reference.left,
    reference.bottom,
    reference.width,
    0,
  );
}

class AnimatedAreaData {
  final List<Offset> topPoints;
  final List<Offset> bottomPoints;

  const AnimatedAreaData({
    required this.topPoints,
    required this.bottomPoints,
  });
}

AnimatedAreaData interpolateAreaPoints(
  AnimatedAreaData from,
  AnimatedAreaData to,
  double t,
) {
  return AnimatedAreaData(
    topPoints: interpolatePoints(from.topPoints, to.topPoints, t),
    bottomPoints: interpolatePoints(from.bottomPoints, to.bottomPoints, t),
  );
}
