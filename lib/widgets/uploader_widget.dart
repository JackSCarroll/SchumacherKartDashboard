import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  Future<void> _uploadData(String uid) async {
    if (_csvData.isEmpty || _selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    final firestore = FirebaseFirestore.instance;
    final docRef = firestore.collection('gps_data').doc('$uid : ${_selectedDateTime!.toIso8601String()}');
    final batch = firestore.batch();

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

  Future<void> _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDateTime) {
      setState(() {
        _selectedDateTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final String uid = user?.uid ?? '';
    return SizedBox(
      height: 300,
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
                child: const Text('Pick Date/Time'),
              ),
              if (_selectedDateTime != null) Text('Selected: $_selectedDateTime'),
              const SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () => _uploadData(uid),
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