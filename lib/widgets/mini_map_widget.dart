import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:schumacher/data/csv_processor.dart';
import 'package:schumacher/data/map_points_provider.dart';
import 'package:schumacher/data/settings_provider.dart';

class MiniMapWidget extends StatefulWidget{
  final LatLng latLngCenter;
  final double zoom;
  const MiniMapWidget({super.key, required this.latLngCenter, required this.zoom});

  @override
  State<MiniMapWidget> createState() => _MiniMapWidgetState();
}

class _MiniMapWidgetState extends State<MiniMapWidget> {

  bool showHeatMap = false;

  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<SettingsProvider>(context);
    var csvProvider = Provider.of<CsvProcessor>(context);
    var pointsProvider = Provider.of<MapPointsProvider>(context);
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth;
        //final LatLngBounds bounds = calculateBounds(widget.latLngCenter, widget.zoom, size, size);
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            children: [
              Container(
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
                  child: FlutterMap(
                    options: MapOptions(
                      //cameraConstraint: CameraConstraint.containCenter(bounds: bounds),
                      initialCenter: widget.latLngCenter,
                      initialZoom: 18,
                      minZoom: 18,
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
              )
            ],
          ),
        );
      },
    );
  }
  
  LatLngBounds calculateBounds(LatLng center, double zoom, double mapWidth, double mapHeight) {
    // Constants for Earth's radius and conversion factors
    const double earthRadius = 6378137.0;
    const double initialResolution = 2 * 3.141592653589793 * earthRadius / 256.0;

    // Calculate resolution based on zoom level
    double resolution = initialResolution / (1 << zoom.toInt());

    // Calculate lat/lng deltas based on map size and resolution
    double latDelta = (mapHeight * resolution) / earthRadius;
    double lngDelta = ((mapWidth * resolution) / (earthRadius * 3.141592653589793 / 180.0)) + 0.000001;

    // Calculate bounds
    LatLngBounds bounds = LatLngBounds(
      LatLng(center.latitude - latDelta, center.longitude - lngDelta),
      LatLng(center.latitude + latDelta, center.longitude + lngDelta),
    );

    return bounds;
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
