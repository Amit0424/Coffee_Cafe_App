import 'package:flutter/material.dart';

class UserNameProvider with ChangeNotifier {
  String _userName = '';

  String get userName => _userName;

  void setuserName(String name) {
    _userName = name;
    notifyListeners();
  }
}
