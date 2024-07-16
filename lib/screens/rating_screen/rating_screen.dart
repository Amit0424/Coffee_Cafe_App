import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:coffee_cafe_app/screens/rating_screen/widgets/rating_bar.dart';
import 'package:coffee_cafe_app/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../main.dart';
import '../../widgets/my_separator.dart';
import '../orders_screen/models/order_model.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key, required this.productForRating});
  final OrderModel productForRating;

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  bool isRatingUploading = false;
  final List<Map<String, int>> _ratings = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0;
        i <= widget.productForRating.orderDrinks.cartItems.length;
        i++) {
      _ratings.add({'id': 5});
      log('Rating added: $_ratings');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 3,
        shadowColor: Colors.grey[300],
        surfaceTintColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: appBarTitle(context, 'Rate Your Order'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: isRatingUploading,
        progressIndicator: const LoadingWidget(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount:
                      widget.productForRating.orderDrinks.cartItems.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        if (index == 0)
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: 'Thank you  ',
                              style: TextStyle(
                                color: matteBlackColor,
                                fontSize: screenHeight(context) * 0.018,
                              ),
                              children: [
                                TextSpan(
                                  text: widget.productForRating.userName
                                      .split(' ')[0],
                                  style: TextStyle(
                                    color: matteBlackColor,
                                    fontSize: screenHeight(context) * 0.05,
                                    fontFamily: 'Whisper',
                                  ),
                                ),
                                TextSpan(
                                  text: ",  for choosing us.",
                                  style: TextStyle(
                                    color: matteBlackColor,
                                    fontSize: screenHeight(context) * 0.018,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "\nWe hope you enjoyed your drinks! Your feedback is important to us, and we'd love to hear about your experience.",
                                  style: TextStyle(
                                    color: textSubHeadingColor,
                                    fontSize: screenHeight(context) * 0.018,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (index == 0)
                          SizedBox(height: screenHeight(context) * 0.02),
                        Container(
                          height: screenHeight(context) * 0.2,
                          padding: EdgeInsets.all(screenHeight(context) * 0.01),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.zero,
                            border: Border.all(
                              color: iconColor,
                              width: 0.5,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: widget
                                        .productForRating
                                        .orderDrinks
                                        .cartItems[index]
                                        .productImage,
                                    height: screenHeight(context) * 0.06,
                                    width: screenWidth(context) * 0.2,
                                  ),
                                  SizedBox(width: screenWidth(context) * 0.02),
                                  Text(
                                    widget.productForRating.orderDrinks
                                        .cartItems[index].productName,
                                    style: TextStyle(
                                      color: matteBlackColor,
                                      fontSize: screenHeight(context) * 0.022,
                                    ),
                                  ),
                                ],
                              ),
                              MySeparator(
                                height: 1,
                                color: iconColor,
                                padding: screenHeight(context) * 0.01,
                                width: screenWidth(context) * 0.01,
                              ),
                              Expanded(
                                child: StarRatingWidget(
                                  productId: widget.productForRating.orderDrinks
                                      .cartItems[index].productId,
                                  index: index,
                                  ratings: _ratings,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight(context) * 0.02),
                        if (index ==
                            widget.productForRating.orderDrinks.cartItems
                                    .length -
                                1)
                          Container(
                            height: screenHeight(context) * 0.2,
                            padding:
                                EdgeInsets.all(screenHeight(context) * 0.01),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.zero,
                              border: Border.all(
                                color: iconColor,
                                width: 0.5,
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl:
                                          "https://firebasestorage.googleapis.com/v0/b/coffee-cafe-app-45ff3.appspot.com/o/coffeeDrinkersData%2Fs3yWeax9pigjDWhTOnZBU3VIgf92%2FprofileImage%2F1710071135308?alt=media&token=a537806c-43ae-43af-8417-94d7b14af465",
                                      height: screenHeight(context) * 0.06,
                                      width: screenWidth(context) * 0.2,
                                    ),
                                    SizedBox(
                                        width: screenWidth(context) * 0.02),
                                    Text(
                                      "Coffee Cafe App",
                                      style: TextStyle(
                                        color: matteBlackColor,
                                        fontSize: screenHeight(context) * 0.022,
                                      ),
                                    ),
                                  ],
                                ),
                                MySeparator(
                                  height: 1,
                                  color: iconColor,
                                  padding: screenHeight(context) * 0.01,
                                  width: screenWidth(context) * 0.01,
                                ),
                                Expanded(
                                  child: StarRatingWidget(
                                    productId: widget.productForRating.orderId,
                                    index: widget.productForRating.orderDrinks
                                        .cartItems.length,
                                    ratings: _ratings,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    );
                  },
                  // separatorBuilder: (context, index) {
                  //   return SizedBox(height: screenHeight(context) * 0.02);
                  // },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.white),
                      elevation: WidgetStateProperty.all(0),
                      side: WidgetStateProperty.all(
                          const BorderSide(color: greenColor)),
                      minimumSize: WidgetStateProperty.all(Size(
                        screenWidth(context) * 0.35,
                        screenHeight(context) * 0.05,
                      )),
                      overlayColor: WidgetStateProperty.resolveWith<Color?>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.pressed)) {
                            return splashColor; // Splash color
                          }
                          return null; // Use the component's default.
                        },
                      ),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero, // No rounded corners
                        ),
                      ),
                    ),
                    child: Text(
                      'Not Now',
                      style: TextStyle(
                        fontSize: screenHeight(context) * 0.02,
                        color: greenColor,
                        fontFamily: 'inter',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isRatingUploading = true;
                      });
                      try {
                        await fireStore.runTransaction((transaction) async {
                          final List<Map<DocumentReference, List<dynamic>>>
                              updates = [];
                          for (int i = 0;
                              i <
                                  widget.productForRating.orderDrinks.cartItems
                                      .length;
                              i++) {
                            final DocumentReference documentReference =
                                fireStore
                                    .collection('products')
                                    .doc(_ratings[i].keys.first);

                            final DocumentSnapshot snapshot =
                                await transaction.get(documentReference);
                            List<dynamic> ratings = snapshot['rating'];
                            ratings.add(_ratings[i].values.first);
                            updates.add({documentReference: ratings});
                          }
                          for (int i = 0;
                              i <
                                  widget.productForRating.orderDrinks.cartItems
                                      .length;
                              i++) {
                            log("ratings: $i");
                            log("${_ratings[i].keys.first} ${_ratings[i].values.first}");

                            transaction.update(
                              updates[i].keys.first,
                              {
                                'rating': updates[i].values.first,
                              },
                            );
                          }
                        });
                        await fireStore
                            .collection('orders')
                            .doc(widget.productForRating.orderId)
                            .update({
                          'rating': _ratings[widget.productForRating.orderDrinks
                                  .cartItems.length]
                              .values
                              .first,
                        });
                      } catch (e) {
                        log(e.toString());
                      }
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: greenColor,
                      elevation: 0,
                      minimumSize: Size(screenWidth(context) * 0.35,
                          screenHeight(context) * 0.05),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero, // No rounded corners
                      ),
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: screenHeight(context) * 0.02,
                        color: Colors.white,
                        fontFamily: 'inter',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
