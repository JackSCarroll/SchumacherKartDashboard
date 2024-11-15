import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schumacher/data/location_selector_provider.dart';
import 'package:schumacher/widgets/location_selector_widget.dart';
import 'package:schumacher/widgets/mini_map_widget.dart';
import 'package:schumacher/widgets/side_menu_widget.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final locationSelectorProvider = Provider.of<LocationSelectorProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            const Expanded(
              flex: 2, 
              child: SizedBox(
                child: SideMenuWidget(),
              ),
            ),
            const Expanded(
              flex: 5,
              child: Text('Analytics Screen'),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: locationSelectorProvider.hasNoLocations
                ? const Center(child: Text('No locations available'))
                : Column(
                  children: [
                    const LocationSelectorWidget(),
                    MiniMapWidget(
                      latLngCenter: locationSelectorProvider.selectedLocation.entries.first.key,
                      zoom: locationSelectorProvider.selectedLocation.entries.first.value.zoom,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}