// import 'package:flutter/material.dart';
// import 'package:greentechhouse/stats/CO2Graph.dart';
// import 'package:greentechhouse/stats/HumidityGraphPage.dart';
// import 'package:greentechhouse/stats/LightIntensityGraph.dart';
// import 'package:greentechhouse/stats/SoilMoistureGraph.dart';
// import 'dashboard.dart';
// import 'login.dart';
// import '../stats/TemperatureGraphPage.dart'; // Correct relative path to TemperatureGraphPage.dart
// import 'package:firebase_auth/firebase_auth.dart';

// class StatsPage extends StatelessWidget {
//   Future<void> _logout(BuildContext context) async {
//     try {
//       await FirebaseAuth.instance.signOut();
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => LoginPage()),
//       );
//     } catch (e) {
//       print('Error signing out: $e');
//       // Handle sign-out errors here
//     }
//   }

//   void navigateToTemperatureGraph(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => TemperatureGraphPage()),
//     );
//   }

//   void navigateToHumidityGraph(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => HumidityGraphPage()),
//     );
//   }

//   void navigateToSoilMoistureGraph(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => SoilMoistureGraphPage()),
//     );
//   }

//   void navigateToLightIntensityGraph(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => LightIntensityGraphPage()),
//     );
//   }

//   void navigateToCO2Graph(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => CO2GraphPage()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Stats',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
//         ),
//         backgroundColor: Colors.green,
//         actions: [
//           IconButton(
//             icon: Icon(
//               Icons.notifications,
//               color: Colors.white,
//               size: 25,
//             ),
//             onPressed: () {
//               // Implement notification logic here
//             },
//           ),
//         ],
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             Container(
//               height: 120,
//               decoration: BoxDecoration(
//                 color: Colors.green,
//               ),
//               child: DrawerHeader(
//                 padding: EdgeInsets.zero,
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Text(
//                     'Menu',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.home),
//               title: Text(
//                 'Home',
//                 style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
//               ),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => DashboardPage()),
//                 );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.bar_chart),
//               title: Text(
//                 'Stats',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//               ),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => StatsPage()),
//                 );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.settings),
//               title: Text(
//                 'Controls',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//               ),
//               onTap: () {
//                 Navigator.pop(context);
//                 // Navigate to Controls section
//                 // Implement navigation logic for Controls
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.security),
//               title: Text(
//                 'Security Report',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//               ),
//               onTap: () {
//                 Navigator.pop(context);
//                 // Navigate to Security Report section
//                 // Implement navigation logic for Security Report
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.logout),
//               title: Text(
//                 'Logout',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//               ),
//               onTap: () => _logout(context),
//             ),
//           ],
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             SizedBox(height: 35.0),
//             StatButton(
//               title: 'Temperature',
//               icon: Icons.thermostat_outlined,
//               onPressed: () => navigateToTemperatureGraph(context),
//             ),
//             SizedBox(height: 16.0), // Add space between buttons
//             StatButton(
//               title: 'Humidity',
//               icon: Icons.water_damage_outlined,
//               onPressed: () => navigateToHumidityGraph(context),
//             ),
//             SizedBox(height: 16.0),
//             StatButton(
//               title: 'Soil Moisture',
//               icon: Icons.grass_outlined,
//               onPressed: () => navigateToSoilMoistureGraph(context),
//             ),
//             SizedBox(height: 16.0),
//             StatButton(
//               title: 'Light Intensity',
//               icon: Icons.wb_sunny_outlined,
//               onPressed: () => navigateToLightIntensityGraph(context),
//             ),
//             SizedBox(height: 16.0),
//             StatButton(
//               title: 'CO2 Percentage',
//               icon: Icons.cloud_outlined,
//               onPressed: () => navigateToCO2Graph(context),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class StatButton extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   final VoidCallback onPressed;

//   StatButton({
//     required this.title,
//     required this.icon,
//     required this.onPressed, // Declare onPressed as required
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       child: ElevatedButton.icon(
//         icon: Icon(icon, size: 24.0, color: Colors.white),
//         label: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Text(
//             title,
//             style: TextStyle(fontSize: 18, color: Colors.white),
//           ),
//         ),
//         onPressed: onPressed, // Use the provided onPressed callback
//         style: ButtonStyle(
//           backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
//           shadowColor: MaterialStateProperty.all<Color>(Colors.greenAccent),
//           elevation: MaterialStateProperty.all<double>(5),
//           padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
//             EdgeInsets.all(16.0),
//           ),
//           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//             RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12.0),
//             ),
//           ),
//           textStyle: MaterialStateProperty.all<TextStyle>(
//             TextStyle(fontSize: 18),
//           ),
//         ),
//       ),
//     );
//   }
// }
