import 'dart:async';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../services/firebase_service.dart';

class LightIntensityGraphPage extends StatefulWidget {
  @override
  _LightIntensityGraphPageState createState() =>
      _LightIntensityGraphPageState();
}

class _LightIntensityGraphPageState extends State<LightIntensityGraphPage> {
  List<LightIntensityData> _lightIntensityData = [];
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
    // Assuming 'lightIntensity' is directly available in the data
    if (data['lightIntensity'] != null) {
      int lightIntensity = data['lightIntensity'] as int;
      DateTime time = DateTime.now();

      // Add new light intensity data to the list
      setState(() {
        _lightIntensityData.add(LightIntensityData(time, lightIntensity));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Light Intensity Graph',
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
            _buildChart(_lightIntensityData),
            SizedBox(height: 16),
            // You can add any additional widgets here, like a legend or summary
          ],
        ),
      ),
    );
  }

  Widget _buildChart(List<LightIntensityData> data) {
    return Container(
      height: 550,
      child: charts.TimeSeriesChart(
        [
          charts.Series<LightIntensityData, DateTime>(
            id: 'LightIntensity',
            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
            domainFn: (LightIntensityData data, _) => data.time,
            measureFn: (LightIntensityData data, _) => data.lightIntensity,
            data: data,
          ),
        ],
        animate: true,
        dateTimeFactory: const charts.LocalDateTimeFactory(),
      ),
    );
  }
}

// Sample data class for light intensity data
class LightIntensityData {
  final DateTime time;
  final int lightIntensity;

  LightIntensityData(this.time, this.lightIntensity);
}
