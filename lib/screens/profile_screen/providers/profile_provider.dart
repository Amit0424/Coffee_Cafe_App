import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  Map _profileModelMap = {};
  bool _isAllFieldCompleted = false;

  setProfileModelMap(Map profileModelMap) {
    _profileModelMap = profileModelMap;
  }

  setIsAllFieldCompleted(bool isAllFieldCompleted) {
    _isAllFieldCompleted = isAllFieldCompleted;
    notifyListeners();
  }

  get profileModelMap => _profileModelMap;
  get isAllFieldCompleted => _isAllFieldCompleted;
}
