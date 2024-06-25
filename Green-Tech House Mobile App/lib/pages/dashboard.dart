import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:greentechhouse/pages/report.dart';
import '../services/firebase_service.dart';
import 'login.dart';
// import 'stats.dart';
import 'package:greentechhouse/widgets/download.dart';
import 'package:greentechhouse/stats/CO2Graph.dart';
import 'package:greentechhouse/stats/HumidityGraphPage.dart';
import 'package:greentechhouse/stats/LightIntensityGraph.dart';
import 'package:greentechhouse/stats/SoilMoistureGraph.dart';
import 'package:greentechhouse/stats/TemperatureGraphPage.dart';
import 'package:greentechhouse/pages/controls.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late StreamController<Map<String, dynamic>> _streamController;
  late Timer _timer;
  bool _isLowTemperatureNotified = false;
  bool _isHighTemperatureNotified = false;
  bool _isCriticalTemperatureNotified = false;

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<Map<String, dynamic>>();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _fetchSensorData();
    });
  }

  @override
  void dispose() {
    _streamController.close();
    _timer.cancel();
    super.dispose();
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

  Future<void> _fetchSensorData() async {
    try {
      Map<String, dynamic> data = await FirebaseService().getSensorData();
      _streamController.add(data);
      _checkTemperatureNotifications(data);
    } catch (e) {
      print('Error fetching sensor data: $e');
    }
  }

  void _checkTemperatureNotifications(Map<String, dynamic> data) {
    if (data['temperature'] != null) {
      double temperature = (data['temperature'] as num).toDouble();
      bool notifyLow = false;
      bool notifyHigh = false;
      bool notifyCritical = false;

      if (temperature < 18 && !_isLowTemperatureNotified) {
        notifyLow = true;
      } else if (temperature > 24 &&
          temperature <= 30 &&
          !_isHighTemperatureNotified) {
        notifyHigh = true;
      } else if (temperature > 30 && !_isCriticalTemperatureNotified) {
        notifyCritical = true;
      }

      if (notifyLow || notifyHigh || notifyCritical) {
        setState(() {
          _isLowTemperatureNotified = notifyLow;
          _isHighTemperatureNotified = notifyHigh;
          _isCriticalTemperatureNotified = notifyCritical;
        });

        if (notifyLow) {
          _showLowTemperatureNotification();
        } else if (notifyHigh) {
          _showHighTemperatureNotification();
        } else if (notifyCritical) {
          _showCriticalTemperatureNotification();
        }
      }
    }
  }

  void _clearNotifications() {
    setState(() {
      _isLowTemperatureNotified = false;
      _isHighTemperatureNotified = false;
      _isCriticalTemperatureNotified = false;
    });
  }

  void _showLowTemperatureNotification() {
    Flushbar(
      title: 'Low Temperature Alert',
      message: 'Low temperature detected.',
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.blue,
      icon: const Icon(Icons.info_outline, color: Colors.white),
      mainButton: TextButton(
        onPressed: _clearNotifications,
        child: const Text('DISMISS', style: TextStyle(color: Colors.white)),
      ),
    ).show(context);
  }

  void _showHighTemperatureNotification() {
    Flushbar(
      title: 'High Temperature Alert',
      message: 'High temperature detected.',
      duration: const Duration(seconds: 4),
      backgroundColor: Colors.orange,
      icon: const Icon(Icons.warning, color: Colors.white),
      mainButton: TextButton(
        onPressed: _clearNotifications,
        child: const Text('OKAY', style: TextStyle(color: Colors.white)),
      ),
    ).show(context);
  }

  void _showCriticalTemperatureNotification() {
    Flushbar(
      title: 'Critical Temperature Alert',
      message: 'Critical temperature detected.',
      duration: const Duration(seconds: 5),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Colors.red,
      icon: const Icon(Icons.error_outline, color: Colors.white),
      mainButton: TextButton(
        onPressed: _clearNotifications,
        child: const Text('ACTION', style: TextStyle(color: Colors.white)),
      ),
    ).show(context);
  }

  void _showAllNotifications() {
    if (_isLowTemperatureNotified) {
      _showLowTemperatureNotification();
    }
    if (_isHighTemperatureNotified) {
      _showHighTemperatureNotification();
    }
    if (_isCriticalTemperatureNotified) {
      _showCriticalTemperatureNotification();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          width: 100, // Adjust the width as needed
          height: AppBar().preferredSize.height,
          child: Image.asset(
            'lib/images/logo.png',
            fit: BoxFit.contain,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 13, 32, 13),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: (_isLowTemperatureNotified ||
                      _isHighTemperatureNotified ||
                      _isCriticalTemperatureNotified)
                  ? Color.fromARGB(255, 212, 16, 16)
                  : Colors.white,
              size: 30,
            ),
            onPressed: _showAllNotifications,
          ),
        ],
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.menu,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: _buildDrawer(context),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: _streamController.stream,
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Image.asset(
                'lib/images/loading.gif', // Replace with your actual .gif file path
                width: 125,
                height: 125,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            return _buildDashboard(snapshot.data!);
          }
        },
      ),
    );
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
          // _buildDrawerItem(
          //   context,
          //   icon: Icons.bar_chart,
          //   title: 'Stats',
          //   onTap: () {
          //     Navigator.pop(context);
          //     Navigator.pushReplacement(context,
          //         MaterialPageRoute(builder: (context) => StatsPage()));
          //   },
          // ),
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
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => ReportPage()));
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

  Widget _buildSensorCard({
    required String title,
    required String value,
    required Duration duration,
    required Widget graphPage, // Add graphPage parameter
  }) {
    IconData iconData;
    Color iconColor;

    switch (title.toLowerCase()) {
      case 'temperature':
        iconData = Icons.thermostat;
        iconColor = Colors.red;
        break;
      case 'soil moisture':
        iconData = Icons.opacity;
        iconColor = Colors.blue;
        break;
      case 'humidity':
        iconData = Icons.water_drop;
        iconColor = Colors.blue;
        break;
      case 'light intensity':
        iconData = Icons.lightbulb;
        iconColor = Colors.orange;
        break;
      case 'co2 percentage':
        iconData = Icons.cloud_circle;
        iconColor = Colors.green;
        break;
      default:
        iconData = Icons.help_outline;
        iconColor = Colors.grey;
        break;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => graphPage),
        );
      },
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                size: 40,
                color: iconColor,
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              DownloadUploadAnimation(
                duration: duration,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboard(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildSensorCard(
                  title: 'Temperature',
                  value: data['temperature'] != null
                      ? '${data['temperature']}°C'
                      : 'N/A',
                  duration: Duration(milliseconds: 500),
                  graphPage:
                      TemperatureGraphPage(), // Pass TemperatureGraphPage
                ),
                _buildSensorCard(
                  title: 'Soil Moisture',
                  value: data['soilMoisture'] != null
                      ? '${data['soilMoisture']}%'
                      : 'N/A',
                  duration: Duration(milliseconds: 700),
                  graphPage:
                      SoilMoistureGraphPage(), // Pass SoilMoistureGraphPage
                ),
                _buildSensorCard(
                  title: 'Humidity',
                  value:
                      data['humidity'] != null ? '${data['humidity']}%' : 'N/A',
                  duration: Duration(milliseconds: 900),
                  graphPage: HumidityGraphPage(), // Pass HumidityGraphPage
                ),
                _buildSensorCard(
                  title: 'Light Intensity',
                  value: data['lightIntensity'] != null
                      ? '${data['lightIntensity']} lux'
                      : 'N/A',
                  duration: Duration(milliseconds: 1100),
                  graphPage:
                      LightIntensityGraphPage(), // Pass LightIntensityGraphPage
                ),
                _buildSensorCard(
                  title: 'CO2 Percentage',
                  value: data['co2Percentage'] != null
                      ? '${data['co2Percentage']}%'
                      : 'N/A',
                  duration: Duration(milliseconds: 1300),
                  graphPage: CO2GraphPage(), // Pass CO2GraphPage
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationMessage {
  final String title;
  final String message;

  NotificationMessage(this.title, this.message);
}

Color _getCO2StatusColor(double co2Percentage) {
  if (co2Percentage < 20) {
    return Colors.blue;
  } else if (co2Percentage >= 20 && co2Percentage <= 30) {
    return Colors.green;
  } else if (co2Percentage > 30 && co2Percentage <= 40) {
    return Colors.deepOrange;
  } else if (co2Percentage > 40) {
    return Colors.red;
  } else {
    return Colors.grey;
  }
}

Color _getHumidityStatusColor(double humidity) {
  if (humidity < 30) {
    return Colors.blue;
  } else if (humidity >= 30 && humidity <= 60) {
    return Colors.green;
  } else if (humidity > 60 && humidity <= 80) {
    return Colors.deepOrange;
  } else if (humidity > 80) {
    return Colors.red;
  } else {
    return Colors.grey;
  }
}

String _getSoilMoistureStatus(double soilMoisture) {
  if (soilMoisture < 30) {
    return 'Low Soil Moisture';
  } else if (soilMoisture >= 30 && soilMoisture <= 60) {
    return 'Optimal Soil Moisture';
  } else if (soilMoisture > 60 && soilMoisture <= 80) {
    return 'High Soil Moisture';
  } else if (soilMoisture > 80) {
    return 'Excess Soil Moisture';
  } else {
    return '';
  }
}
