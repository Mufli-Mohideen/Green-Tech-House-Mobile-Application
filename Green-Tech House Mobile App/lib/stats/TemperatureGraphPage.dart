import 'dart:async';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../services/firebase_service.dart';

class TemperatureGraphPage extends StatefulWidget {
  @override
  _TemperatureGraphPageState createState() => _TemperatureGraphPageState();
}

class _TemperatureGraphPageState extends State<TemperatureGraphPage> {
  List<TemperatureData> _temperatureData = [];
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
    // Assuming 'temperature' is directly available in the data
    if (data['temperature'] != null) {
      double temperature =
          double.tryParse(data['temperature'].toString()) ?? 0.0;
      DateTime time = DateTime.now();

      // Add new temperature data to the list
      setState(() {
        _temperatureData.add(TemperatureData(time, temperature));
      });
    }
  }

  String _getTemperatureStatus(double temperature) {
    if (temperature < 18) {
      return 'Low Temperature';
    } else if (temperature > 18 && temperature <= 24) {
      return 'Optimal Temperature';
    } else if (temperature > 24 && temperature <= 30) {
      return 'High Temperature';
    } else if (temperature > 30) {
      return 'Critical Temperature';
    } else {
      return '';
    }
  }

  Color _getStatusColor(double temperature) {
    if (temperature < 18) {
      return Colors.blue;
    } else if (temperature > 18 && temperature <= 24) {
      return Colors.green;
    } else if (temperature > 24 && temperature <= 30) {
      return Colors.deepOrange; // Adjust color for very high temperature
    } else if (temperature > 30) {
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
          'Temperature Graph',
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
            _buildChart(_temperatureData),
            SizedBox(height: 16),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(List<TemperatureData> data) {
    return Container(
      height: 550,
      child: charts.TimeSeriesChart(
        [
          charts.Series<TemperatureData, DateTime>(
            id: 'Temperature',
            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
            domainFn: (TemperatureData data, _) => data.time,
            measureFn: (TemperatureData data, _) => data.temperature,
            data: data,
          ),
        ],
        animate: true,
        dateTimeFactory: const charts.LocalDateTimeFactory(),
      ),
    );
  }

  Widget _buildLegend() {
    if (_temperatureData.isNotEmpty) {
      double currentTemperature = _temperatureData.last.temperature;
      String status = _getTemperatureStatus(currentTemperature);
      Color statusColor = _getStatusColor(currentTemperature);

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

// Sample data class for temperature data
class TemperatureData {
  final DateTime time;
  final double temperature;

  TemperatureData(this.time, this.temperature);
}
