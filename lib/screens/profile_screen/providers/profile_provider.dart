import 'package:coffee_cafe_app/screens/profile_screen/profile_model/profile_model.dart';
import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  ProfileModel _profileModelMap = ProfileModel(
      name: '',
      email: '',
      phone: '',
      dateOfBirth: '',
      profileImageUrl: '',
      profileBackgroundImageUrl: '',
      accountCreatedDate: '',
      gender: Gender.male,
      lastOnline: DateTime.now(),
      latitude: 0.0,
      longitude: 0.0,
      lastLocationName: '');
  bool _isAllFieldCompleted = false;

  setProfileModelMap(ProfileModel profileModelMap) {
    _profileModelMap = profileModelMap;
  }

  setIsAllFieldCompleted(bool isAllFieldCompleted) {
    _isAllFieldCompleted = isAllFieldCompleted;
    notifyListeners();
  }

  ProfileModel get profileModelMap => _profileModelMap;
  bool get isAllFieldCompleted => _isAllFieldCompleted;
}
