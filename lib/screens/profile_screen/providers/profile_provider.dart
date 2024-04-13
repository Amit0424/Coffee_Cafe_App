import 'package:coffee_cafe_app/screens/profile_screen/profile_model/profile_model.dart';
import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  late ProfileModel _profileModelMap;
  bool _isAllFieldCompleted = false;

  setProfileModelMap(ProfileModel profileModelMap) {
    _profileModelMap = profileModelMap;
  }

  setIsAllFieldCompleted(bool isAllFieldCompleted) {
    _isAllFieldCompleted = isAllFieldCompleted;
    notifyListeners();
  }

  ProfileModel get profileModelMap => _profileModelMap;
  get isAllFieldCompleted => _isAllFieldCompleted;
}
