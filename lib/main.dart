import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schumacher/const/constant.dart';
import 'package:schumacher/data/csv_processor.dart';
import 'package:schumacher/data/settings_provider.dart';
import 'package:schumacher/data/side_menu_provider.dart';
import 'package:schumacher/firebase_options.dart';
import 'package:schumacher/screens/main_screen.dart';

Future<void> main() async {

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => CsvProcessor()),
      ChangeNotifierProvider(create: (context) => SideMenuProvider(), child: const MyApp(),),
      ChangeNotifierProvider(create: (context) => SettingsProvider(), child: const MyApp(),),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Schumacher Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: Provider.of<CsvProcessor>(context, listen: false).loadCsvData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return const MainScreen();
          }
        },
      ),
    );
  }
}
