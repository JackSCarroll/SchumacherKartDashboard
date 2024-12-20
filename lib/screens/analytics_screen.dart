import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schumacher/data/location_selector_provider.dart';
import 'package:schumacher/widgets/location_selector_widget.dart';
import 'package:schumacher/widgets/mini_map_widget.dart';
import 'package:schumacher/widgets/side_menu_widget.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  
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
                child: Column(
                  children: [
                    const LocationSelectorWidget(),
                    const SizedBox(height: 16.0),
                    MiniMapWidget(
                      latLngCenter: locationSelectorProvider.selectedLocation.latLng,
                      zoom: locationSelectorProvider.selectedLocation.zoom,
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