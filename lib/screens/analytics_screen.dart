import 'package:flutter/material.dart';
import 'package:schumacher/const/constant.dart';
import 'package:schumacher/widgets/side_menu_widget.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

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
                  child: Text('Analytics Screen'),
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