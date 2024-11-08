import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schumacher/data/settings_provider.dart';
import 'package:schumacher/widgets/fun_details_card.dart';
import 'package:schumacher/widgets/header_widget.dart';
import 'package:schumacher/widgets/line_chart_card.dart';

class DashboardWidget extends StatelessWidget {
  const DashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    return Column(
      children: [
        const SizedBox(height: 50),
        const HeaderWidget(),
        const SizedBox(height: 50),
        Text(
          'Fun Stats',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: settingsProvider.selectedPrimaryColour,
          ),
        ),
        const FunDetailsCard(),
        const SizedBox(height: 50),
        Text(
          'Session Speed/Time',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: settingsProvider.selectedPrimaryColour,
          ),
        ),
        const LineChartCard(),
      ]
    );
  }
}