import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';
import '../../../providers/location_provider.dart';
import '../../../utils/data_base_constants.dart';
import '../profile_model/profile_model.dart';
import '../providers/gender_selection_provider.dart';
import '../providers/profile_provider.dart';

onSave(
  BuildContext context,
  String buttonName,
  GlobalKey<FormState> formKey,
  TextEditingController nameController,
  TextEditingController mobileController,
  TextEditingController emailController,
  TextEditingController dateController,
  String profileImageUrl,
  String backgroundImageUrl,
) async {
  final isValid = formKey.currentState!.validate();
  if (!isValid) return;
  formKey.currentState!.save();
  final GenderSelectionProvider genderSelectionProvider =
      Provider.of<GenderSelectionProvider>(context, listen: false);
  final LocationProvider locationProvider =
      Provider.of<LocationProvider>(context, listen: false);
  final ProfileProvider profileProvider =
      Provider.of<ProfileProvider>(context, listen: false);
  final gender = genderSelectionProvider.selectedGender;
  // _checkAllFieldCompleted(buttonName);
  if (profileProvider.isAllFieldCompleted) {
    ScaffoldMessenger.of(context).clearSnackBars();
    final listenersData = await fireStore
        .collection('coffeeDrinkers')
        .doc(DBConstants().userID())
        .get();

    if (listenersData.exists) {
      profileProvider.profileModelMap.name = nameController.text.trim();
      profileProvider.profileModelMap.phone = mobileController.text.trim();
      profileProvider.profileModelMap.gender = gender;
      await fireStore
          .collection('coffeeDrinkers')
          .doc(DBConstants().userID())
          .update({
        'name': nameController.text.trim(),
        'phone': mobileController.text.trim(),
        'gender': gender == Gender.other
            ? 'other'
            : gender == Gender.female
                ? 'female'
                : 'male',
      });
    } else {
      await fireStore
          .collection('coffeeDrinkers')
          .doc(DBConstants().userID())
          .set({
        'profileImageUrl': profileImageUrl,
        'profileBackgroundImageUrl': backgroundImageUrl,
        'name': nameController.text.trim(),
        'phone': mobileController.text.trim(),
        'email': emailController.text,
        'gender': gender == Gender.other
            ? 'other'
            : gender == Gender.female
                ? 'female'
                : 'male',
        'dateOfBirth': dateController.text,
        'accountCreatedDate': DateFormat('dd/MM/yyyy').format(DateTime.now()),
        'lastOnline': DateTime.now(),
        'latitude': locationProvider.location['latitude'],
        'longitude': locationProvider.location['longitude'],
      });
    }
  }
  profileProvider.setIsAllFieldCompleted(false);
  Navigator.pop(context);
}
