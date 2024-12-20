import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schumacher/const/constant.dart';
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
          return locationSelectorProvider.hasNoLocations ? const Text('No locations saved') : LayoutBuilder(
            builder: (context, constraints) {
              double setWidth = constraints.maxWidth * 0.8;
              return SizedBox(
                width: setWidth,
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      iconColor: settingsProvider.selectedPrimaryColour,
                      filled: true,
                      fillColor: cardBackgroundColour,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    ),
                    alignment: Alignment.center,
                    isExpanded: true,
                    dropdownColor: cardBackgroundColour,
                    elevation: 8,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    value: locationSelectorProvider.selectedLocation.name,
                    items: locationSelectorProvider.locations.map((entry) {
                      return DropdownMenuItem<String>(
                        value: entry.name,
                        alignment: Alignment.center,
                        child: Text(
                          entry.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: settingsProvider.selectedPrimaryColour,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        locationSelectorProvider.setSelectedLocation(locationSelectorProvider.locations.where((entry) => entry.name == newValue).first);
                      }
                    },
                    icon: Icon(Icons.arrow_drop_down, color: settingsProvider.selectedPrimaryColour),
                  ),
                ),
              );
            }
          );
        }
      },
    );
  }
}