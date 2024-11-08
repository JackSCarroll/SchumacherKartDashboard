import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schumacher/data/settings_provider.dart';
import 'package:schumacher/data/side_menu_data.dart';
import 'package:schumacher/data/side_menu_provider.dart';
import 'package:schumacher/screens/analytics_screen.dart';
import 'package:schumacher/screens/location_screen.dart';
import 'package:schumacher/screens/main_screen.dart';
import 'package:schumacher/screens/settings_screen.dart';

class SideMenuWidget extends StatefulWidget {
  const SideMenuWidget({super.key});

  @override
  State<SideMenuWidget> createState() => _SideMenuWidgetState();
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final sideMenuProvider = Provider.of<SideMenuProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final data = SideMenuData();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      child: ListView.builder(
        itemCount: data.menu.length,
        itemBuilder:(context, index) => buildMenuEntry(data, index, sideMenuProvider, settingsProvider),
      )
    );
  }

  Widget buildMenuEntry(SideMenuData data, int index, SideMenuProvider sideMenuProvider, SettingsProvider settingsProvider) {
    final isSelected = sideMenuProvider.selectedIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: isSelected ? settingsProvider.selectedPrimaryColour : Colors.transparent,
        borderRadius: const BorderRadius.all(Radius.circular(6.0)),
      ),
      child: InkWell(
          onTap: () { 
            sideMenuProvider.setSelectedIndex(index);
            naviageToScreen(index);
          },
          child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
              child: Icon(data.menu[index].icon, color: isSelected ? Colors.black : settingsProvider.selectedPrimaryColour,),
            ),        
            Text(data.menu[index].title, style: TextStyle(fontSize: 16, color: isSelected ? Colors.black : settingsProvider.selectedPrimaryColour, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal),),
          ],
        ),
      ),
    );
  }

  void naviageToScreen(int index) {
    switch(index) {
      case 0:
        Navigator.push(context, PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => const MainScreen(),
            transitionDuration: Duration.zero,
          ),
        );
        break;
      case 1:
        // Navigate to Analytics
        Navigator.push(context, PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => const AnalyticsScreen(),
            transitionDuration: Duration.zero,
          ),
        );
        break;
      case 2:
        // Navigate to Location
        Navigator.push(context, PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => const LocationScreen(),
            transitionDuration: Duration.zero,
          ),
        );
        break;
      case 3:
        // Navigate to Settings
        Navigator.push(context, PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => const SettingsScreen(),
            transitionDuration: Duration.zero,
          ),
        );
        break;
    }
  }
}