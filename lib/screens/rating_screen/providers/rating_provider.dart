import 'package:flutter/material.dart';

class RatingProvider extends ChangeNotifier {
  final List<Map<String, int>> _ratings = [];


  List<Map<String, int>> get ratings => _ratings;

  setRatings(Map<String, int> rating, int index) {
    _ratings[index] = rating;
    notifyListeners();
  }
}
