import 'dart:math';

import 'package:csv/csv.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';


class CsvProcessor with ChangeNotifier{

  List<List<dynamic>> csvData = [];
  List<FlSpot> spots = [];
  Map<double, String> bottomTitle = {};
  String totalTime = '';
  String averageSpeed = '';
  double totalDistance = 0.0;
  List<LatLng> latLngPoints = [];

  Future<void> loadCsvData() async {
    // Load the CSV data from the path
    final rawData = await rootBundle.loadString('assets/data/gps_data.csv');
    csvData = const CsvToListConverter().convert(rawData);
    _parseCsvData(csvData);
    notifyListeners();
  }

  Future<void> refreshData() async {
    // Refresh the data
    spots = [];
    bottomTitle = {};
    totalTime = '';
    averageSpeed = '';
    loadCsvData();
    notifyListeners();
  }

  void _parseCsvData(List<List<dynamic>> csvData) {
    final dateFormat = DateFormat('HH:mm:ss');
    var tempMinute = 0;
    var tempSpeed = 0.0;
    // Parse the CSV data and assign it to the spots list and latlngPoints list
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

      latLngPoints.add(LatLng(row[1], row[2]));
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

    for (int i = 0; i < latLngPoints.length - 2; i++) {
      totalDistance += calculateDistance(latLngPoints[i], latLngPoints[i + 1]);
    }
  }

  String _formatTimeLabel(DateTime time) {
    // Format the time and add it to the bottomTile Map
    final formattedTime = DateFormat('HH:mm:ss').format(time).toString();
    return formattedTime;
  }

  // Calculate the distance between two points using the Haversine formula (Thanks to the mathematicians that are way smarter than me 😊)
  double calculateDistance(LatLng point1, LatLng point2) {
  const double earthRadius = 6371000; // Radius of the Earth in meters
  final double lat1 = point1.latitude * (3.141592653589793 / 180.0);
  final double lon1 = point1.longitude * (3.141592653589793 / 180.0);
  final double lat2 = point2.latitude * (3.141592653589793 / 180.0);
  final double lon2 = point2.longitude * (3.141592653589793 / 180.0);

  final double dLat = lat2 - lat1;
  final double dLon = lon2 - lon1;

  final double a = (sin(dLat / 2) * sin(dLat / 2)) +
      cos(lat1) * cos(lat2) * (sin(dLon / 2) * sin(dLon / 2));
  final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  return earthRadius * c;
}
  
}