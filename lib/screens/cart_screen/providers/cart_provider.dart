import 'package:flutter/cupertino.dart';

class CartProvider with ChangeNotifier {
  int quantity = 1;

  void setProductQuantity(int value) {
    quantity = value;
    notifyListeners();
  }
}
