import 'package:flutter/material.dart';
import 'package:schumacher/model/menu_model.dart';

class SideMenuData {
  final menu = const <MenuModel>[
    MenuModel(icon: Icons.home_rounded, title: 'Dashboard'),
    MenuModel(icon: Icons.query_stats_rounded, title: 'Analytics'),
    MenuModel(icon: Icons.location_pin, title: 'Location'),
    MenuModel(icon: Icons.settings_rounded, title: 'Settings'),
  ];
}