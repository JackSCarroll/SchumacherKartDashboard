import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schumacher/data/location_selector_provider.dart';
import 'package:schumacher/widgets/custom_card_widget.dart';

class UploaderWidget extends StatefulWidget {
  final VoidCallback onClose;
  const UploaderWidget({required this.onClose, super.key});
  @override
  State<UploaderWidget> createState() => _UploaderWidget();
}

class _UploaderWidget extends State<UploaderWidget> {
  Uint8List? fileBytes;
  String fileName = '';
  DateTime? _selectedDateTime;
  List<List<dynamic>> _csvData = [];
  

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      setState(() {
        fileBytes = result.files.single.bytes;
        fileName = result.files.single.name;
      });
      _parseCsvFile();
    }
  }

  Future<void> _parseCsvFile() async {
    if (fileBytes == null) return;

    final input = utf8.decode(fileBytes!);
    final fields = const CsvToListConverter().convert(input);

    setState(() {
      _csvData = fields;
    });
  }

  Future<void> _uploadData(LocationSelectorProvider locationSelectorProvider) async {
    if (_csvData.isEmpty || _selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }
    
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    DocumentReference userDocumentReference = firestore.collection('user_set_locations')
                                                      .doc(auth.currentUser?.uid)
                                                      .collection('locations')
                                                      .doc(locationSelectorProvider.selectedLocation.uid);

    final docRef = userDocumentReference.collection('gps_data').doc(_selectedDateTime!.toIso8601String());
    final batch = firestore.batch();
    docRef.set({
      'id': _selectedDateTime!.toIso8601String(),
    });
    for (int index = 1; index < _csvData.length; index++) { // Skip header row
      final row = _csvData[index];
      final pointRef = docRef.collection('points').doc('point $index');
      batch.set(pointRef, {
        'time': row[0],
        'latitude': row[1],
        'longitude': row[2],
        'speed': row[3],
        'altitude': row[4],
      });
    }

    await batch.commit();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data uploaded successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    var locationSelectorProvider = Provider.of<LocationSelectorProvider>(context);
    return SizedBox(
      height: 400,
      width: 600,
      child: CustomCard(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _pickFile,
                child: const Text('Pick CSV File'),
              ),
              if (fileBytes != null) Text('File: $fileName'),
              const SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () async {
                  final DateTime? dateTime = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if(dateTime != null) {
                    setState(() {
                      _selectedDateTime = dateTime;
                    });
                  }
                },
                child: const Text('Pick Date'),
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () async {
                  final TimeOfDay? timeOfDay = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if(timeOfDay != null && _selectedDateTime != null) {
                    setState(() {
                      _selectedDateTime = DateTime(
                        _selectedDateTime!.year,
                        _selectedDateTime!.month,
                        _selectedDateTime!.day,
                        timeOfDay.hour,
                        timeOfDay.minute,
                      );
                    });
                  }
                },
                child: const Text('Pick Time'),
              ),
              const SizedBox(height: 10.0),
              if (_selectedDateTime != null) Text('Selected: ${_selectedDateTime!.day}/${_selectedDateTime!.month}/${_selectedDateTime!.year} at ${_selectedDateTime!.hour}:${_selectedDateTime!.minute}'),
              const SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () => _uploadData(locationSelectorProvider),
                child: const Text('Upload Data'),
              ),
              const SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: widget.onClose,
                child: const Text('Close'),
              ),
            ],
          ),
        )
      )
    );
  }
}