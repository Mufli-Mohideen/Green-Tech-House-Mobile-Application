import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:greentechhouse/pages/login.dart';
import 'package:greentechhouse/pages/signup.dart';
import 'package:greentechhouse/pages/dashboard.dart';
// import 'package:greentechhouse/pages/stats.dart';
import 'package:greentechhouse/stats/CO2Graph.dart';
import 'package:greentechhouse/stats/HumidityGraphPage.dart';
import 'package:greentechhouse/stats/LightIntensityGraph.dart';
import 'package:greentechhouse/stats/SoilMoistureGraph.dart';
import 'package:greentechhouse/stats/TemperatureGraphPage.dart';
import 'package:greentechhouse/pages/controls.dart';
import 'package:greentechhouse/pages/report.dart';
// Import the DashboardPage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Green Tech House',
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system, // Use system theme by default
      home: const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(), // Add the SignUpPage route
        '/dashboard': (context) => const DashboardPage(),
        // '/stat': (context) => StatsPage(),
        '/TemperatureGraphPage': (context) => TemperatureGraphPage(),
        '/HumidityGraphPage': (context) => HumidityGraphPage(),
        '/SoilMoistureGraphPage': (context) => SoilMoistureGraphPage(),
        '/LightIntensityGraphPage': (context) => LightIntensityGraphPage(),
        '/CO2GraphPage': (context) => CO2GraphPage(),
        '/ControlsPage': (context) => const ControlsPage(),
        '/ReportPage': (context) => const ReportPage(),
        // Define other routes here
      },
    );
  }
}
