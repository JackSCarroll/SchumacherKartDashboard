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

  OverlayEntry? _overlayEntry;

    OverlayEntry _createOverlayEntry() {
      return OverlayEntry(
        builder: (context) => Stack(
          children: [
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
                    _overlayEntry?.remove();
                    _overlayEntry = null;
                  },
                ),
              ),
            ),
          ]
        ),
      );
    }
    void _showOverlay() {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    }
  final OverlayPortalController _overlayPortalController = OverlayPortalController();
  
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
            Expanded(
              flex: 5,
              child: ElevatedButton(
                onPressed: _overlayPortalController.toggle, 
                child: OverlayPortal(
                  controller: _overlayPortalController, 
                  overlayChildBuilder: (BuildContext context) {
                    return Stack(
                      children: [
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
                                _overlayPortalController.toggle();
                              },
                            ),
                          ),
                        ),
                      ]
                    );
                  },
                  child: const Text('Upload Data'),
                ),
              ),
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