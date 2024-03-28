import 'package:flutter/material.dart';

class ParentProvider with ChangeNotifier {
  int _currentIndex = 0;

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  int get currentIndex => _currentIndex;
}
