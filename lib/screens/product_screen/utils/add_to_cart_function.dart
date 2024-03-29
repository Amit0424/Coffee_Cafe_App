import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../main.dart';
import '../../../utils/data_base_constants.dart';

Future<void> addProductToCart(
    Map<String, dynamic> product, String buttonName) async {
  try {
    final DocumentReference userCartRef =
        fireStore.collection('userCart').doc(DBConstants().userID());

    final DocumentSnapshot userCartSnapshot = await userCartRef.get();
    if (userCartSnapshot.exists) {
      Map<String, dynamic>? data =
          userCartSnapshot.data() as Map<String, dynamic>?;
      List<Map<String, dynamic>> cartItems =
          List<Map<String, dynamic>>.from(data?['cartItems'] ?? []);

      bool productExists = false;
      int index = -1;
      for (int i = 0; i < cartItems.length; i++) {
        if (cartItems[i]['productId'] == product['productId'] &&
            cartItems[i]['productSize'] == product['productSize']) {
          productExists = true;
          index = i;
          break;
        }
      }

      if (productExists) {
        if (cartItems[index]['productQuantity'] != product['productQuantity']) {
          cartItems[index]['productQuantity'] = product['productQuantity'];
          cartItems[index]['productPrice'] = product['productPrice'];
          await userCartRef.update({'cartItems': cartItems});
          if (buttonName == 'Add to Cart') {
            Fluttertoast.showToast(
              msg: 'Quantity changed to ${product['productQuantity']}',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          }
        } else {
          if (buttonName == 'Add to Cart') {
            Fluttertoast.showToast(
              msg: 'Already in cart',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          }
        }
      } else {
        cartItems.add(product);
        await userCartRef.update({'cartItems': cartItems});
        if (buttonName == 'Add to Cart') {
          Fluttertoast.showToast(
            msg: 'Added to cart',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      }
    } else {
      await userCartRef.set({
        'cartItems': [product],
      });
      if (buttonName == 'Add to Cart') {
        Fluttertoast.showToast(
          msg: 'Added to cart',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    }
  } catch (e) {
    Fluttertoast.showToast(msg: 'Getting error!');
  }
}
