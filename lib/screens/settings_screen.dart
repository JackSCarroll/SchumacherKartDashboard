import 'package:flutter/material.dart';
import 'package:schumacher/const/constant.dart';
import 'package:schumacher/widgets/settings_widget.dart';
import 'package:schumacher/widgets/side_menu_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  child: SettingsWidget(),
              ),
                Expanded(
                  flex: 3,
                  child: Container(color: backgroundColor),
              ),
            ],
          ),
        )
      );
  }
}