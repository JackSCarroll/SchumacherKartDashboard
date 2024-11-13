import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:provider/provider.dart';
import 'package:schumacher/data/csv_processor.dart';
import 'package:schumacher/data/location_selector_provider.dart';
import 'package:schumacher/data/map_points_provider.dart';
import 'package:schumacher/data/settings_provider.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late LatLng firstPoint;
  late LatLng secondPoint;
  bool isAddingPoints = false;
  bool showHeatMap = false;
  int tempPointCounter = 0;
  final MapController _mapController = MapController();
  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<SettingsProvider>(context);
    var csvProvider = Provider.of<CsvProcessor>(context);
    var pointsProvider = Provider.of<MapPointsProvider>(context);
    var locationSelectorProvider = Provider.of<LocationSelectorProvider>(context);
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
                  color: settingsProvider.selectedPrimaryColour,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: settingsProvider.selectedPrimaryColour,
                    width: 2.0,),
                ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6.0),
          child: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  // Todo: Change the initial center to the location of your choice
                  initialCenter: const LatLng(-38.059252616021844, 144.3833972600851),
                  initialZoom: 18.5,
                  onTap: (tapPosition, point) {
                    if(isAddingPoints) {
                      setState(() {
                        if(tempPointCounter == 0) {
                          firstPoint = LatLng(point.latitude, point.longitude);
                          tempPointCounter++;
                        } else {
                          secondPoint = LatLng(point.latitude, point.longitude);
                          pointsProvider.addPoints(firstPoint, secondPoint);
                          tempPointCounter = 0;
                          isAddingPoints = false;
                        }
                      });
                    }
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://api.maptiler.com/tiles/satellite-v2/{z}/{x}/{y}.jpg?key=${dotenv.env['MAPTILER_API_KEY']}',
                    userAgentPackageName: 'dev.jackscarroll.schumacher_dashboard',
                    tileProvider: CancellableNetworkTileProvider(),
                  ),
                  PolylineLayer(
                    polylines: pointsProvider.points.map((pair) {
                      return Polyline(
                        points: pair,
                        strokeWidth: 4.0,
                        color: settingsProvider.selectedPrimaryColour,
                      );
                    }).toList(),
                  ),
                  if(showHeatMap)
                    PolylineLayer(
                    polylines: csvProvider.latLngPoints.asMap().entries.map((entry) {
                      if(entry.key == 0) {
                        return null;
                      }
                      final previousPoint = csvProvider.latLngPoints[entry.key - 1];
                      final currentPoint = csvProvider.latLngPoints[entry.key];
                      final speed = csvProvider.speedValues[entry.key]; // Assuming you have a list of speeds in csvProvider
                      final color = getColorForSpeed(speed);
                      return Polyline(
                        points: [previousPoint, currentPoint],
                        strokeWidth: 4.0,
                        color: color,
                        pattern: const StrokePattern.dotted(spacingFactor: 1, patternFit: PatternFit.scaleUp),
                      );
                    }).where((polyline) => polyline != null).toList().cast<Polyline>(),
                  ),
                ],
              ),
              Positioned(
                bottom: 16.0,
                right: 16.0,
                child: FloatingActionButton(
                  onPressed: () {
                    isAddingPoints = true;
                  },
                  backgroundColor: settingsProvider.selectedPrimaryColour,
                  child: const Icon(Icons.add_rounded, color: Colors.black, size: 36.0),
                ),
              ),
              Positioned(
                top: 16.0,
                right: 16.0,
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {  
                      showHeatMap = !showHeatMap;
                    });
                  },
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  child: Icon(
                    showHeatMap? Icons.visibility_off_rounded : Icons.visibility_rounded, 
                    color: Colors.black.withOpacity(0.8), 
                    size: 36.0
                  ),
                ),
              ),
              Positioned(
                bottom: 16.0,
                left: 16.0,
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      _showTextInputDialog(context, locationSelectorProvider);
                    });
                  },
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  child: Icon(
                    showHeatMap? Icons.visibility_off_rounded : Icons.visibility_rounded, 
                    color: Colors.black.withOpacity(0.8), 
                    size: 36.0
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showTextInputDialog(BuildContext context, LocationSelectorProvider locationSelectorProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String inputText = '';
        return AlertDialog(
          title: const Text('Enter Location Name'),
          content: TextField(
            onChanged: (value) {
              inputText = value;
            },
            decoration: const InputDecoration(hintText: "Location Name"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Create'),
              onPressed: () {
                // Handle the input text here
                final center = _mapController.camera.center;
                final zoom = _mapController.camera.zoom;
                locationSelectorProvider.addLocation(center, inputText, zoom);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Color getColorForSpeed(double speed) {
  if (speed < 40) {
    return Colors.red;
  } else if (speed < 50) {
    return Colors.orange;
  } else if (speed < 60) {
    return Colors.yellow;
  } else {
    return Colors.green;
  }
}
}