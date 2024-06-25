import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  Future<Map<String, dynamic>> getSensorData() async {
    try {
      DatabaseEvent event = await _databaseReference.child('Sensors').once();
      if (event.snapshot.value != null) {
        // Casting event.snapshot.value to a Map
        Map<String, dynamic> data = Map<String, dynamic>.from(
            event.snapshot.value as Map<dynamic, dynamic>);
        print('Fetched data: $data');
        return data;
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    return {};
  }
}
