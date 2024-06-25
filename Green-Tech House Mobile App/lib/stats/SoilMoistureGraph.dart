import 'dart:async';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../services/firebase_service.dart';

class SoilMoistureGraphPage extends StatefulWidget {
  @override
  _SoilMoistureGraphPageState createState() => _SoilMoistureGraphPageState();
}

class _SoilMoistureGraphPageState extends State<SoilMoistureGraphPage> {
  List<SoilMoistureData> _soilMoistureData = [];
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
    // Assuming 'soilMoisture' is directly available in the data
    if (data['soilMoisture'] != null) {
      double soilMoisture =
          double.tryParse(data['soilMoisture'].toString()) ?? 0.0;
      DateTime time = DateTime.now();

      // Add new soil moisture data to the list
      setState(() {
        _soilMoistureData.add(SoilMoistureData(time, soilMoisture));
      });
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

  Color _getStatusColor(double soilMoisture) {
    if (soilMoisture < 30) {
      return Colors.red;
    } else if (soilMoisture >= 30 && soilMoisture <= 60) {
      return Colors.green;
    } else if (soilMoisture > 60 && soilMoisture <= 80) {
      return Colors.blue; // Adjust color for high soil moisture
    } else if (soilMoisture > 80) {
      return Colors.deepOrange;
    } else {
      return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Soil Moisture Graph',
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
            _buildChart(_soilMoistureData),
            SizedBox(height: 16),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(List<SoilMoistureData> data) {
    return Container(
      height: 550,
      child: charts.TimeSeriesChart(
        [
          charts.Series<SoilMoistureData, DateTime>(
            id: 'Soil Moisture',
            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
            domainFn: (SoilMoistureData data, _) => data.time,
            measureFn: (SoilMoistureData data, _) => data.soilMoisture,
            data: data,
          ),
        ],
        animate: true,
        dateTimeFactory: const charts.LocalDateTimeFactory(),
      ),
    );
  }

  Widget _buildLegend() {
    if (_soilMoistureData.isNotEmpty) {
      double currentSoilMoisture = _soilMoistureData.last.soilMoisture;
      String status = _getSoilMoistureStatus(currentSoilMoisture);
      Color statusColor = _getStatusColor(currentSoilMoisture);

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

// Sample data class for soil moisture data
class SoilMoistureData {
  final DateTime time;
  final double soilMoisture;

  SoilMoistureData(this.time, this.soilMoisture);
}
