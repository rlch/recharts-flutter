import 'package:flutter/material.dart';

import 'chart_tooltip.dart';
import 'tooltip_types.dart';

class DefaultTooltipContent extends StatelessWidget {
  final TooltipPayload payload;
  final ChartTooltip config;

  const DefaultTooltipContent({
    super.key,
    required this.payload,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelStyle =
        config.labelStyle ??
        theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.grey[800],
        );
    final valueStyle =
        config.valueStyle ??
        theme.textTheme.bodySmall?.copyWith(color: Colors.grey[700]);

    return Container(
      padding: config.contentPadding,
      decoration: BoxDecoration(
        color: config.backgroundColor,
        border: Border.all(
          color: config.borderColor,
          width: config.borderWidth,
        ),
        borderRadius: BorderRadius.circular(config.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (config.showLabel)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(payload.label, style: labelStyle),
            ),
          ...payload.entries.map((entry) => _buildEntryRow(entry, valueStyle)),
        ],
      ),
    );
  }

  Widget _buildEntryRow(TooltipEntry entry, TextStyle? valueStyle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: entry.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          if (config.showSeriesName) ...[
            Text(
              entry.name,
              style: valueStyle?.copyWith(fontWeight: FontWeight.w500),
            ),
            Text(config.separator ?? ' : ', style: valueStyle),
          ],
          Text(_formatEntryValue(entry), style: valueStyle),
        ],
      ),
    );
  }

  String _formatEntryValue(TooltipEntry entry) {
    final rawValue = entry.formattedValue + (entry.unit ?? '');
    final percentValue = entry.formattedPercentValue;
    if (percentValue == null || entry.usePercentTooltipLabel) {
      return rawValue;
    }

    return '$rawValue ($percentValue)';
  }
}
