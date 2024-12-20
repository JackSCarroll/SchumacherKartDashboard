import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class MapPointsProvider with ChangeNotifier {
  List<List<LatLng>> _points = [];

  List<List<LatLng>> get points => _points;

  void addPoints(LatLng point1, LatLng point2) {
    _points.add([point1, point2]);
    notifyListeners();
  }
}