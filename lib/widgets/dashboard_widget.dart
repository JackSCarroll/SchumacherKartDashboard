import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:schumacher/data/settings_provider.dart';
import 'package:schumacher/util/Responsive.dart';
import 'package:schumacher/widgets/fun_details_card.dart';
import 'package:schumacher/widgets/line_chart_card.dart';
import 'package:schumacher/widgets/location_selector_widget.dart';

class DashboardWidget extends StatelessWidget {
  const DashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    return SingleChildScrollView(
      child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        children: [
          const SizedBox(height: 50),
          Row(
            children: [
              if(!Responsive.isDesktop(context))
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: InkWell(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                        Icons.menu,
                        color: settingsProvider.selectedPrimaryColour,
                        size: 25,
                      ),
                    ),    
                  ),
                ),
              const Expanded (
                child: LocationSelectorWidget(),
              ),
            ],
          ),
          const SizedBox(height: 50),
          Text(
            'Fun Stats',
            style: GoogleFonts.orbitron(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: settingsProvider.selectedPrimaryColour,
            ),
          ),
          const FunDetailsCard(),
          const SizedBox(height: 50),
          Text(
            'Latest Session Speed/Time',
            style: GoogleFonts.orbitron(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: settingsProvider.selectedPrimaryColour,
            ),
          ),
          const LineChartCard(),
          ],
        ),
      ),
    );
  }
}