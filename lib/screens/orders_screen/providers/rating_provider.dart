import 'package:flutter/material.dart';

class RatingProvider extends ChangeNotifier {
  int _rating = 0;

  int get rating => _rating;

  set rating(int rating) {
    _rating = rating;
    notifyListeners();
  }
}
