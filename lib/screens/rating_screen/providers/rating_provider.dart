import 'package:flutter/material.dart';

class RatingProvider extends ChangeNotifier {
  int _rating = 1;

  int get rating => _rating;

  void setRating(int rating) {
    _rating = rating;
    notifyListeners();
  }
}
