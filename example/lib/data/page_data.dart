/// Sample data matching Recharts' Page.ts
library;

/// Standard page data for most chart examples
final pageData = [
  {'name': 'Page A', 'uv': 590, 'pv': 800, 'amt': 1400},
  {'name': 'Page B', 'uv': 590, 'pv': 800, 'amt': 1400},
  {'name': 'Page C', 'uv': 868, 'pv': 967, 'amt': 1506},
  {'name': 'Page D', 'uv': 1397, 'pv': 1098, 'amt': 989},
  {'name': 'Page E', 'uv': 1480, 'pv': 1200, 'amt': 1228},
  {'name': 'Page F', 'uv': 1520, 'pv': 1108, 'amt': 1100},
  {'name': 'Page G', 'uv': 1400, 'pv': 680, 'amt': 1700},
];

/// Range data for temperature charts
final rangeData = [
  {'day': '05-01', 'temperature': [-1, 10]},
  {'day': '05-02', 'temperature': [2, 15]},
  {'day': '05-03', 'temperature': [3, 12]},
  {'day': '05-04', 'temperature': [4, 12]},
  {'day': '05-05', 'temperature': [12, 16]},
  {'day': '05-06', 'temperature': [5, 16]},
  {'day': '05-07', 'temperature': [3, 12]},
  {'day': '05-08', 'temperature': [0, 8]},
  {'day': '05-09', 'temperature': [-3, 5]},
];

/// Logarithmic data for performance charts
final logData = [
  {'year': 1970, 'performance': 1},
  {'year': 1975, 'performance': 10},
  {'year': 1980, 'performance': 100},
  {'year': 1985, 'performance': 1000},
  {'year': 1990, 'performance': 10000},
  {'year': 1995, 'performance': 100000},
  {'year': 2000, 'performance': 1000000},
  {'year': 2005, 'performance': 10000000},
  {'year': 2010, 'performance': 100000000},
  {'year': 2015, 'performance': 1000000000},
  {'year': 2020, 'performance': 10000000000},
];

/// Page data with negative numbers
final pageDataWithNegativeNumbers = [
  {'name': 'Page A', 'uv': 4000, 'pv': 2400, 'amt': 2400},
  {'name': 'Page B', 'uv': -3000, 'pv': 1398, 'amt': 2210},
  {'name': 'Page C', 'uv': -2000, 'pv': -9800, 'amt': 2290},
  {'name': 'Page D', 'uv': 2780, 'pv': 3908, 'amt': 2000},
  {'name': 'Page E', 'uv': -1890, 'pv': 4800, 'amt': 2181},
  {'name': 'Page F', 'uv': 2390, 'pv': -3800, 'amt': 2500},
  {'name': 'Page G', 'uv': 3490, 'pv': 4300, 'amt': 2100},
];

/// Number-keyed data for charts with many points
final numberData = [
  {'name': '1', 'uv': 300, 'pv': 456},
  {'name': '2', 'uv': -145, 'pv': 230},
  {'name': '3', 'uv': -100, 'pv': 345},
  {'name': '4', 'uv': -8, 'pv': 450},
  {'name': '5', 'uv': 100, 'pv': 321},
  {'name': '6', 'uv': 9, 'pv': 235},
  {'name': '7', 'uv': 53, 'pv': 267},
  {'name': '8', 'uv': 252, 'pv': -378},
  {'name': '9', 'uv': 79, 'pv': -210},
  {'name': '10', 'uv': 294, 'pv': -23},
  {'name': '12', 'uv': 43, 'pv': 45},
  {'name': '13', 'uv': -74, 'pv': 90},
  {'name': '14', 'uv': -71, 'pv': 130},
  {'name': '15', 'uv': -117, 'pv': 11},
  {'name': '16', 'uv': -186, 'pv': 107},
  {'name': '17', 'uv': -16, 'pv': 926},
  {'name': '18', 'uv': -125, 'pv': 653},
  {'name': '19', 'uv': 222, 'pv': 366},
  {'name': '20', 'uv': 372, 'pv': 486},
];

/// Radar chart data for subject scores
final subjectData = [
  {'subject': 'Math', 'A': 120, 'B': 110, 'fullMark': 150},
  {'subject': 'Chinese', 'A': 98, 'B': 130, 'fullMark': 150},
  {'subject': 'English', 'A': 86, 'B': 130, 'fullMark': 150},
  {'subject': 'Geography', 'A': 99, 'B': 100, 'fullMark': 150},
  {'subject': 'Physics', 'A': 85, 'B': 90, 'fullMark': 150},
  {'subject': 'History', 'A': 65, 'B': 85, 'fullMark': 150},
];

/// Page data with fill colors for radial bar charts
final pageDataWithFillColor = [
  {'name': '18-24', 'uv': 31.47, 'pv': 2400, 'amt': 1400, 'fill': '#8884d8'},
  {'name': '25-29', 'uv': 26.69, 'pv': 4567, 'amt': 720, 'fill': '#83a6ed'},
  {'name': '30-34', 'uv': 15.69, 'pv': 1398, 'amt': 680, 'fill': '#8dd1e1'},
  {'name': '35-39', 'uv': 8.22, 'pv': 9800, 'amt': 1700, 'fill': '#82ca9d'},
  {'name': '40-49', 'uv': 8.63, 'pv': 3908, 'amt': 1500, 'fill': '#a4de6c'},
  {'name': '50+', 'uv': 2.63, 'pv': 4800, 'amt': 680, 'fill': '#d0ed57'},
  {'name': 'unknown', 'uv': 6.67, 'pv': 4800, 'amt': 690, 'fill': '#ffc658'},
];

/// Data with nulls for connectNulls examples
final dataWithNulls = [
  {'name': 'Page A', 'uv': 4000, 'pv': 2400, 'amt': 2400},
  {'name': 'Page B', 'uv': 3000, 'pv': 1398, 'amt': 2210},
  {'name': 'Page C', 'uv': 2000, 'pv': 9800, 'amt': 2290},
  {'name': 'Page D', 'uv': null, 'pv': 3908, 'amt': 2000},
  {'name': 'Page E', 'uv': 1890, 'pv': 4800, 'amt': 2181},
  {'name': 'Page F', 'uv': 2390, 'pv': 3800, 'amt': 2500},
  {'name': 'Page G', 'uv': 3490, 'pv': 4300, 'amt': 2100},
];

/// Pie chart data
final pieData = [
  {'name': 'Group A', 'value': 400},
  {'name': 'Group B', 'value': 300},
  {'name': 'Group C', 'value': 300},
  {'name': 'Group D', 'value': 200},
];

/// Two-level pie chart outer data
final pieOuterData = [
  {'name': 'A1', 'value': 100},
  {'name': 'A2', 'value': 300},
  {'name': 'B1', 'value': 100},
  {'name': 'B2', 'value': 80},
  {'name': 'B3', 'value': 40},
  {'name': 'B4', 'value': 30},
  {'name': 'B5', 'value': 50},
  {'name': 'C1', 'value': 100},
  {'name': 'C2', 'value': 200},
  {'name': 'D1', 'value': 150},
  {'name': 'D2', 'value': 50},
];

/// Funnel chart data
final funnelData = [
  {'name': 'Sent', 'value': 4500, 'fill': '#8884d8'},
  {'name': 'Viewed', 'value': 3000, 'fill': '#83a6ed'},
  {'name': 'Clicked', 'value': 2000, 'fill': '#8dd1e1'},
  {'name': 'Applied', 'value': 1200, 'fill': '#82ca9d'},
  {'name': 'Interviewed', 'value': 500, 'fill': '#a4de6c'},
  {'name': 'Hired', 'value': 100, 'fill': '#d0ed57'},
];
