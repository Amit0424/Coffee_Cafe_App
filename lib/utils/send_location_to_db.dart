import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../main.dart';
import '../providers/location_provider.dart';
import 'data_base_constants.dart';
import 'get_location.dart';

sendLastLocationToDB(BuildContext context) async {
  final LocationProvider locationProvider =
  Provider.of(context, listen: false);
  final locationMap = await getLocation(context);
  locationProvider.setLocation(locationMap);
  final locationName = await getLocationName(locationMap);
  locationProvider.setLocationName(locationName);
  String id = const Uuid().v4();
  await fireStore
      .collection('coffeeDrinkers')
      .doc(DBConstants().userID())
      .update({
    'lastLocationName': locationName,
    'latitude': locationMap['latitude'],
    'longitude': locationMap['longitude'],
  });
  await fireStore
      .collection('userLastLocation')
      .doc(DBConstants().userID())
      .collection('lastLocation')
      .doc(id)
      .set({
    'id': id,
    'locationName': locationName,
    'latitude': locationMap['latitude'],
    'longitude': locationMap['longitude'],
    'time': DateTime.now(),
  });
}