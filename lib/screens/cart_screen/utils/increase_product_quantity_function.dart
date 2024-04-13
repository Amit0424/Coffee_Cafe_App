import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../utils/data_base_constants.dart';
import '../models/cart_item_model.dart';
import '../models/cart_model.dart';

increaseQuantity(
    BuildContext context, CartItemModel product, CartModel cartModel) async {
  if (product.productQuantity < 4) {
    for (int i = 0; i < cartModel.cartItems.length; i++) {
      if (cartModel.cartItems[i].productId == product.productId &&
          cartModel.cartItems[i].productSize == product.productSize) {
        final price = product.productPrice / product.productQuantity;
        cartModel.cartItems[i].productQuantity = ++product.productQuantity;
        cartModel.cartItems[i].productPrice = price * product.productQuantity;
        break;
      }
    }
    await fireStore.collection('userCart').doc(DBConstants().userID()).update({
      'cartItems': cartModel.cartItems.map((x) => x.toMap()).toList(),
    });
  } else {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('You can only add 4 items of the same product'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
