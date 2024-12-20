import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:schumacher/data/location_data.dart';
import 'package:schumacher/data/location_editor_provider.dart';
import 'package:schumacher/data/location_selector_provider.dart';
import 'package:schumacher/data/map_points_provider.dart';
import 'package:schumacher/widgets/custom_card_widget.dart';

class LocationEditorWidget extends StatefulWidget {
  const LocationEditorWidget({super.key});
  @override
  State<LocationEditorWidget> createState() => _LocationEditorWidgetState();
}

class _LocationEditorWidgetState extends State<LocationEditorWidget> {
  @override
  Widget build(BuildContext context) {
    var locationEditorProvider = Provider.of<LocationEditorProvider>(context);
    var mapPointsProvider = Provider.of<MapPointsProvider>(context);
    final User? user = FirebaseAuth.instance.currentUser;
    final String uid = user?.uid ?? '';
    final LocationData locationData = locationEditorProvider.getEditingLocation;
    final List<List<LatLng>> points = locationEditorProvider.points;

    return Column(
      children: [
        const SizedBox(height: 10),
        const Text('Location Editor'),
        CustomCard(child: Row(
          children: [
            const Text('Location Name: '),
            Text(locationData.name)
          ],
        ),),
        const SizedBox(height: 10),
        CustomCard(child: Row(
          children: [
            const Text('Latitude: '),
            Text(locationData.latLng.latitude.toString())
          ],
        ),),
        const SizedBox(height: 10),
        CustomCard(child: Row(
          children: [
            const Text('Longitude: '),
            Text(locationData.latLng.longitude.toString())
          ],
        ),),
        const SizedBox(height: 10),
        CustomCard(child: SizedBox(
          height: 100,
          child: ListView.builder(
            itemCount: mapPointsProvider.points.length,
            itemBuilder: (_, index) {
              return ListTile(
                title: Text('Sector ${index + 1}'),
                subtitle: Text('Latitude: ${mapPointsProvider.points[index][0].latitude.toString()}, Longitude: ${mapPointsProvider.points[index][0].longitude.toString()}'),
              );
            },
          ),
        ),),
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

      final pointRef = docRef.collection('locations').doc();
      batch.set(pointRef, {
        'id': pointRef.id,
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