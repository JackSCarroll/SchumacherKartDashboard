import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:schumacher/data/location_data.dart';
import 'package:schumacher/data/map_points_provider.dart';

class LocationEditorProvider with ChangeNotifier {
    LocationData _locationData = LocationData(name: '', zoom: 0, latLng: const LatLng(0, 0));
    final MapPointsProvider _mapPointsProvider = MapPointsProvider();
    LocationData get getEditingLocation => _locationData;
    List<List<LatLng>> get points => _mapPointsProvider.points;

    void setLocationData(String name, LatLng latLng, double zoom) {
        _locationData = LocationData(name: name, latLng: latLng, zoom: zoom);
        notifyListeners();
    }
}