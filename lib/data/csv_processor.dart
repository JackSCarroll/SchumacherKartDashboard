import 'package:csv/csv.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';


class CsvProcessor with ChangeNotifier{

  List<List<dynamic>> csvData = [];
  List<FlSpot> spots = [];
  Map<double, String> bottomTitle = {};
  String totalTime = '';
  String averageSpeed = '';

  Future<void> loadCsvData() async {
    // Load the CSV data from the path
    final rawData = await rootBundle.loadString('assets/data/gps_data.csv');
    csvData = const CsvToListConverter().convert(rawData);
    print('Loading CSV data...');
    _parseCsvData(csvData);
    print('Data loaded successfully');
    notifyListeners();
  }

  void _parseCsvData(List<List<dynamic>> csvData) {
    final dateFormat = DateFormat('HH:mm:ss');
    var tempMinute = 0;
    var tempSpeed = 0.0;
    // Parse the CSV data and assign it to the spots list
    for (var i = 1; i < csvData.length; i++) {
      final row = csvData[i];
      final timestring = row[0] as String;

      final time = dateFormat.parse(timestring);
      var minute = time.minute;
      final speed = row[3] as double;
      tempSpeed += speed;
      final timeInMilliseconds = time.millisecondsSinceEpoch.toDouble();

      if (i == csvData.length - 1 || i == 1)
      {
        bottomTitle[timeInMilliseconds] = _formatTimeLabel(time);
      } else if (minute != tempMinute)
      {
        final adjustedTime = DateTime(time.year, time.month, time.day, time.hour, time.minute, 0);
        final adjustedTimeInMilliseconds = adjustedTime.millisecondsSinceEpoch.toDouble();
        bottomTitle[adjustedTimeInMilliseconds] = _formatTimeLabel(adjustedTime);
      }

      spots.add(FlSpot(timeInMilliseconds, speed));
      tempMinute = minute;
    }
    DateTime startTime = dateFormat.parse(bottomTitle.values.first);
    DateTime endTime = dateFormat.parse(bottomTitle.values.last);
    final difference = endTime.difference(startTime);
    String formattedDifference;
    if (difference.inHours > 0) {
      formattedDifference = '${difference.inHours}h:${difference.inMinutes % 60}m:${difference.inSeconds % 60}s';
    } else {
      formattedDifference = '${difference.inMinutes}m:${difference.inSeconds % 60}s';
    }
    totalTime = formattedDifference;

    averageSpeed = '${(tempSpeed / csvData.length).toStringAsFixed(1)} km/h';
  }

  String _formatTimeLabel(DateTime time) {
    // Format the time and add it to the bottomTile Map
    final formattedTime = DateFormat('HH:mm:ss').format(time).toString();
    return formattedTime;
  }
  
}