import 'dart:ui';

import '../../components/tooltip/tooltip_types.dart';
import '../models/interaction_state.dart';
import '../controllers/chart_interaction_controller.dart';

class TooltipStateNotifier {
  ChartInteractionState _state = ChartInteractionState.inactive;

  ChartInteractionState get state => _state;

  bool get isActive => _state.isActive;
  int? get activeIndex => _state.activeIndex;
  Offset? get activeCoordinate => _state.activeCoordinate;
  TooltipPayload? get tooltipPayload => _state.tooltipPayload;

  final List<void Function(ChartInteractionState)> _listeners = [];

  void addListener(void Function(ChartInteractionState) listener) {
    _listeners.add(listener);
  }

  void removeListener(void Function(ChartInteractionState) listener) {
    _listeners.remove(listener);
  }

  void update(ChartInteractionState newState) {
    _state = newState;
    for (final listener in _listeners) {
      listener(_state);
    }
  }

  void reset() {
    update(ChartInteractionState.inactive);
  }
}

TooltipPayload? computeTooltipPayload({
  required ChartInteractionController controller,
  required int? activeIndex,
  required Offset? activeCoordinate,
}) {
  if (activeIndex == null || activeCoordinate == null) {
    return null;
  }

  return controller.buildTooltipPayload(activeIndex, activeCoordinate);
}

List<Offset?> computeActivePoints({
  required ChartInteractionController controller,
  required int? activeIndex,
}) {
  if (activeIndex == null) {
    return [];
  }

  return controller.seriesInfoList
      .map((info) => controller.getPointCoordinate(activeIndex, info.dataKey))
      .toList();
}
