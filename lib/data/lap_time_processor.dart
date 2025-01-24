import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

class LapTimeProcessor with ChangeNotifier {

  bool sectorCrossed(Cartesian kartVector, Cartesian sectorVector) {
    var crossProduct = kartVector.x * sectorVector.y - kartVector.y * sectorVector.x;
    return (crossProduct > 0);
  }

  Cartesian _convertToCartesian(LatLng position) {
      int earthRadius = 6367;
      double lat1 = position.latitude;
      double lon1 = position.longitude;
      double x = earthRadius * cos(lat1) * cos(lon1);
      double y = earthRadius * cos(lat1) * sin(lon1);
      double z = earthRadius * sin(lat1);
      return Cartesian(x, y, z);
  }

  void calculateLapTime(List<List<LatLng>> kartPositions, List<List<LatLng>> sectorPositions) 
  {
    // Convert sectors to cartesian coordinates and calculate vectors
    List<Cartesian> sectorVectors = [];
    for(int i = 0; i < sectorPositions.length; i++)
    {
        Cartesian vector = _convertToCartesian(sectorPositions[i][1]) - _convertToCartesian(sectorPositions[i][0]);
        sectorVectors.add(vector);
    }
    // Convert kart positions to cartesian coordinates
    List<Cartesian> kartVectors = [];
    for(int i = 0; i < kartPositions.length; i++)
    {
        Cartesian kartCartesian = _convertToCartesian(kartPositions[i][0]) - sectorVectors[i];
        kartVectors.add(kartCartesian);
    }


    
    // Notify listeners about the change
    notifyListeners();
  }

  void updateLapTime() {
    // Your logic to update lap time

    // Notify listeners about the change
    notifyListeners();
  }
}

class Cartesian {
  double x;
  double y;
  double z;

  Cartesian(this.x, this.y, this.z);

  // This allows for subtraction between two Cartesian objects
  Cartesian operator -(Cartesian other) {
    return Cartesian(x - other.x, y - other.y, z - other.z);
  }
}