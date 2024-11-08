import 'package:flutter/material.dart';
import 'package:schumacher/const/constant.dart';

class SettingsProvider with ChangeNotifier {
  Color _selectedPrimaryColour = bluePrimaryColour;
  String _selectedPrimaryColourName = 'Blue';

  Color get selectedPrimaryColour => _selectedPrimaryColour;
  String get selectedPrimaryColourName => _selectedPrimaryColourName;

  void setSelectedColour(int index) {
    switch (index) {
      case 0:
        _selectedPrimaryColour = bluePrimaryColour;
        _selectedPrimaryColourName = 'Blue';
        break;
      case 1:
        _selectedPrimaryColour = greenPrimaryColor;
        _selectedPrimaryColourName = 'Green';
        break;
      case 2:
        _selectedPrimaryColour = redPrimaryColour;
        _selectedPrimaryColourName = 'Red';
        break;
      case 3:
        _selectedPrimaryColour = yellowPrimaryColour;
        _selectedPrimaryColourName = 'Yellow';
        break;
      case 4:
        _selectedPrimaryColour = purplePrimaryColour;
        _selectedPrimaryColourName = 'Purple';
        break;
      case 5:
        _selectedPrimaryColour = pinkPrimaryColour;
        _selectedPrimaryColourName = 'Pink';
        break;
      default:
        _selectedPrimaryColour = bluePrimaryColour;
        _selectedPrimaryColourName = 'Blue';
    }
    notifyListeners();
  }
}