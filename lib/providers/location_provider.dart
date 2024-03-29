import 'package:flutter/material.dart';

class LocationProvider with ChangeNotifier {
  Map<String, double> _location = {};
  String _locationName = '';

  void setLocationName(String locationName) {
    _locationName = locationName;
    notifyListeners();
  }

  void setLocation(Map<String, double> location) {
    _location = location;
    notifyListeners();
  }

  get location => _location;
  get locationName => _locationName;
}
