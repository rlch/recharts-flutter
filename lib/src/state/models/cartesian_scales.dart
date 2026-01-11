import '../../core/scale/scale.dart';

class CartesianScales {
  final Scale<dynamic, double> xScale;
  final Scale<dynamic, double> yScale;
  final Map<String, Scale<dynamic, double>> xScales;
  final Map<String, Scale<dynamic, double>> yScales;

  const CartesianScales({
    required this.xScale,
    required this.yScale,
    Map<String, Scale<dynamic, double>>? xScales,
    Map<String, Scale<dynamic, double>>? yScales,
  })  : xScales = xScales ?? const {},
        yScales = yScales ?? const {};

  Scale<dynamic, double> getXScale([String? id]) {
    if (id != null && xScales.containsKey(id)) {
      return xScales[id]!;
    }
    return xScale;
  }

  Scale<dynamic, double> getYScale([String? id]) {
    if (id != null && yScales.containsKey(id)) {
      return yScales[id]!;
    }
    return yScale;
  }
}
