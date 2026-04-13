import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recharts_flutter/recharts_flutter.dart';

class ConverterLab extends StatefulWidget {
  const ConverterLab({super.key});

  @override
  State<ConverterLab> createState() => _ConverterLabState();
}

class _ConverterLabState extends State<ConverterLab> {
  final _converter = const RechartsConverter();
  late final TextEditingController _sourceController;
  late final TextEditingController _dataController;

  RechartsConversionResult? _result;
  String? _error;

  @override
  void initState() {
    super.initState();
    _sourceController = TextEditingController(text: _defaultSnippet);
    _dataController = TextEditingController();
    _runConversion();
  }

  @override
  void dispose() {
    _sourceController.dispose();
    _dataController.dispose();
    super.dispose();
  }

  void _runConversion() {
    setState(() {
      _error = null;
      try {
        final override = _parseDataOverride(_dataController.text);
        _result = _converter.convert(
          _sourceController.text,
          dataOverride: override,
        );
      } catch (error) {
        _result = null;
        _error = error.toString();
      }
    });
  }

  Object? _parseDataOverride(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return null;
    return jsonDecode(text);
  }

  @override
  Widget build(BuildContext context) {
    final result = _result;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Recharts Converter',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Paste a full Recharts example snippet. If the snippet references external data, you can supply JSON below or let the converter generate sample preview data.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _sourceController,
                    maxLines: 18,
                    decoration: const InputDecoration(
                      labelText: 'Recharts source',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _dataController,
                    maxLines: 8,
                    decoration: const InputDecoration(
                      labelText: 'Optional data override (JSON)',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      FilledButton.icon(
                        onPressed: _runConversion,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Convert'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () {
                          _sourceController.text = _defaultSnippet;
                          _dataController.clear();
                          _runConversion();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reset'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Preview',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 380,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _error != null
                        ? Center(child: Text(_error!))
                        : (result == null
                            ? const SizedBox.shrink()
                            : result.buildWidget()),
                  ),
                  if (result != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Parsed chart: ${result.spec.sourceChartTag}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (_error == null && result != null) ...[
            const SizedBox(height: 16),
            _DiagnosticsCard(
              title: 'Warnings',
              lines: result.warnings,
              emptyMessage: 'No conversion warnings.',
            ),
            const SizedBox(height: 16),
            _DiagnosticsCard(
              title: 'Preserved comments',
              lines: result.comments,
              emptyMessage: 'No preserved comments.',
              monospace: true,
            ),
          ],
        ],
      ),
    );
  }
}

class _DiagnosticsCard extends StatelessWidget {
  final String title;
  final List<String> lines;
  final String emptyMessage;
  final bool monospace;

  const _DiagnosticsCard({
    required this.title,
    required this.lines,
    required this.emptyMessage,
    this.monospace = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveLines = lines.isEmpty ? [emptyMessage] : lines;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...effectiveLines.map(
              (line) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  line,
                  style: monospace
                      ? const TextStyle(fontFamily: 'monospace')
                      : Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const _defaultSnippet = '''
const renderTooltipContent = (o) => {
  const { payload, label } = o;
  const total = payload.reduce((result, entry) => result + Number(entry.value), 0);

  return (
    <div
      className="customized-tooltip-content"
      style={{
        backgroundColor: 'white',
        border: '1px solid #ccc',
        padding: '10px',
        borderRadius: '10px',
      }}
    >
      <h3>{`\${label} (Total: \${total})`}</h3>
    </div>
  );
};

const data = [
  { month: 'Jan', a: 4000, b: 2400, c: 2400 },
  { month: 'Feb', a: 3000, b: 1398, c: 2210 },
  { month: 'Mar', a: 2000, b: 9800, c: 2290 },
  { month: 'Apr', a: 2780, b: 3908, c: 2000 },
];

const PercentAreaChart = () => {
  return (
    <AreaChart
      style={{ width: '100%', maxWidth: '700px', maxHeight: '70vh', aspectRatio: 1.618 }}
      responsive
      data={data}
      stackOffset="expand"
      margin={{
        top: 10,
        right: 20,
        left: 0,
        bottom: 0,
      }}
    >
      <CartesianGrid strokeDasharray="3 3" />
      <XAxis dataKey="month" />
      <YAxis />
      <Tooltip content={renderTooltipContent} />
      <Area type="monotone" dataKey="a" stackId="1" stroke="#8884d8" fill="#8884d8" />
      <Area type="monotone" dataKey="b" stackId="1" stroke="#82ca9d" fill="#82ca9d" />
      <Area type="monotone" dataKey="c" stackId="1" stroke="#ffc658" fill="#ffc658" />
    </AreaChart>
  );
};
''';
