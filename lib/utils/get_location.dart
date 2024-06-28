import 'dart:developer';

import 'package:coffee_cafe_app/screens/profile_screen/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

Future<Map<String, double>> getLocation(BuildContext context) async {
  final ProfileProvider profileProvider =
      Provider.of<ProfileProvider>(context, listen: false);
  double latitude = 0.0;
  double longitude = 0.0;
  try {
    Position position = await determinePosition(context);
    latitude = position.latitude;
    longitude = position.longitude;
    profileProvider.profileModelMap.latitude = latitude;
    profileProvider.profileModelMap.longitude = longitude;
    log('Latitude: $latitude, Longitude: $longitude');
    return {'latitude': latitude, 'longitude': longitude};
  } catch (e) {
    log(e.toString());
  }
  return {'latitude': latitude, 'longitude': longitude};
}

Future<Position> determinePosition(BuildContext context) async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Location Services Disabled'),
              content:
                  const Text('Please enable location services to continue.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            ));
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

getLocationName(Map<String, double> location) async {
  double latitude = location['latitude'] ?? 14.599287111387492;
  double longitude = location['longitude'] ?? 120.9903398528695;
  List<Placemark> placeMarks =
      await placemarkFromCoordinates(latitude, longitude);
  Placemark place = placeMarks[1];
  return "${place.street} ${place.subLocality} ${place.locality} ${place.country} ${place.postalCode}";
}
