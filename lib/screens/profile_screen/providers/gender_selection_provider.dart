import 'package:coffee_cafe_app/screens/profile_screen/profile_model/profile_model.dart';
import 'package:flutter/material.dart';

class GenderSelectionProvider with ChangeNotifier {
  Gender _selectedGender = Gender.male;

  setGender(Gender gender) {
    _selectedGender = gender;
    notifyListeners();
  }

  setDBGender(Gender gender) {
    _selectedGender = gender;
  }

  get selectedGender => _selectedGender;
}
