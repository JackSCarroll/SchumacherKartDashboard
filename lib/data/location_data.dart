import 'package:latlong2/latlong.dart';

class LocationData {
  final String uid;
  final String name;
  final double zoom;
  final LatLng latLng;
  List<List<LatLng>> sectors;

  LocationData({required this.uid, required this.name, required this.zoom, required this.latLng, this.sectors = const []});
  
  void addSectors(List<List<LatLng>> sector) {
    sectors.addAll(sector);
  }
  
  factory LocationData.fromMap(Map<String, dynamic> map) {
    return LocationData(
      uid: map['id'] as String,
      name: map['name'] as String,
      latLng: LatLng(map['latitude'] as double, map['longitude'] as double),
      zoom: map['zoom'] as double,
      sectors: [],
    );
  }
}