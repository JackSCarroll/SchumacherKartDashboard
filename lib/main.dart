import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:schumacher/const/constant.dart';
import 'package:schumacher/data/csv_processor.dart';
import 'package:schumacher/data/location_selector_provider.dart';
import 'package:schumacher/data/map_points_provider.dart';
import 'package:schumacher/data/settings_provider.dart';
import 'package:schumacher/data/side_menu_provider.dart';
import 'package:schumacher/firebase_options.dart';
import 'package:schumacher/screens/login_screen.dart';
import 'package:schumacher/screens/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GoogleFonts.pendingFonts([
          GoogleFonts.honk(),
          GoogleFonts.notoSans(),
          GoogleFonts.orbitron(),
        ]);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => CsvProcessor(), child: const MyApp(),),
      ChangeNotifierProvider(create: (context) => SideMenuProvider(), child: const MyApp(),),
      ChangeNotifierProvider(create: (context) => SettingsProvider(), child: const MyApp(),),
      ChangeNotifierProvider(create: (context) => MapPointsProvider(), child: const MyApp(),),
      ChangeNotifierProvider(create: (context) => LocationSelectorProvider(), child: const MyApp(),),
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
      initialRoute: '/',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/main': (context) => const MainScreen(),
      },
      home: FutureBuilder(
        future: Provider.of<CsvProcessor>(context, listen: false).loadCsvData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, authSnapshot) {
                if (authSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (authSnapshot.hasError) {
                  return Center(child: Text('Error: ${authSnapshot.error}'));
                } else {
                  if (authSnapshot.hasData) {
                    return const MainScreen();
                  } else {
                    return const LoginScreen();
                  }
                }
              },
            );
          }
        },
      ),
    );
  }
}
