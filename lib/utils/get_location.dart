import 'dart:developer';

import 'package:coffee_cafe_app/providers/location_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

Future<Map<String, double>> getLocation(BuildContext context) async {
  final LocationProvider locationProvider =
      Provider.of<LocationProvider>(context, listen: false);
  late double latitude;
  late double longitude;
  try {
    Position position = await determinePosition();
    latitude = position.latitude;
    longitude = position.longitude;
  } catch (e) {
    log(e.toString());
  }
  locationProvider.setLocation({'latitude': latitude, 'longitude': longitude});
  return {'latitude': latitude, 'longitude': longitude};
}

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
}
