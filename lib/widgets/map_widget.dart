import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:provider/provider.dart';
import 'package:schumacher/data/settings_provider.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  List<List<LatLng>> points = [];
  bool isAddingPoints = false;
  int tempPointCounter = 0;
  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<SettingsProvider>(context);
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
                options: MapOptions(
                  // Todo: Change the initial center to the location of your choice
                  initialCenter: const LatLng(-38.059252616021844, 144.3833972600851),
                  initialZoom: 18.5,
                  onTap: (tapPosition, point) {
                    print("Tapped: $point");
                    if(isAddingPoints) {
                      setState(() {
                        if(tempPointCounter == 0) {
                          points.add([point]);
                          tempPointCounter++;
                        } else {
                          points.last.add(point);
                          tempPointCounter = 0;
                          isAddingPoints = false;
                        }
                      });
                    } else {
                      setState(() {
                        print("Points: $points");
                      });
                    }
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'dev.jackscarroll.schumacher_dashboard',
                    tileProvider: CancellableNetworkTileProvider(),
                  ),
                  PolylineLayer(
                    polylines: points.map((pair) {
                      return Polyline(
                        points: pair,
                        strokeWidth: 4.0,
                        color: settingsProvider.selectedPrimaryColour,
                      );
                    }).toList(),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}