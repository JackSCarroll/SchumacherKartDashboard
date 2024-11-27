import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:schumacher/widgets/location_editor_widget.dart';
import 'package:schumacher/widgets/map_widget.dart';
import 'package:schumacher/widgets/side_menu_widget.dart';
import 'package:schumacher/widgets/uploader_widget.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => LocationScreenState();
}

class LocationScreenState extends State<LocationScreen> {
  final OverlayPortalController _overlayPortalController =
      OverlayPortalController();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SafeArea(
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: SizedBox(
              child: SideMenuWidget(),
            ),
          ),
          Expanded(
            flex: 5,
            child: MapWidget(),
          ),
          Expanded(
            flex: 3,
            child: LocationEditorWidget(),
          ),
        ],
      ),
    ));
  }
}

//ElevatedButton(
//              onPressed: _overlayPortalController.toggle,
//              child: OverlayPortal(
//                controller: _overlayPortalController,
//                overlayChildBuilder: (BuildContext context) {
//                  return Stack(children: [
//                    BackdropFilter(
//                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
//                      child: Container(
//                        color: Colors.black.withOpacity(0.5),
//                      ),
//                    ),
//                    ModalBarrier(
//                      color: Colors.black.withOpacity(0.5),
//                      dismissible: false,
//                    ),
//                    Center(
//                      child: Material(
//                        elevation: 4.0,
//                        child: UploaderWidget(
//                          onClose: () {
//                            _overlayPortalController.toggle();
//                          },
//                        ),
//                      ),
//                    ),
//                  ]);
//                },
//                child: const Text('Upload Data'),
//              ),
//            ),
//