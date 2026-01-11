import 'dart:ui';

import '../../core/scale/scale.dart';
import '../../core/types/chart_data.dart';
import '../../core/types/series_types.dart';
import '../../components/tooltip/tooltip_types.dart';
import '../models/chart_layout.dart';
import '../models/interaction_state.dart';

typedef InteractionStateCallback = void Function(ChartInteractionState state);

class SeriesInfo {
  final String dataKey;
  final String? name;
  final Color color;
  final String? unit;
  final LegendType legendType;

  const SeriesInfo({
    required this.dataKey,
    this.name,
    required this.color,
    this.unit,
    this.legendType = LegendType.square,
  });

  String get displayName => name ?? dataKey;
}

class ChartInteractionController {
  final ChartDataSet data;
  final ChartLayout layout;
  final Scale<dynamic, double> xScale;
  final Scale<dynamic, double> yScale;
  final String xDataKey;
  final List<SeriesInfo> seriesInfoList;
  final InteractionStateCallback onStateChanged;

  ChartInteractionController({
    required this.data,
    required this.layout,
    required this.xScale,
    required this.yScale,
    required this.xDataKey,
    required this.seriesInfoList,
    required this.onStateChanged,
  });

  ChartInteractionState _state = ChartInteractionState.inactive;
  ChartInteractionState get state => _state;

  void onPointerMove(Offset position) {
    if (!_isInPlotArea(position)) {
      onPointerExit();
      return;
    }

    final index = findNearestIndex(position);
    if (index == null || index < 0 || index >= data.length) {
      return;
    }

    final payload = buildTooltipPayload(index, position);
    _updateState(ChartInteractionState(
      isActive: true,
      activeIndex: index,
      activeCoordinate: position,
      tooltipPayload: payload,
    ));
  }

  void onPointerTap(Offset position) {
    if (!_isInPlotArea(position)) {
      return;
    }

    final index = findNearestIndex(position);
    if (index == null || index < 0 || index >= data.length) {
      return;
    }

    final payload = buildTooltipPayload(index, position);
    _updateState(ChartInteractionState(
      isActive: true,
      activeIndex: index,
      activeCoordinate: position,
      tooltipPayload: payload,
    ));
  }

  void onPointerExit() {
    _updateState(ChartInteractionState.inactive);
  }

  bool _isInPlotArea(Offset position) {
    return layout.plotArea.contains(position);
  }

  void _updateState(ChartInteractionState newState) {
    if (_state.isActive != newState.isActive ||
        _state.activeIndex != newState.activeIndex ||
        _state.activeCoordinate != newState.activeCoordinate) {
      _state = newState;
      onStateChanged(newState);
    }
  }

  int? findNearestIndex(Offset position) {
    final bandwidth = xScale.bandwidth;

    if (bandwidth != null && bandwidth > 0) {
      return _findBandIndex(position.dx);
    } else {
      return _findNearestNumericIndex(position.dx);
    }
  }

  int? _findBandIndex(double x) {
    final ticks = xScale.ticks();
    if (ticks.isEmpty) return null;

    final bandwidth = xScale.bandwidth ?? 0;

    for (int i = 0; i < ticks.length; i++) {
      final tickX = xScale(ticks[i]);
      if (x >= tickX && x <= tickX + bandwidth) {
        return i;
      }
    }

    double minDistance = double.infinity;
    int nearestIndex = 0;

    for (int i = 0; i < ticks.length; i++) {
      final tickX = xScale(ticks[i]) + bandwidth / 2;
      final distance = (x - tickX).abs();
      if (distance < minDistance) {
        minDistance = distance;
        nearestIndex = i;
      }
    }

    return nearestIndex;
  }

  int? _findNearestNumericIndex(double x) {
    if (data.isEmpty) return null;

    double minDistance = double.infinity;
    int nearestIndex = 0;

    for (int i = 0; i < data.length; i++) {
      final point = data[i];
      final xValue = point[xDataKey];
      if (xValue == null) continue;

      final pointX = xScale(xValue);
      final distance = (x - pointX).abs();

      if (distance < minDistance) {
        minDistance = distance;
        nearestIndex = i;
      }
    }

    return nearestIndex;
  }

  TooltipPayload buildTooltipPayload(int index, Offset coordinate) {
    final point = data[index];
    final label = point.getStringValue(xDataKey) ?? 'Index $index';

    final entries = <TooltipEntry>[];

    for (final seriesInfo in seriesInfoList) {
      final value = point[seriesInfo.dataKey];
      if (value != null) {
        entries.add(TooltipEntry(
          name: seriesInfo.displayName,
          value: value,
          color: seriesInfo.color,
          unit: seriesInfo.unit,
        ));
      }
    }

    return TooltipPayload(
      index: index,
      label: label,
      entries: entries,
      coordinate: coordinate,
    );
  }

  Offset? getPointCoordinate(int index, String dataKey) {
    if (index < 0 || index >= data.length) return null;

    final point = data[index];
    final xValue = point[xDataKey];
    final yValue = point.getNumericValue(dataKey);

    if (xValue == null || yValue == null) return null;

    final x = xScale(xValue) + (xScale.bandwidth ?? 0) / 2;
    final y = yScale(yValue);

    return Offset(x, y);
  }
}
