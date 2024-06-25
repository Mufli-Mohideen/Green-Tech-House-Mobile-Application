// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:intl/intl.dart';

// class ReportPage extends StatefulWidget {
//   const ReportPage({Key? key}) : super(key: key);

//   @override
//   _ReportPageState createState() => _ReportPageState();
// }

// class _ReportPageState extends State<ReportPage> {
//   final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
//   List<DateTime> _detectionTimes = [];

//   @override
//   void initState() {
//     super.initState();
//     _monitorPIRSensor();
//   }

//   void _monitorPIRSensor() {
//     _databaseReference.child('Sensors/pir').onValue.listen((event) {
//       final value = event.snapshot.value;
//       if (value == 1) {
//         setState(() {
//           _detectionTimes.add(DateTime.now());
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Security Report',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Color.fromARGB(255, 13, 32, 13),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: _detectionTimes.isNotEmpty
//             ? ListView.builder(
//                 itemCount: _detectionTimes.length,
//                 itemBuilder: (context, index) {
//                   final detectionTime = _detectionTimes[index];
//                   return Card(
//                     color: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15.0),
//                     ),
//                     elevation: 10,
//                     margin: const EdgeInsets.symmetric(vertical: 8.0),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Icon(Icons.warning_amber_rounded,
//                                   size: 40, color: Colors.redAccent),
//                               const SizedBox(width: 10),
//                               const Text(
//                                 'Motion Detected!',
//                                 style: TextStyle(
//                                   fontSize: 24,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 10),
//                           Text(
//                             'Detected at: ${DateFormat('yyyy-MM-dd – kk:mm:ss').format(detectionTime)}',
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.black54,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               )
//             : const Center(
//                 child: Text(
//                   'No Motion Detected',
//                   style: TextStyle(fontSize: 24, color: Colors.black54),
//                 ),
//               ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'dashboard.dart';
import 'controls.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:greentechhouse/pages/login.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  List<DateTime> _detectionTimes = [];

  @override
  void initState() {
    super.initState();
    _monitorPIRSensor();
  }

  void _monitorPIRSensor() {
    _databaseReference.child('Sensors/pir').onValue.listen((event) {
      final value = event.snapshot.value;
      if (value == 1) {
        setState(() {
          _detectionTimes.add(DateTime.now());
        });
      }
    });
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 100,
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 13, 32, 13)),
            child: const DrawerHeader(
              padding: EdgeInsets.zero,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Menu',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.home,
            title: 'Home',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => DashboardPage()));
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.settings,
            title: 'Controls',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => ControlsPage()));
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.security,
            title: 'Security Report',
            onTap: () {
              Navigator.pop(context);
              // Implement navigation logic for Security Report
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.logout,
            title: 'Logout',
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Color.fromARGB(255, 0, 0, 0)),
      title: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
    );
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Security Report',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 13, 32, 13),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: _buildDrawer(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _detectionTimes.isNotEmpty
            ? ListView.builder(
                itemCount: _detectionTimes.length,
                itemBuilder: (context, index) {
                  final detectionTime = _detectionTimes[index];
                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 10,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.warning_amber_rounded,
                                  size: 40, color: Colors.redAccent),
                              const SizedBox(width: 10),
                              const Text(
                                'Motion Detected!',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Detected at: ${DateFormat('yyyy-MM-dd – kk:mm:ss').format(detectionTime)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : const Center(
                child: Text(
                  'No Motion Detected',
                  style: TextStyle(fontSize: 24, color: Colors.black54),
                ),
              ),
      ),
    );
  }
}
