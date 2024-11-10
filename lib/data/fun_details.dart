import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schumacher/data/csv_processor.dart';
import 'package:schumacher/model/fun_model.dart';

class FunDetails {
  late CsvProcessor csvProcessor;
  String speed = '';
  String totalTime = '';
  String totalDistance = '';
  late final List<FunModel> funData;
  
  FunDetails(BuildContext context) {
    csvProcessor = Provider.of<CsvProcessor>(context, listen: false);
    speed = csvProcessor.averageSpeed;
    totalTime = csvProcessor.totalTime;
    totalDistance = (csvProcessor.totalDistance / 1000).toStringAsFixed(2);
    funData = [
      FunModel(icon: const Icon(Icons.straighten_rounded,), value: "$totalDistance km", title: "Total Distance"),
      FunModel(icon: const Icon(Icons.timelapse_rounded,), value: totalTime, title: "Session Running Time"),
      FunModel(icon: const Icon(Icons.speed_rounded,), value: speed, title: "Average Speed"),
      FunModel(icon: const Icon(Icons.timer_rounded,), value: "00:52.43", title: "Average Pace"),
    ];
  } 
    
}