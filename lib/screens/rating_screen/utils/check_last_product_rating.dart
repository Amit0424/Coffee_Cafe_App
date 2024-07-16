import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_cafe_app/main.dart';
import 'package:coffee_cafe_app/screens/rating_screen/rating_screen.dart';
import 'package:coffee_cafe_app/utils/data_base_constants.dart';
import 'package:flutter/material.dart';

import '../../orders_screen/models/order_model.dart';

bool isRatingScreenOpen = false;

Future<void> checkLastProductRating(BuildContext context) async {
  if (isRatingScreenOpen) {
    return;
  }
  try {
    log('Checking for last product rating');
    final lastProductRating = await fireStore
        .collection('orders')
        .where('userId', isEqualTo: DBConstants().userID())
        .where('orderStatus', isEqualTo: 'Served')
        .where('rating', isEqualTo: 0)
        .orderBy('orderTime', descending: true)
        .limit(1)
        .get();
    if (lastProductRating.docs.isNotEmpty) {
      log('Last product rating found');
      final DocumentSnapshot product = lastProductRating.docs.first;
      final OrderModel productForRating = OrderModel.fromDocument(product);
      isRatingScreenOpen = true;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RatingScreen(
            productForRating: productForRating,
          ),
        ),
      );
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}
