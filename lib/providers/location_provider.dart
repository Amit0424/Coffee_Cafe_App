import 'package:flutter/material.dart';

class LocationProvider with ChangeNotifier {
  Map<String, double> _location = {};

  setLocation(Map<String, double> location) {
    _location = location;
    notifyListeners();
  }

  get location => _location;
}
