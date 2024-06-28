import 'dart:developer';

import 'package:coffee_cafe_app/main.dart';
import 'package:coffee_cafe_app/screens/rating_screen/rating_screen.dart';
import 'package:coffee_cafe_app/utils/data_base_constants.dart';
import 'package:flutter/material.dart';

import '../../orders_screen/models/order_model.dart';

bool isRatingScreenOpen = false;

checkLastProductRating(BuildContext context) async {
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
    if (lastProductRating.docs.isNotEmpty && !isRatingScreenOpen) {
      log('Last product rating found');
      // isRatingScreenOpen = true;
      final OrderModel productForRating =
          OrderModel.fromDocument(lastProductRating.docs.first.data());
      showModalBottomSheet(
          // isDismissible: false,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          elevation: 10,
          // enableDrag: false,
          // useRootNavigator: true,
          context: context,
          builder: (context) {
            return FractionallySizedBox(
                heightFactor: 0.4,
                child: RatingScreen(productForRating: productForRating));
          });
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}
