import 'package:firebase_database/firebase_database.dart';

class CarControlService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  CarControlService() {
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    _db.keepSynced(true);
    _db.child('.info/connected').onValue.listen((event) {
      bool connected = event.snapshot.value as bool? ?? false;
      print('Firebase connectivity status: $connected');
    });
  }

  Stream<Map<String, dynamic>> getCarState() {
    print('Fetching car state from Firebase');
    return _db.onValue
        .map((event) {
          final data = Map<String, dynamic>.from(
            event.snapshot.value as Map? ?? {},
          );
          print('Car state data: $data');
          return data.isNotEmpty
              ? data
              : {
                'engine': 'off',
                'right_door': 'locked',
                'trunk': 'closed',
                'ac': 'off',
                'climate': 21,
                'temp': 21,
                'left_door': 'locked',
                'lights': 'off',
                'r': 0, // Default red value
                'g': 0, // Default green value
                'b': 0, // Default blue value
              };
        })
        .handleError((error) {
          print('Car state stream error: $error');
          return {
            'engine': 'off',
            'right_door': 'locked',
            'trunk': 'closed',
            'ac': 'off',
            'climate': 21,
            'temp': 21,
            'left_door': 'locked',
            'lights': 'off',
            'r': 0,
            'g': 0,
            'b': 0,
          };
        });
  }

  Future<void> toggleEngine(bool value) async {
    try {
      print('Toggling engine to: ${value ? 'on' : 'off'}');
      await _db.update({'engine': value ? 'on' : 'off'});
      print('Engine toggle successful');
    } catch (e) {
      print('Error toggling engine: $e');
      rethrow;
    }
  }

  Future<void> toggleDoors(bool value) async {
    try {
      print('Toggling right door to: ${value ? 'locked' : 'open'}');
      await _db.update({'right_door': value ? 'locked' : 'open'});
      print('Right door toggle successful');
    } catch (e) {
      print('Error toggling right door: $e');
      rethrow;
    }
  }

  Future<void> toggleLeftDoor(bool value) async {
    try {
      print('Toggling left door to: ${value ? 'locked' : 'open'}');
      await _db.update({'left_door': value ? 'locked' : 'open'});
      print('Left door toggle successful');
    } catch (e) {
      print('Error toggling left door: $e');
      rethrow;
    }
  }

  Future<void> toggleTrunk(bool value) async {
    try {
      print('Toggling trunk to: ${value ? 'closed' : 'open'}');
      await _db.update({'trunk': value ? 'closed' : 'open'});
      print('Trunk toggle successful');
    } catch (e) {
      print('Error toggling trunk: $e');
      rethrow;
    }
  }

  Future<void> toggleClimate(bool value) async {
    try {
      print('Toggling climate to: ${value ? 'on' : 'off'}');
      await _db.update({'ac': value ? 'on' : 'off'});
      print('Climate toggle successful');
    } catch (e) {
      print('Error toggling climate: $e');
      rethrow;
    }
  }

  Future<void> setClimate(double temperature) async {
    try {
      print('Setting climate temperature to: $temperature');
      await _db.update({'climate': temperature});
      print('Climate temperature set successful');
    } catch (e) {
      print('Error setting climate temperature: $e');
      rethrow;
    }
  }

  Future<void> toggleLights(bool value) async {
    try {
      print('Toggling lights to: ${value ? 'on' : 'off'}');
      await _db.update({'lights': value ? 'on' : 'off'});
      print('Lights toggle successful');
    } catch (e) {
      print('Error toggling lights: $e');
      rethrow;
    }
  }

  // New methods to set RGB values
  Future<void> setRed(int value) async {
    try {
      print('Setting red to: $value');
      await _db.update({'r': value});
      print('Red value set successful');
    } catch (e) {
      print('Error setting red: $e');
      rethrow;
    }
  }

  Future<void> setGreen(int value) async {
    try {
      print('Setting green to: $value');
      await _db.update({'g': value});
      print('Green value set successful');
    } catch (e) {
      print('Error setting green: $e');
      rethrow;
    }
  }

  Future<void> setBlue(int value) async {
    try {
      print('Setting blue to: $value');
      await _db.update({'b': value});
      print('Blue value set successful');
    } catch (e) {
      print('Error setting blue: $e');
      rethrow;
    }
  }
}
