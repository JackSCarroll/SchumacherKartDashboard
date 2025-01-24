import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schumacher/data/location_selector_provider.dart';

class DataSelectorProvider with ChangeNotifier {
  List<String> _dataSets = [];
  String _selectedDataSet = '';

  List<String> get dataSets => _dataSets;
  String get selectedDataSet => _selectedDataSet;
  bool get hasNoData => _dataSets.isEmpty;

  //final LocationSelectorProvider _locationSelectorProvider = LocationSelectorProvider();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loadDataSetNames(String locationUid) async {
    _dataSets.clear();
    //if (selectedLocation == null || selectedLocation.isEmpty) {
    //  print(selectedLocation);
    //  return;
    //}
    CollectionReference dataSetCollectionRef = _firestore.collection('user_set_locations').doc(_auth.currentUser?.uid).collection('locations').doc(locationUid).collection('gps_data');
    QuerySnapshot querySnapshot = await dataSetCollectionRef.get();
    print('Number of documents: ${querySnapshot.docs.length}');
    List<DocumentSnapshot> documents = querySnapshot.docs;
    documents.forEach((doc) {
      _dataSets.add(doc.id);
    });

    if(_dataSets.isNotEmpty) {
      if (_selectedDataSet.isEmpty) {
            _selectedDataSet = _dataSets[0];
      }
    }
    notifyListeners();
  }

  void setSelectedDataSet(String dataSet) {
    _selectedDataSet = dataSet;
    hasNoData;
    notifyListeners();
  }
}