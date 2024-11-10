import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schumacher/const/constant.dart';
import 'package:schumacher/data/csv_processor.dart';
import 'package:schumacher/data/settings_provider.dart';
import 'package:schumacher/widgets/dashboard_widget.dart';
import 'package:schumacher/widgets/side_menu_widget.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CsvProcessor csvProccessor = Provider.of<CsvProcessor>(context);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
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
                  child: DashboardWidget(),
              ),
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