import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schumacher/data/location_data.dart';
import 'package:schumacher/data/location_selector_provider.dart';

class LocationEditorWidget extends StatefulWidget {
  const LocationEditorWidget({super.key});
  @override
  State<LocationEditorWidget> createState() => _LocationEditorWidgetState();
}

class _LocationEditorWidgetState extends State<LocationEditorWidget> {
  @override
  Widget build(BuildContext context) {
    var locationSelectorProvider = Provider.of<LocationSelectorProvider>(context);
    final User? user = FirebaseAuth.instance.currentUser;
    final String uid = user?.uid ?? '';
    final LocationData locationData = locationSelectorProvider.selectedLocation;


    return Column(
      children: [
        const Text('Location Editor'),
        ElevatedButton(
          onPressed: () {
            _saveLocationToDB(uid, locationData);
          },
          child: const Text('Add Location'),
        ),
      ],
    );
  }

  Future<void> _saveLocationToDB(String uid, LocationData locationData) async {
    if (uid.isEmpty || locationData.name.isEmpty || locationData.latLng == null || locationData.zoom == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    final firestore = FirebaseFirestore.instance;
    final docRef = firestore.collection('user_set_locations').doc(uid);
    final batch = firestore.batch();

      final pointRef = docRef.collection('locations').doc(locationData.name);
      batch.set(pointRef, {
        'name': locationData.name,
        'latitude': locationData.latLng.latitude,
        'longitude': locationData.latLng.longitude,
        'zoom': locationData.zoom,
      });

    await batch.commit();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data uploaded successfully')),
    );
  }
}