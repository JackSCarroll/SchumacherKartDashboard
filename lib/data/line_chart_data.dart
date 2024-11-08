import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schumacher/data/csv_processor.dart';

class LineData {
  final leftTitle = {
    0: '0',
    20: '20',
    40: '40',
    60: '60',
    80: '80',
    100: '100'
  };

  late final List<FlSpot> spots;
  late final Map<double, String> bottomTitle;

  LineData(BuildContext context) {
    final csvProcessor = Provider.of<CsvProcessor>(context, listen: false);
    spots = csvProcessor.spots;
    bottomTitle = csvProcessor.bottomTitle;
  }

}