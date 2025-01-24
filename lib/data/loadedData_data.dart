import 'package:latlong2/latlong.dart';

class LoadedDataData {
  final double altitude;
  final double speed;
  final String time;
  final LatLng latLng;

  LoadedDataData({required this.altitude, required this.speed, required this.time, required this.latLng});
  
  factory LoadedDataData.fromMap(Map<String, dynamic> map) {
    return LoadedDataData(
      altitude: map['altitude'] as double,
      speed: map['speed'] as double,
      latLng: LatLng(map['latitude'] as double, map['longitude'] as double),
      time: map['time'] as String,
    );
  }
}