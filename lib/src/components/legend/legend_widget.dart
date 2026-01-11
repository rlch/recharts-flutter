import 'package:flutter/material.dart';

import 'legend_entry.dart';
import 'chart_legend.dart';
import 'default_legend_content.dart';

class LegendWidget extends StatelessWidget {
  final List<LegendEntry> entries;
  final ChartLegend config;
  final LegendItemTapCallback? onItemTap;
  final LegendContentBuilder? contentBuilder;

  const LegendWidget({
    super.key,
    required this.entries,
    required this.config,
    this.onItemTap,
    this.contentBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (!config.enabled || entries.isEmpty) {
      return const SizedBox.shrink();
    }

    final effectiveOnTap = config.interactive ? onItemTap : null;

    if (contentBuilder != null && effectiveOnTap != null) {
      return contentBuilder!(entries, effectiveOnTap);
    }

    return Padding(
      padding: EdgeInsets.all(config.wrapperMargin),
      child: DefaultLegendContent(
        entries: entries,
        config: config,
        onItemTap: effectiveOnTap,
      ),
    );
  }
}
