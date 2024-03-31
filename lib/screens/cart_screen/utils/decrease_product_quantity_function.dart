import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../utils/data_base_constants.dart';

decreaseQuantity(BuildContext context, Map<String, dynamic> product,
    List<dynamic> cartItems) async {
  for (int i = 0; i < cartItems.length; i++) {
    if (cartItems[i]['productId'] == product['productId'] &&
        cartItems[i]['productSize'] == product['productSize']) {
      if (product['productQuantity'] == 1) {
        cartItems.removeAt(i);
      } else {
        final price = product['productPrice'] / product['productQuantity'];
        cartItems[i]['productQuantity'] = --product['productQuantity'];
        cartItems[i]['productPrice'] = price * product['productQuantity'];
      }

      break;
    }
  }
  await fireStore.collection('userCart').doc(DBConstants().userID()).update({
    'cartItems': cartItems,
  });
}
