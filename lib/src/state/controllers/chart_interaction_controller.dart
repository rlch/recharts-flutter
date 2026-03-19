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
  final String categoryDataKey;
  final bool verticalLayout;
  final List<SeriesInfo> seriesInfoList;
  final InteractionStateCallback onStateChanged;

  ChartInteractionController({
    required this.data,
    required this.layout,
    required this.xScale,
    required this.yScale,
    required this.xDataKey,
    String? categoryDataKey,
    this.verticalLayout = false,
    required this.seriesInfoList,
    required this.onStateChanged,
  }) : categoryDataKey = categoryDataKey ?? xDataKey;

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
    _updateState(
      ChartInteractionState(
        isActive: true,
        activeIndex: index,
        activeCoordinate: position,
        tooltipPayload: payload,
      ),
    );
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
    _updateState(
      ChartInteractionState(
        isActive: true,
        activeIndex: index,
        activeCoordinate: position,
        tooltipPayload: payload,
      ),
    );
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
    if (verticalLayout) {
      final bandwidth = yScale.bandwidth;

      if (bandwidth != null && bandwidth > 0) {
        return _findBandIndex(yScale, position.dy);
      }

      return _findNearestIndexByDataKey(
        position.dy,
        scale: yScale,
        dataKey: categoryDataKey,
      );
    }

    final bandwidth = xScale.bandwidth;

    if (bandwidth != null && bandwidth > 0) {
      return _findBandIndex(xScale, position.dx);
    }

    return _findNearestIndexByDataKey(
      position.dx,
      scale: xScale,
      dataKey: xDataKey,
    );
  }

  int? _findBandIndex(Scale<dynamic, double> scale, double value) {
    final ticks = scale.ticks();
    if (ticks.isEmpty) return null;

    final bandwidth = scale.bandwidth ?? 0;

    for (int i = 0; i < ticks.length; i++) {
      final tickValue = scale(ticks[i]);
      if (value >= tickValue && value <= tickValue + bandwidth) {
        return i;
      }
    }

    double minDistance = double.infinity;
    int nearestIndex = 0;

    for (int i = 0; i < ticks.length; i++) {
      final tickValue = scale(ticks[i]) + bandwidth / 2;
      final distance = (value - tickValue).abs();
      if (distance < minDistance) {
        minDistance = distance;
        nearestIndex = i;
      }
    }

    return nearestIndex;
  }

  int? _findNearestIndexByDataKey(
    double value, {
    required Scale<dynamic, double> scale,
    required String dataKey,
  }) {
    if (data.isEmpty) return null;

    double minDistance = double.infinity;
    int nearestIndex = 0;
    bool found = false;

    for (int i = 0; i < data.length; i++) {
      final point = data[i];
      final scaledValueRaw = point[dataKey];
      if (scaledValueRaw == null) continue;

      final scaledValue = scale(scaledValueRaw) + (scale.bandwidth ?? 0) / 2;
      if (scaledValue.isNaN) continue;

      final distance = (value - scaledValue).abs();

      found = true;

      if (distance < minDistance) {
        minDistance = distance;
        nearestIndex = i;
      }
    }

    return found ? nearestIndex : null;
  }

  TooltipPayload buildTooltipPayload(int index, Offset coordinate) {
    final point = data[index];
    final label = point.getStringValue(categoryDataKey) ?? 'Index $index';

    final entries = <TooltipEntry>[];

    for (final seriesInfo in seriesInfoList) {
      final value = point[seriesInfo.dataKey];
      if (value != null) {
        entries.add(
          TooltipEntry(
            name: seriesInfo.displayName,
            value: value,
            color: seriesInfo.color,
            unit: seriesInfo.unit,
          ),
        );
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
    final numericValue = point.getNumericValue(dataKey);
    if (numericValue == null) return null;

    if (verticalLayout) {
      final categoryValue = point[categoryDataKey];
      if (categoryValue == null) return null;

      final x = xScale(numericValue);
      final y = yScale(categoryValue) + (yScale.bandwidth ?? 0) / 2;

      return Offset(x, y);
    }

    final xValue = point[xDataKey];

    if (xValue == null) return null;

    final x = xScale(xValue) + (xScale.bandwidth ?? 0) / 2;
    final y = yScale(numericValue);

    return Offset(x, y);
  }
}
