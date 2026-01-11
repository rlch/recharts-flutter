/// Time-based sample data matching Recharts' Time.ts
library;

/// Date strings for time axis
final dateData = [
  '2015-10-01',
  '2015-10-02',
  '2015-10-03',
  '2015-10-04',
  '2015-10-05',
  '2015-10-06',
  '2015-10-07',
  '2015-10-08',
  '2015-10-09',
  '2015-10-10',
  '2015-10-11',
  '2015-10-12',
  '2015-10-13',
  '2015-10-14',
  '2015-10-15',
];

/// Time series data with DateTime objects
final timeData = [
  {'x': DateTime(2019, 7, 4), 'y': 5, 'z': 7},
  {'x': DateTime(2019, 7, 5), 'y': 30, 'z': 7},
  {'x': DateTime(2019, 7, 6), 'y': 50, 'z': 12},
  {'x': DateTime(2019, 7, 7), 'y': 43, 'z': 35},
  {'x': DateTime(2019, 7, 8), 'y': 20, 'z': 14},
  {'x': DateTime(2019, 7, 9), 'y': -20, 'z': -10},
  {'x': DateTime(2019, 7, 10), 'y': 30, 'z': 53},
];

/// Date with value data using timestamps
final dateWithValueData = [
  {'time': 1483142400000, 'value': 10},
  {'time': 1483146000000, 'value': 20},
  {'time': 1483147800000, 'value': 20},
  {'time': 1483149600000, 'value': 30},
  {'time': 1483153200000, 'value': 10},
  {'time': 1483155000000, 'value': 40},
  {'time': 1483156800000, 'value': 40},
  {'time': 1483160400000, 'value': 20},
  {'time': 1483164000000, 'value': 30},
  {'time': 1483167600000, 'value': 10},
  {'time': 1483171200000, 'value': 60},
  {'time': 1483173000000, 'value': 60},
  {'time': 1483178400000, 'value': 60},
];

/// Monthly data for synchronized charts
final monthlyData1 = [
  {'month': 'Jan', 'revenue': 4000, 'users': 2400},
  {'month': 'Feb', 'revenue': 3000, 'users': 1398},
  {'month': 'Mar', 'revenue': 2000, 'users': 9800},
  {'month': 'Apr', 'revenue': 2780, 'users': 3908},
  {'month': 'May', 'revenue': 1890, 'users': 4800},
  {'month': 'Jun', 'revenue': 2390, 'users': 3800},
  {'month': 'Jul', 'revenue': 3490, 'users': 4300},
];

final monthlyData2 = [
  {'month': 'Jan', 'sessions': 1000},
  {'month': 'Feb', 'sessions': 1500},
  {'month': 'Mar', 'sessions': 1200},
  {'month': 'Apr', 'sessions': 1800},
  {'month': 'May', 'sessions': 2000},
  {'month': 'Jun', 'sessions': 2200},
  {'month': 'Jul', 'sessions': 2500},
];
