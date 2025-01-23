import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:schumacher/data/fun_details.dart';
import 'package:schumacher/data/settings_provider.dart';
import 'package:schumacher/util/Responsive.dart';
import 'package:schumacher/widgets/custom_card_widget.dart';

class FunDetailsCard extends StatelessWidget {
  const FunDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    FunDetails funDetails = FunDetails(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return GridView.builder(
      itemCount: funDetails.funData.length,
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: Responsive.isMobile(context) ? 2 : 4,
        crossAxisSpacing: Responsive.isMobile(context) ? 12 : 15,
        mainAxisSpacing: 12.0,
      ),
      itemBuilder: (context, index) => CustomCard(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              funDetails.funData[index].icon.icon,
              color: settingsProvider.selectedPrimaryColour,
              size: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 4),
              child: Text(
                funDetails.funData[index].value,
                style: TextStyle(
                  fontSize: !Responsive.isDesktop(context) ? 18 : 14,
                  fontWeight: FontWeight.w600,
                  color: settingsProvider.selectedPrimaryColour,
                ),
              ),
            ),
            Text(
              funDetails.funData[index].title,
              style: GoogleFonts.orbitron(
                fontSize: !Responsive.isDesktop(context) ? 13 : 11,
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}