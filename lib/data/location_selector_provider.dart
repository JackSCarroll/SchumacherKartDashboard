import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:schumacher/data/location_data.dart';

class LocationSelectorProvider with ChangeNotifier {
  final Map<LatLng, LocationData> _locations = {};
  Map<LatLng, LocationData> _selectedLocation = {};

  Map<LatLng, LocationData> get locations => _locations;
  Map<LatLng, LocationData> get selectedLocation => _selectedLocation;
  bool get hasNoLocations => _locations.isEmpty;

  void setSelectedLocation(LatLng point) {
    _selectedLocation = {};
    _selectedLocation[point] = _locations[point]!;
    notifyListeners();
  }

  void addLocation(LatLng point1, String name, double zoom) {
    LocationData locationData = LocationData(name: name, zoom: zoom);
    _locations.addEntries([MapEntry(point1, locationData)]);
    setSelectedLocation(point1);
  }
}