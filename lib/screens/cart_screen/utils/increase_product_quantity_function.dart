import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../utils/data_base_constants.dart';

increaseQuantity(BuildContext context, Map<String, dynamic> product,
    List<dynamic> cartItems) async {
  if (product['productQuantity'] < 4) {
    for (int i = 0; i < cartItems.length; i++) {
      if (cartItems[i]['productId'] == product['productId'] &&
          cartItems[i]['productSize'] == product['productSize']) {
        final price = product['productPrice'] / product['productQuantity'];
        cartItems[i]['productQuantity'] = ++product['productQuantity'];
        cartItems[i]['productPrice'] = price * product['productQuantity'];
        break;
      }
    }
    await fireStore.collection('userCart').doc(DBConstants().userID()).update({
      'cartItems': cartItems,
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
