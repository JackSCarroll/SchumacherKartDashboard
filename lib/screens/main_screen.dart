import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schumacher/const/constant.dart';
import 'package:schumacher/data/csv_processor.dart';
import 'package:schumacher/data/settings_provider.dart';
import 'package:schumacher/util/Responsive.dart';
import 'package:schumacher/widgets/dashboard_widget.dart';
import 'package:schumacher/widgets/side_menu_widget.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final isDesktop = Responsive.isDesktop(context);
    CsvProcessor csvProccessor = Provider.of<CsvProcessor>(context);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return Scaffold(
      // Show a drawer for non-desktop devices
      drawer: !isDesktop
          ? const SizedBox(
              width: 250,
              child: SideMenuWidget(),
            )
          :null,
      body: SafeArea(
        child: Row(
          children: [
            // Show a side menu for desktop devices
            if (isDesktop)
              const Expanded(
                  flex: 2, 
                  child: SizedBox(
                    child: SideMenuWidget(),
                  ),
              ),
              // Show the main dashboard content
                const Expanded(
                  flex: 5,
                  child: DashboardWidget(),
              ),
              // Additional Space for desktop devices
              if (isDesktop)
                Expanded(
                  flex: 3,
                  child: Container(
                    color: backgroundColor,
                    child: Stack(
                      children: [
                        Positioned(
                            top: 16.0,
                            right: 16.0,
                            child: FloatingActionButton(
                              onPressed: () {
                                csvProccessor.refreshData();
                              },
                              backgroundColor: settingsProvider.selectedPrimaryColour,
                              child: const Icon(Icons.refresh_rounded, color: Colors.black, size: 36.0),
                          ),
                        ),
                      ],
                    ),
                ),
              ),
            ],
          ),
        )
      );
  }
}