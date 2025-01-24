import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schumacher/const/constant.dart';
import 'package:schumacher/data/data_selector_provider.dart';
import 'package:schumacher/data/settings_provider.dart';

class DataSelectorWidget extends StatefulWidget {
  final String locationUid;
  const DataSelectorWidget({super.key, required this.locationUid});

  @override
  State<DataSelectorWidget> createState() => _DataSelectorWidget();
}

class _DataSelectorWidget extends State<DataSelectorWidget> {
  late Future<void> _loadDataSetsFuture;

  @override
  void initState() {
    super.initState();
    var dataSelectorProvider = Provider.of<DataSelectorProvider>(context, listen: false);
    _loadDataSetsFuture = dataSelectorProvider.loadDataSetNames(widget.locationUid);
  }

  @override
  Widget build(BuildContext context) {

    // Check if there is a selectedLocation
    if(widget.locationUid == null || widget.locationUid.isEmpty) {
      return const Text('No location selected');
    }

    return FutureBuilder(
      future: _loadDataSetsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 10,
            width: 10,
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          var dataSelectorProvider = Provider.of<DataSelectorProvider>(context);
          var settingsProvider = Provider.of<SettingsProvider>(context);
          //Check if there are any locations loaded
          return dataSelectorProvider.hasNoData ? const Text('No data saved') : LayoutBuilder(
            builder: (context, constraints) {
              double setWidth = constraints.maxWidth * 0.8;
              return SizedBox(
                width: setWidth,
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      iconColor: settingsProvider.selectedPrimaryColour,
                      filled: true,
                      fillColor: cardBackgroundColour,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    ),
                    alignment: Alignment.center,
                    isExpanded: true,
                    dropdownColor: cardBackgroundColour,
                    elevation: 8,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    value: dataSelectorProvider.selectedDataSet,
                    items: dataSelectorProvider.dataSets.map((entry) {
                      return DropdownMenuItem<String>(
                        value: entry,
                        alignment: Alignment.center,
                        child: Text(
                          entry,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: settingsProvider.selectedPrimaryColour,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        dataSelectorProvider.setSelectedDataSet(dataSelectorProvider.dataSets.where((entry) => entry == newValue).first);
                      }
                    },
                    icon: Icon(Icons.arrow_drop_down, color: settingsProvider.selectedPrimaryColour),
                  ),
                ),
              );
            }
          );
        }
      },
    );
  }
}