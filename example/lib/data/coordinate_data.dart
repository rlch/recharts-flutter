/// Coordinate and scatter data matching Recharts' Coordinate.ts
library;

/// Simple coordinate data
final coordinateData = [
  {'x': 9, 'y': 5},
  {'x': 15, 'y': 30},
  {'x': 28, 'y': 50},
  {'x': 500, 'y': 200},
];

/// Coordinate data with values for bubble charts
final coordinateWithValueData = [
  {'x': 10, 'y': 50, 'z': 100},
  {'x': 150, 'y': 150, 'z': 100},
  {'x': 290, 'y': 70, 'z': 100},
  {'x': 430, 'y': 60, 'z': 100},
  {'x': 570, 'y': 30, 'z': 100},
];

/// Scatter chart data
final scatterData01 = [
  {'x': 100, 'y': 200, 'z': 200},
  {'x': 120, 'y': 100, 'z': 260},
  {'x': 170, 'y': 300, 'z': 400},
  {'x': 140, 'y': 250, 'z': 280},
  {'x': 150, 'y': 400, 'z': 500},
  {'x': 110, 'y': 280, 'z': 200},
];

final scatterData02 = [
  {'x': 200, 'y': 260, 'z': 240},
  {'x': 240, 'y': 290, 'z': 220},
  {'x': 190, 'y': 290, 'z': 250},
  {'x': 198, 'y': 250, 'z': 210},
  {'x': 180, 'y': 280, 'z': 260},
  {'x': 210, 'y': 220, 'z': 230},
];

/// Node and link data for Sankey charts
final nodeLinkData = {
  'nodes': [
    {'name': 'Visit'},
    {'name': 'Direct-Favourite'},
    {'name': 'Page-Click'},
    {'name': 'Detail-Favourite'},
    {'name': 'Lost'},
  ],
  'links': [
    {'source': 0, 'target': 1, 'value': 3728.3},
    {'source': 0, 'target': 2, 'value': 354170.0},
    {'source': 2, 'target': 3, 'value': 291741.0},
    {'source': 2, 'target': 4, 'value': 62429.0},
  ],
};

/// Complex node link data for Sankey
final complexNodeLinkData = {
  'nodes': [
    {'name': 'Income'},
    {'name': 'Budget'},
    {'name': 'Investment'},
    {'name': 'Real Estate'},
    {'name': 'Crypto'},
    {'name': 'Stocks & Funds'},
    {'name': 'Saving'},
    {'name': 'Scpi'},
    {'name': 'BTC'},
    {'name': 'ETH'},
    {'name': 'SOL'},
    {'name': 'Housing'},
    {'name': 'Food'},
    {'name': 'Rent'},
    {'name': 'Utility'},
    {'name': 'Mortgage'},
    {'name': 'Groceries'},
    {'name': 'Delivery'},
    {'name': 'Restaurant'},
  ],
  'links': [
    {'source': 0, 'target': 1, 'value': 8500.0},
    {'source': 1, 'target': 2, 'value': 2300.0},
    {'source': 1, 'target': 3, 'value': 400.0},
    {'source': 1, 'target': 4, 'value': 1250.0},
    {'source': 2, 'target': 5, 'value': 1800.0},
    {'source': 2, 'target': 6, 'value': 500.0},
    {'source': 3, 'target': 7, 'value': 400.0},
    {'source': 4, 'target': 8, 'value': 500.0},
    {'source': 4, 'target': 9, 'value': 500.0},
    {'source': 4, 'target': 10, 'value': 250.0},
    {'source': 1, 'target': 11, 'value': 3384.0},
    {'source': 1, 'target': 12, 'value': 800.0},
    {'source': 11, 'target': 13, 'value': 1234.0},
    {'source': 11, 'target': 14, 'value': 150.0},
    {'source': 11, 'target': 15, 'value': 2000.0},
    {'source': 12, 'target': 16, 'value': 450.0},
    {'source': 12, 'target': 17, 'value': 200.0},
    {'source': 12, 'target': 18, 'value': 150.0},
  ],
};

/// Treemap data
final treemapData = {
  'name': 'Axis',
  'children': [
    {
      'name': 'Event',
      'size': 8023,
    },
    {
      'name': 'Displays',
      'children': [
        {'name': 'RectSprite', 'size': 3623},
        {'name': 'TextSprite', 'size': 10066},
      ],
    },
    {
      'name': 'Legend',
      'children': [
        {'name': 'LegendItem', 'size': 4054},
        {'name': 'LegendRange', 'size': 10530},
      ],
    },
    {
      'name': 'Layouts',
      'children': [
        {'name': 'AxisLayout', 'size': 6725},
        {'name': 'TreeMapLayout', 'size': 9191},
        {'name': 'PieLayout', 'size': 7214},
      ],
    },
  ],
};
