import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:coffee_cafe_app/screens/cart_screen/models/cart_model.dart';
import 'package:coffee_cafe_app/screens/orders_screen/utils/order_count.dart';
import 'package:coffee_cafe_app/screens/profile_screen/profile_model/profile_model.dart';
import 'package:coffee_cafe_app/screens/profile_screen/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../main.dart';
import '../../../utils/data_base_constants.dart';
import '../../parent_screen/providers/parent_provider.dart';

placeOrder(BuildContext context, CartModel cartModel, double payableAmount,
    String paymentMethod, String orderName, bool isFromCart) async {
  final ParentProvider parentProvider =
      Provider.of<ParentProvider>(context, listen: false);
  final ProfileProvider profileProvider =
      Provider.of<ProfileProvider>(context, listen: false);
  final orderId = const Uuid().v4();

  try {
    await fireStore.collection('orders').doc(orderId).set({
      'userId': DBConstants().userID(),
      'orderId': orderId,
      'orderTime': DateTime.now(),
      'orderStatus': 'Placed',
      'userName': profileProvider.profileModelMap.name,
      'userEmail': profileProvider.profileModelMap.email,
      'userPhone': profileProvider.profileModelMap.phone,
      'gender': genderToString(profileProvider.profileModelMap.gender),
      'dateOfBirth': profileProvider.profileModelMap.dateOfBirth,
      'address': profileProvider.profileModelMap.lastLocationName,
      'profileImage': profileProvider.profileModelMap.profileImageUrl,
      'accountCreatedDate': profileProvider.profileModelMap.accountCreatedDate,
      'latitude': profileProvider.profileModelMap.latitude,
      'longitude': profileProvider.profileModelMap.longitude,
      'orderDrinks': {
        'cartItems': cartModel.cartItems.map((e) => e.toMap()).toList()
      },
      'payableAmount': payableAmount.round(),
      'paymentMethod': paymentMethod,
      'orderName': orderName,
      'rating': 0,
      'orderNumber': 100001 + await getOrdersCount(),
    }).then((value) async {
      if (isFromCart) {
        await fireStore
            .collection('userCart')
            .doc(DBConstants().userID())
            .update({'cartItems': []});
      }
    });
  } on SocketException catch (_) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No Internet Connection'),
      ),
    );
    if (isFromCart) {
      parentProvider.currentIndex = 3;
    } else {
      parentProvider.currentIndex = 0;
    }
    Navigator.popUntil(context, (route) => route.isFirst);
  } on TimeoutException catch (_) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Connection Timeout'),
      ),
    );
    if (isFromCart) {
      parentProvider.currentIndex = 3;
    } else {
      parentProvider.currentIndex = 0;
    }
    Navigator.popUntil(context, (route) => route.isFirst);
  } catch (e) {
    log(e.toString());
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Error Placing Order'),
      ),
    );
    if (isFromCart) {
      parentProvider.currentIndex = 3;
    } else {
      parentProvider.currentIndex = 0;
    }
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}
