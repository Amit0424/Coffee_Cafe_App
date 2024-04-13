import 'package:coffee_cafe_app/screens/cart_screen/models/cart_item_model.dart';
import 'package:coffee_cafe_app/screens/cart_screen/models/cart_model.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../utils/data_base_constants.dart';

decreaseQuantity(
    BuildContext context, CartItemModel product, CartModel cartModel) async {
  for (int i = 0; i < cartModel.cartItems.length; i++) {
    if (cartModel.cartItems[i].productId == product.productId &&
        cartModel.cartItems[i].productSize == product.productSize) {
      if (product.productQuantity == 1) {
        cartModel.cartItems.removeAt(i);
      } else {
        final price = product.productPrice / product.productQuantity;
        cartModel.cartItems[i].productQuantity = --product.productQuantity;
        cartModel.cartItems[i].productPrice = price * product.productQuantity;
      }

      break;
    }
  }
  await fireStore.collection('userCart').doc(DBConstants().userID()).update({
    'cartItems': cartModel.cartItems.map((x) => x.toMap()).toList(),
  });
}
