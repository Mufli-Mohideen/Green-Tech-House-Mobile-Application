import 'dart:async';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../services/firebase_service.dart';

class HumidityGraphPage extends StatefulWidget {
  @override
  _HumidityGraphPageState createState() => _HumidityGraphPageState();
}

class _HumidityGraphPageState extends State<HumidityGraphPage> {
  List<HumidityData> _humidityData = [];
  bool _isLoading = true;
  StreamSubscription<Map<String, dynamic>>? _streamSubscription;

  @override
  void initState() {
    super.initState();
    _initStreamSubscription();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  void _initStreamSubscription() {
    _streamSubscription =
        Stream.periodic(Duration(seconds: 1)).asyncMap((event) async {
      return await FirebaseService().getSensorData();
    }).listen((data) {
      _updateChart(data);
      if (_isLoading) {
        setState(() {
          _isLoading = false;
        });
      }
    }, onError: (e) {
      print('Error receiving sensor data: $e');
      // Handle error state as needed
    });
  }

  void _updateChart(Map<String, dynamic> data) {
    // Assuming 'humidity' is directly available in the data
    if (data['humidity'] != null) {
      double humidity = double.tryParse(data['humidity'].toString()) ?? 0.0;
      DateTime time = DateTime.now();

      // Add new humidity data to the list
      setState(() {
        _humidityData.add(HumidityData(time, humidity));
      });
    }
  }

  String _getHumidityStatus(double humidity) {
    if (humidity < 30) {
      return 'Low Humidity';
    } else if (humidity >= 30 && humidity <= 60) {
      return 'Optimal Humidity';
    } else if (humidity > 60 && humidity <= 80) {
      return 'High Humidity';
    } else if (humidity > 80) {
      return 'Critical Humidity';
    } else {
      return '';
    }
  }

  Color _getStatusColor(double humidity) {
    if (humidity < 30) {
      return Colors.blue;
    } else if (humidity >= 30 && humidity <= 60) {
      return Colors.green;
    } else if (humidity > 60 && humidity <= 80) {
      return Colors.deepOrange; // Adjust color for very high humidity
    } else if (humidity > 80) {
      return Colors.red;
    } else {
      return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Humidity Graph',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 13, 32, 13),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildChart(_humidityData),
            SizedBox(height: 16),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(List<HumidityData> data) {
    return Container(
      height: 550,
      child: charts.TimeSeriesChart(
        [
          charts.Series<HumidityData, DateTime>(
            id: 'Humidity',
            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
            domainFn: (HumidityData data, _) => data.time,
            measureFn: (HumidityData data, _) => data.humidity,
            data: data,
          ),
        ],
        animate: true,
        dateTimeFactory: const charts.LocalDateTimeFactory(),
      ),
    );
  }

  Widget _buildLegend() {
    if (_humidityData.isNotEmpty) {
      double currentHumidity = _humidityData.last.humidity;
      String status = _getHumidityStatus(currentHumidity);
      Color statusColor = _getStatusColor(currentHumidity);

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Icon(Icons.circle, color: Colors.white, size: 16),
                SizedBox(width: 4),
                Text(
                  status,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return SizedBox.shrink(); // Return an empty SizedBox if no data
    }
  }
}

// Sample data class for humidity data
class HumidityData {
  final DateTime time;
  final double humidity;

  HumidityData(this.time, this.humidity);
}
