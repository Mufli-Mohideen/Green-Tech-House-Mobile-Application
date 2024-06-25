// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'dashboard.dart'; // Make sure this path is correct
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:greentechhouse/pages/login.dart';

// class ControlsPage extends StatefulWidget {
//   const ControlsPage({Key? key}) : super(key: key);

//   @override
//   _ControlsPageState createState() => _ControlsPageState();
// }

// class _ControlsPageState extends State<ControlsPage> {
//   final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
//   Map<String, dynamic> _controlsData = {
//     'bulb': false,
//     'fan': false,
//     'pump': false,
//   };

//   @override
//   void initState() {
//     super.initState();
//     _fetchControlsData();
//   }

//   Future<void> _fetchControlsData() async {
//     try {
//       DatabaseEvent event = await _databaseReference.child('Controls').once();
//       if (event.snapshot.value != null) {
//         Map<String, dynamic> data = Map<String, dynamic>.from(
//             event.snapshot.value as Map<dynamic, dynamic>);
//         setState(() {
//           _controlsData = data;
//         });
//       }
//     } catch (e) {
//       print('Error fetching controls data: $e');
//     }
//   }

//   Future<void> _updateControl(String control, bool value) async {
//     try {
//       await _databaseReference.child('controls/$control').set(value);
//       _fetchControlsData(); // Refresh the data after updating
//     } catch (e) {
//       print('Error updating control $control: $e');
//     }
//   }

//   Future<void> _logout(BuildContext context) async {
//     try {
//       await FirebaseAuth.instance.signOut();
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => LoginPage()),
//       );
//     } catch (e) {
//       print('Error signing out: $e');
//     }
//   }

//   Widget _buildDrawer(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: <Widget>[
//           Container(
//             height: 100,
//             decoration:
//                 const BoxDecoration(color: Color.fromARGB(255, 13, 32, 13)),
//             child: const DrawerHeader(
//               padding: EdgeInsets.zero,
//               child: Padding(
//                 padding: EdgeInsets.all(20.0),
//                 child: Text(
//                   'Menu',
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//           ),
//           _buildDrawerItem(
//             context,
//             icon: Icons.home,
//             title: 'Home',
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.pushReplacement(context,
//                   MaterialPageRoute(builder: (context) => DashboardPage()));
//             },
//           ),
//           _buildDrawerItem(
//             context,
//             icon: Icons.settings,
//             title: 'Controls',
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.pushReplacement(context,
//                   MaterialPageRoute(builder: (context) => ControlsPage()));
//             },
//           ),
//           _buildDrawerItem(
//             context,
//             icon: Icons.security,
//             title: 'Security Report',
//             onTap: () {
//               Navigator.pop(context);
//               // Implement navigation logic for Security Report
//             },
//           ),
//           _buildDrawerItem(
//             context,
//             icon: Icons.logout,
//             title: 'Logout',
//             onTap: () => _logout(context),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDrawerItem(BuildContext context,
//       {required IconData icon,
//       required String title,
//       required VoidCallback onTap}) {
//     return ListTile(
//       leading: Icon(icon, color: Color.fromARGB(255, 0, 0, 0)),
//       title: Text(
//         title,
//         style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//       ),
//       onTap: onTap,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Controls',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Color.fromARGB(255, 13, 32, 13),
//         leading: Builder(
//           builder: (BuildContext context) {
//             return IconButton(
//               icon: Icon(Icons.menu, color: Colors.white),
//               onPressed: () {
//                 Scaffold.of(context).openDrawer();
//               },
//             );
//           },
//         ),
//       ),
//       drawer: _buildDrawer(context),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: GridView.count(
//           crossAxisCount: 2,
//           crossAxisSpacing: 16.0,
//           mainAxisSpacing: 16.0,
//           children: [
//             _buildControlCard(
//               control: 'bulb',
//               value: _controlsData['bulb'] ?? false,
//               icon: Icons.lightbulb,
//               onTap: () =>
//                   _updateControl('bulb', !(_controlsData['bulb'] ?? false)),
//               color: Colors.yellow,
//             ),
//             _buildControlCard(
//               control: 'fan',
//               value: _controlsData['fan'] ?? false,
//               icon: Icons.air,
//               onTap: () =>
//                   _updateControl('fan', !(_controlsData['fan'] ?? false)),
//               color: Colors.blue,
//             ),
//             _buildControlCard(
//               control: 'pump',
//               value: _controlsData['pump'] ?? false,
//               icon: Icons.invert_colors,
//               onTap: () =>
//                   _updateControl('pump', !(_controlsData['pump'] ?? false)),
//               color: Colors.green,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildControlCard({
//     required String control,
//     required bool value,
//     required IconData icon,
//     required VoidCallback onTap,
//     required Color color,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         color: Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15.0),
//         ),
//         elevation: 5,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon,
//                 color: value ? Color.fromARGB(255, 13, 32, 13) : Colors.grey,
//                 size: 50),
//             const SizedBox(height: 10),
//             Text(
//               control.toUpperCase(),
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w500,
//                 color: value ? Color.fromARGB(255, 13, 32, 13) : Colors.grey,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Switch(
//               value: value,
//               onChanged: (bool newValue) => onTap(),
//               activeColor: Color.fromARGB(255, 13, 32, 13),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dashboard.dart'; // Make sure this path is correct
import 'package:firebase_auth/firebase_auth.dart';
import 'package:greentechhouse/pages/login.dart';

class ControlsPage extends StatefulWidget {
  const ControlsPage({Key? key}) : super(key: key);

  @override
  _ControlsPageState createState() => _ControlsPageState();
}

class _ControlsPageState extends State<ControlsPage> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  Map<String, dynamic> _controlsData = {
    'bulb': 0,
    'fan': 0,
    'pump': 0,
  };

  @override
  void initState() {
    super.initState();
    _fetchControlsData();
  }

  Future<void> _fetchControlsData() async {
    try {
      DatabaseEvent event = await _databaseReference.child('Controls').once();
      if (event.snapshot.value != null) {
        Map<String, dynamic> data = Map<String, dynamic>.from(
            event.snapshot.value as Map<dynamic, dynamic>);
        setState(() {
          _controlsData = data;
        });
      }
    } catch (e) {
      print('Error fetching controls data: $e');
    }
  }

  Future<void> _updateControl(String control, int value) async {
    try {
      await _databaseReference.child('Controls/$control').set(value);
      _fetchControlsData(); // Refresh the data after updating
    } catch (e) {
      print('Error updating control $control: $e');
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Controls',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 13, 32, 13),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
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
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            _buildControlCard(
              control: 'bulb',
              value: _controlsData['bulb'] ?? 0,
              icon: Icons.lightbulb,
              onTap: () => _updateControl(
                  'bulb', (_controlsData['bulb'] ?? 0) == 1 ? 0 : 1),
              color: Colors.yellow,
            ),
            _buildControlCard(
              control: 'fan',
              value: _controlsData['fan'] ?? 0,
              icon: Icons.air,
              onTap: () => _updateControl(
                  'fan', (_controlsData['fan'] ?? 0) == 1 ? 0 : 1),
              color: Colors.blue,
            ),
            _buildControlCard(
              control: 'pump',
              value: _controlsData['pump'] ?? 0,
              icon: Icons.invert_colors,
              onTap: () => _updateControl(
                  'pump', (_controlsData['pump'] ?? 0) == 1 ? 0 : 1),
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlCard({
    required String control,
    required int value,
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color:
                    value == 1 ? Color.fromARGB(255, 13, 32, 13) : Colors.grey,
                size: 50),
            const SizedBox(height: 10),
            Text(
              control.toUpperCase(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color:
                    value == 1 ? Color.fromARGB(255, 13, 32, 13) : Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            Switch(
              value: value == 1,
              onChanged: (bool newValue) => onTap(),
              activeColor: Color.fromARGB(255, 13, 32, 13),
            ),
          ],
        ),
      ),
    );
  }
}
