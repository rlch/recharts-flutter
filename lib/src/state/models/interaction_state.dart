import 'dart:ui';

import '../../components/tooltip/tooltip_types.dart';

class ChartInteractionState {
  final bool isActive;
  final int? activeIndex;
  final Offset? activeCoordinate;
  final TooltipPayload? tooltipPayload;

  const ChartInteractionState({
    this.isActive = false,
    this.activeIndex,
    this.activeCoordinate,
    this.tooltipPayload,
  });

  ChartInteractionState copyWith({
    bool? isActive,
    int? activeIndex,
    Offset? activeCoordinate,
    TooltipPayload? tooltipPayload,
    bool clearIndex = false,
    bool clearCoordinate = false,
    bool clearPayload = false,
  }) {
    return ChartInteractionState(
      isActive: isActive ?? this.isActive,
      activeIndex: clearIndex ? null : (activeIndex ?? this.activeIndex),
      activeCoordinate:
          clearCoordinate ? null : (activeCoordinate ?? this.activeCoordinate),
      tooltipPayload:
          clearPayload ? null : (tooltipPayload ?? this.tooltipPayload),
    );
  }

  static const inactive = ChartInteractionState();
}
