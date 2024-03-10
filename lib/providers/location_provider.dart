import 'package:coffee_cafe_app/utils/get_location.dart';
import 'package:flutter/material.dart';

class LocationProvider with ChangeNotifier {
  Map<String, double> _location = {};

  LocationProvider() {
    setLocation();
  }

  setLocation() async {
    _location = await getLocation();
  }

  get location => _location;
}
