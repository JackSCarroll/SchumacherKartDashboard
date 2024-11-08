import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schumacher/const/constant.dart';
import 'package:schumacher/data/settings_provider.dart';

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({super.key});

  static const List colours = [
    'Blue',
    'Green',
    'Red',
    'Yellow',
    'Purple',
    'Pink'
  ];

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    return Column(
      children: [
        const SizedBox(height: 50),
        Text(
          'Settings',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w600,
            color: settingsProvider.selectedPrimaryColour,
          ),
        ),
        const SizedBox(height: 50),
        Row(
          children: [
            Text(
              'Accent Colour',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: settingsProvider.selectedPrimaryColour,
              ),
            ),
            const SizedBox(width: 20),
            SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: Container (
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: settingsProvider.selectedPrimaryColour,
                  width: 2.0,),
              ),
              child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: settingsProvider.selectedPrimaryColourName,
                    items: colours.map((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: colourMap[value] ?? settingsProvider.selectedPrimaryColour,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        settingsProvider.setSelectedColour(colours.indexOf(newValue.toString()));
                      }
                    },
                    underline: Container(
                      height: 2,
                      color: settingsProvider.selectedPrimaryColour,
                    ),
                    icon: Icon(Icons.arrow_drop_down, color: settingsProvider.selectedPrimaryColour),
                  ),
                ),
              ),
            ),
          ],
        ),
      ]
    );
  }
}