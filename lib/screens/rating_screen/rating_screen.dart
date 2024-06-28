import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:coffee_cafe_app/widgets/rating_bar.dart';
import 'package:flutter/material.dart';

import '../../widgets/my_separator.dart';
import '../orders_screen/models/order_model.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key, required this.productForRating});
  final OrderModel productForRating;

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  List<String> selectedFeedback = [];
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Expanded(
          child: ListView.builder(
            itemCount: widget.productForRating.orderDrinks.cartItems.length,
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
                            text:
                                widget.productForRating.userName.split(' ')[0],
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
                              imageUrl: widget.productForRating.orderDrinks
                                  .cartItems[index].productImage,
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
                        StarRatingWidget(
                          productId: widget.productForRating.orderDrinks
                              .cartItems[index].productId,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight(context) * 0.02),
                  if (index ==
                      widget.productForRating.orderDrinks.cartItems.length - 1)
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
                                imageUrl:
                                    "https://firebasestorage.googleapis.com/v0/b/coffee-cafe-app-45ff3.appspot.com/o/coffeeDrinkersData%2Fs3yWeax9pigjDWhTOnZBU3VIgf92%2FprofileImage%2F1710071135308?alt=media&token=a537806c-43ae-43af-8417-94d7b14af465",
                                height: screenHeight(context) * 0.06,
                                width: screenWidth(context) * 0.2,
                              ),
                              SizedBox(width: screenWidth(context) * 0.02),
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
                          const StarRatingWidget(
                            productId: 'coffeeCafeApp',
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
      ),
    );
  }
}
