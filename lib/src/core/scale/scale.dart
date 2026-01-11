abstract class Scale<D, R> {
  List<D> get domain;
  set domain(List<D> value);

  List<R> get range;
  set range(List<R> value);

  double? get bandwidth;

  List<D> ticks([int? count]);

  R call(D value);

  D? invert(R value);
}
