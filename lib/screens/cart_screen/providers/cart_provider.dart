import 'package:coffee_cafe_app/main.dart';
import 'package:flutter/material.dart';

import '../../../utils/data_base_constants.dart';

class CartProvider with ChangeNotifier {
  List<Map<String, dynamic>> cartList = [];
  double totalAmount = 0.0;

  CartProvider() {
    // getCartItem();
  }

  getCartItem() async {
    await fireStore
        .collection('userCart')
        .doc(DBConstants().userID())
        .get()
        .then(
      (doc) {
        if (doc.exists) {
          cartList = List<Map<String, dynamic>>.from(doc.data()?['cart']);
          totalAmount = cartList.fold(
              0,
              (previousValue, element) =>
                  previousValue + element['productPrice']);
        }
        notifyListeners();
      },
    );
  }
}
