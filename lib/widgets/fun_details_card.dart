import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schumacher/data/fun_details.dart';
import 'package:schumacher/data/settings_provider.dart';
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
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 15,
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
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: settingsProvider.selectedPrimaryColour,
                ),
              ),
            ),
            Text(
              funDetails.funData[index].title,
              style: const TextStyle(
                fontSize: 13,
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