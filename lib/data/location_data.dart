import 'package:latlong2/latlong.dart';

class LocationData {
  final String name;
  final double zoom;
  final LatLng latLng;

  LocationData({required this.name, required this.zoom, required this.latLng});

  factory LocationData.fromMap(Map<String, dynamic> map) {
    return LocationData(
      name: map['name'] as String,
      latLng: LatLng(map['latitude'] as double, map['longitude'] as double),
      zoom: map['zoom'] as double,
    );
  }
}