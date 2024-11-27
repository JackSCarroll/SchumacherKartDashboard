import 'package:latlong2/latlong.dart';

class LocationData {
  final String name;
  final double zoom;
  final LatLng latLng;

  LocationData({required this.name, required this.zoom, required this.latLng});
}