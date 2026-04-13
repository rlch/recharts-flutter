import 'package:flutter_test/flutter_test.dart';
import 'package:recharts_flutter/recharts_flutter.dart';

void main() {
  group('RechartsConverter', () {
    const converter = RechartsConverter();

    test('converts percent area chart snippets into an area spec', () {
      const source = '''
const data = [
  { month: 'Jan', a: 100, b: 200 },
  { month: 'Feb', a: 150, b: 250 },
];

<AreaChart data={data} stackOffset="expand">
  <CartesianGrid strokeDasharray="3 3" />
  <XAxis dataKey="month" />
  <YAxis />
  <Tooltip content={renderTooltipContent} />
  <Area type="monotone" dataKey="a" stackId="1" stroke="#8884d8" fill="#8884d8" />
  <Area type="monotone" dataKey="b" stackId="1" stroke="#82ca9d" fill="#82ca9d" />
</AreaChart>
''';

      final result = converter.convert(source);

      expect(result.spec.kind, RechartsChartKind.area);
      expect(result.spec.areaSeries, hasLength(2));
      expect(result.spec.xAxes.single.dataKey, 'month');
      expect(result.spec.stackOffset, StackOffsetType.expand);
      expect(result.comments.single, contains('renderTooltipContent'));
    });

    test('converts pie chart snippets into a pie spec', () {
      const source = '''
const data = [
  { name: 'A', value: 400 },
  { name: 'B', value: 300 },
];

<PieChart>
  <Tooltip />
  <Pie data={data} dataKey="value" nameKey="name" innerRadius={40} outerRadius={80} />
</PieChart>
''';

      final result = converter.convert(source);

      expect(result.spec.kind, RechartsChartKind.pie);
      expect(result.spec.pieSeries, hasLength(1));
      expect(result.spec.pieSeries.single.dataKey, 'value');
      expect(result.spec.pieSeries.single.nameKey, 'name');
      expect(result.spec.pieSeries.single.innerRadius, 40);
    });
  });
}
