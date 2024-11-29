import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:schumacher/data/location_data.dart';

class LocationSelectorProvider with ChangeNotifier {
  List<LocationData> _locations = [];
  LocationData _selectedLocation = LocationData(name: '', zoom: 0, latLng: const LatLng(0, 0));

  List<LocationData> get locations => _locations;
  LocationData get selectedLocation => _selectedLocation;
  bool get hasNoLocations => _locations.isEmpty;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loadLocations() async {
    CollectionReference locationsCollectionRef = _firestore.collection('user_set_locations').doc(_auth.currentUser?.uid).collection('locations');
    QuerySnapshot querySnapshot = await locationsCollectionRef.get();
    List<LocationData> allData = querySnapshot.docs.map((doc) {return LocationData.fromMap(doc.data() as Map<String, dynamic>);}).toList();
    if(allData.isNotEmpty) {
      _locations.clear();
      for (int i = 0; i < allData.length; i++) {
        _locations.add(LocationData(name: allData[i].name, zoom: allData[i].zoom, latLng: allData[i].latLng));
      }
      if (_selectedLocation.name.isEmpty) {
        _selectedLocation = _locations[0];
      }
      notifyListeners();
    }
  }

  void setSelectedLocation(LocationData locationData) {
    _selectedLocation = LocationData(name: locationData.name, zoom: locationData.zoom, latLng: locationData.latLng);
    hasNoLocations;
    notifyListeners();
  }

  void addLocation(LatLng point1, String name, double zoom) {
    LocationData locationData = LocationData(name: name, zoom: zoom, latLng: point1);
    _locations.add(locationData);
    setSelectedLocation(locationData);
  }
}