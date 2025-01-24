import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:schumacher/data/location_data.dart';

class LocationSelectorProvider with ChangeNotifier {
  List<LocationData> _locations = [];
  LocationData _selectedLocation = LocationData(uid: '', name: '', zoom: 0, latLng: const LatLng(0, 0));

  List<LocationData> get locations => _locations;
  LocationData get selectedLocation => _selectedLocation;
  bool get hasNoLocations => _locations.isEmpty;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loadLocations() async {
    CollectionReference locationsCollectionRef = _firestore.collection('user_set_locations').doc(_auth.currentUser?.uid).collection('locations');
    QuerySnapshot querySnapshot = await locationsCollectionRef.get();
    List<LocationData> allData = await Future.wait(querySnapshot.docs.map((doc) async {
      //LocationData locationData = LocationData.fromMap(doc as Map<String, dynamic>);
      var docId = doc.id;
      var name = doc['name'] as String;
      var zoom = doc['zoom'] as double;
      LatLng latLng = LatLng(doc['latitude'] as double, doc['longitude'] as double);
      List<List<LatLng>> docSectors = [];
        
      // Fetch subcollection 'sectors'
        try {
          CollectionReference sectorsCollectionRef = doc.reference.collection('sectors');
          QuerySnapshot sectorsSnapshot = await sectorsCollectionRef.get();
          List<List<LatLng>> sectors = sectorsSnapshot.docs.map((sectorDoc) {
            final data = sectorDoc.data() as Map<String, dynamic>;
            if (data.containsKey('latitude_1') && data.containsKey('longitude_1') && data.containsKey('latitude_2') && data.containsKey('longitude_2')) {
              return [
                LatLng(data['latitude_1'] as double, data['longitude_1'] as double),
                LatLng(data['latitude_2'] as double, data['longitude_2'] as double),
              ];
            } else {
              print('Invalid sector data: $data');
              return <LatLng>[];
            }
          }).where((sector) => sector.isNotEmpty).toList();

          docSectors.addAll(sectors);
        } catch (e) {
          print('Error fetching sectors: $e');
        }
      return LocationData(uid: docId, name: name, zoom: zoom, latLng: latLng, sectors: docSectors);
    }).toList());
    if(allData.isNotEmpty) {
      _locations.clear();
      _locations.addAll(allData);
      if (_selectedLocation.name.isEmpty) {
        _selectedLocation = _locations[0]; // Log the sector data
      }
      notifyListeners();
      print('Locations loaded');
    }
    
  }

  void setSelectedLocation(LocationData locationData) {
    _selectedLocation = LocationData(uid: locationData.uid, name: locationData.name, zoom: locationData.zoom, latLng: locationData.latLng);
    hasNoLocations;
    notifyListeners();
  }
}