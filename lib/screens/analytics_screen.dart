import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schumacher/data/location_selector_provider.dart';
import 'package:schumacher/widgets/location_selector_widget.dart';
import 'package:schumacher/widgets/mini_map_widget.dart';
import 'package:schumacher/widgets/side_menu_widget.dart';
import 'package:schumacher/widgets/uploader_widget.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  
  @override
  Widget build(BuildContext context) {
    var locationSelectorProvider = Provider.of<LocationSelectorProvider>(context);

    final OverlayPortalController overlayPortalController = OverlayPortalController();

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
                      sectors: locationSelectorProvider.selectedLocation.sectors,
                    ),
                    const SizedBox(height: 16.0),
                    const Text('Upload CSV Data for this location'),
                    ElevatedButton(
                      onPressed: overlayPortalController.toggle,
                      child: OverlayPortal(
                        controller: overlayPortalController,
                        overlayChildBuilder: (BuildContext context) {
                          return Stack(children: [
                            BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                              child: Container(
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                            ModalBarrier(
                              color: Colors.black.withOpacity(0.5),
                              dismissible: false,
                            ),
                            Center(
                              child: Material(
                                elevation: 4.0,
                                child: UploaderWidget(
                                  onClose: () {
                                    overlayPortalController.toggle();
                                  },
                                ),
                              ),
                            ),
                          ]);
                        },
                        child: const Text('Upload Data'),
                      ),
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