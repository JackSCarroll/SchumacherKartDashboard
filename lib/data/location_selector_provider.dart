import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:schumacher/data/location_data.dart';

class LocationSelectorProvider with ChangeNotifier {
  final List<LocationData> _locations = [];
  late LocationData _selectedLocation;

  List<LocationData> get locations => _locations;
  LocationData get selectedLocation => _selectedLocation;
  bool get hasNoLocations => _locations.isEmpty;

  void setSelectedLocation(LocationData locationData) {
    _selectedLocation = LocationData(name: locationData.name, zoom: locationData.zoom, latLng: locationData.latLng);
    notifyListeners();
  }

  void addLocation(LatLng point1, String name, double zoom) {
    LocationData locationData = LocationData(name: name, zoom: zoom, latLng: point1);
    _locations.add(locationData);
    setSelectedLocation(locationData);
  }
}