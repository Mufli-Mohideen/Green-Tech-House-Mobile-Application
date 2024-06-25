import 'dart:async';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../services/firebase_service.dart';

class CO2GraphPage extends StatefulWidget {
  @override
  _CO2GraphPageState createState() => _CO2GraphPageState();
}

class _CO2GraphPageState extends State<CO2GraphPage> {
  List<CO2Data> _co2Data = [];
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
    // Assuming 'co2Percentage' is directly available in the data
    if (data['co2Percentage'] != null) {
      double co2Percentage = (data['co2Percentage'] as num).toDouble();
      DateTime time = DateTime.now();

      // Add new CO2 data to the list
      setState(() {
        _co2Data.add(CO2Data(time, co2Percentage));
      });
    }
  }

  String _getCO2Status(double co2Percentage) {
    if (co2Percentage < 20) {
      return 'Low CO2 Level';
    } else if (co2Percentage >= 20 && co2Percentage <= 30) {
      return 'Optimal CO2 Level';
    } else if (co2Percentage > 30 && co2Percentage <= 40) {
      return 'High CO2 Level';
    } else if (co2Percentage > 40) {
      return 'Critical CO2 Level';
    } else {
      return '';
    }
  }

  Color _getStatusColor(double co2Percentage) {
    if (co2Percentage < 20) {
      return Colors.blue;
    } else if (co2Percentage >= 20 && co2Percentage <= 30) {
      return Colors.green;
    } else if (co2Percentage > 30 && co2Percentage <= 40) {
      return Colors.deepOrange; // Adjust color for very high CO2 levels
    } else if (co2Percentage > 40) {
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
          'CO2 Level Graph',
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
            _buildChart(_co2Data),
            SizedBox(height: 16),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(List<CO2Data> data) {
    return Container(
      height: 550,
      child: charts.TimeSeriesChart(
        [
          charts.Series<CO2Data, DateTime>(
            id: 'CO2Level',
            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
            domainFn: (CO2Data data, _) => data.time,
            measureFn: (CO2Data data, _) => data.co2Percentage,
            data: data,
          ),
        ],
        animate: true,
        dateTimeFactory: const charts.LocalDateTimeFactory(),
      ),
    );
  }

  Widget _buildLegend() {
    if (_co2Data.isNotEmpty) {
      double currentCO2 = _co2Data.last.co2Percentage;
      String status = _getCO2Status(currentCO2);
      Color statusColor = _getStatusColor(currentCO2);

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

// Sample data class for CO2 data
class CO2Data {
  final DateTime time;
  final double co2Percentage;

  CO2Data(this.time, this.co2Percentage);
}
