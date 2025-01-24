import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schumacher/const/constant.dart';

class SettingsProvider with ChangeNotifier {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loadColour() async {
    DocumentReference userDocumentReference = _firestore.collection('users').doc(_auth.currentUser?.uid);
    DocumentSnapshot<Object?> querySnapshot = await userDocumentReference.get();
    Map<String, dynamic> data = querySnapshot.data() as Map<String, dynamic>;
    int preferredColour = data['preferredColour'];
    setSelectedColour(preferredColour);
    }

  Future<void> setColour(int index) async {
    DocumentReference userDocumentReference = _firestore.collection('users').doc(_auth.currentUser?.uid);
    userDocumentReference.update({'preferredColour': index});
  }
  
  Color _selectedPrimaryColour = bluePrimaryColour;
  String _selectedPrimaryColourName = 'Blue';

  Color get selectedPrimaryColour => _selectedPrimaryColour;
  String get selectedPrimaryColourName => _selectedPrimaryColourName;

  void setSelectedColour(int index) {
    // Set the preferred colour in DB for the authed user
    setColour(index);

    // Set the preferred colour in the app for frontend to use
    switch (index) {
      case 0:
        _selectedPrimaryColour = bluePrimaryColour;
        _selectedPrimaryColourName = 'Blue';
        break;
      case 1:
        _selectedPrimaryColour = greenPrimaryColor;
        _selectedPrimaryColourName = 'Green';
        break;
      case 2:
        _selectedPrimaryColour = redPrimaryColour;
        _selectedPrimaryColourName = 'Red';
        break;
      case 3:
        _selectedPrimaryColour = yellowPrimaryColour;
        _selectedPrimaryColourName = 'Yellow';
        break;
      case 4:
        _selectedPrimaryColour = purplePrimaryColour;
        _selectedPrimaryColourName = 'Purple';
        break;
      case 5:
        _selectedPrimaryColour = pinkPrimaryColour;
        _selectedPrimaryColourName = 'Pink';
        break;
      default:
        _selectedPrimaryColour = bluePrimaryColour;
        _selectedPrimaryColourName = 'Blue';
    }
    notifyListeners();
  }
}