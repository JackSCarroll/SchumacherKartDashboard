import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schumacher/data/location_selector_provider.dart';
import 'package:schumacher/data/settings_provider.dart';

class LocationSelectorWidget extends StatelessWidget {
  const LocationSelectorWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<LocationSelectorProvider>(context, listen: false).loadLocations(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 10,
            width: 10,
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          var locationSelectorProvider = Provider.of<LocationSelectorProvider>(context);
          var settingsProvider = Provider.of<SettingsProvider>(context);
          //Check if there are any locations loaded
          return locationSelectorProvider.hasNoLocations ? const Text('No locations saved') : DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: locationSelectorProvider.selectedLocation.name,
              items: locationSelectorProvider.locations.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.name,
                  child: Text(
                    entry.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: settingsProvider.selectedPrimaryColour,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  locationSelectorProvider.setSelectedLocation(locationSelectorProvider.locations.where((entry) => entry.name == newValue).first);
                }
              },
              underline: Container(
                height: 2,
                color: settingsProvider.selectedPrimaryColour,
              ),
              icon: Icon(Icons.arrow_drop_down, color: settingsProvider.selectedPrimaryColour),
            ),
          );
        }
      },
    );
  }
}