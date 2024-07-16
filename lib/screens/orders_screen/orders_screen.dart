import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:coffee_cafe_app/main.dart';
import 'package:coffee_cafe_app/screens/orders_screen/models/order_model.dart';
import 'package:coffee_cafe_app/screens/place_order_screen/place_order_screen.dart';
import 'package:coffee_cafe_app/utils/data_base_constants.dart';
import 'package:coffee_cafe_app/widgets/loading_widget.dart';
import 'package:coffee_cafe_app/widgets/my_separator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int rating = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: matteBlackColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: appBarTitle(context, 'My Orders'),
      ),
      body: StreamBuilder(
        stream: fireStore
            .collection('orders')
            .where('userId', isEqualTo: DBConstants().userID())
            .orderBy('orderTime', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: LoadingWidget(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No orders placed yet'),
            );
          }
          return SizedBox(
            height: screenHeight(context) * 0.9,
            child: ListView.separated(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                int? makingTime = 0;
                int totalMakingTime = 0;
                final OrderModel orderData =
                    OrderModel.fromDocument(snapshot.data!.docs[index]);
                for (int i = 0;
                    i < orderData.orderDrinks.cartItems.length;
                    i++) {
                  makingTime =
                      orderData.orderDrinks.cartItems[i].productMakingTime;
                  totalMakingTime += makingTime;
                }
                return Container(
                  width: screenWidth(context) * 0.9,
                  margin: EdgeInsets.only(
                    left: screenWidth(context) * 0.045,
                    right: screenWidth(context) * 0.045,
                    bottom: index == snapshot.data!.docs.length - 1
                        ? screenHeight(context) * 0.02
                        : 0,
                    top: index == 0 ? screenHeight(context) * 0.02 : 0,
                  ),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CachedNetworkImage(
                            imageUrl: orderData.profileImage,
                            height: screenHeight(context) * 0.1,
                            width: screenWidth(context) * 0.2,
                            fit: BoxFit.fill,
                          ),
                          SizedBox(
                            width: screenWidth(context) * 0.03,
                          ),
                          SizedBox(
                            height: screenHeight(context) * 0.1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  orderData.orderName,
                                  style: TextStyle(
                                    color: matteBlackColor,
                                    fontSize: screenHeight(context) * 0.02,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth(context) * 0.43,
                                  child: Text(
                                    orderData.address,
                                    style: TextStyle(
                                      color: iconColor,
                                      fontSize: screenHeight(context) * 0.012,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '$totalMakingTime mins',
                                  style: TextStyle(
                                    color: textSubHeadingColor,
                                    fontSize: screenHeight(context) * 0.014,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.transparent,
                            width: screenWidth(context) * 0.203,
                            height: screenHeight(context) * 0.1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  orderData.orderStatus,
                                  style: TextStyle(
                                    color: orderData.orderStatus == 'Cancelled'
                                        ? redColor
                                        : orderData.orderStatus == 'Served'
                                            ? matteBlackColor
                                            : orderData.orderStatus ==
                                                    'Preparing'
                                                ? yellowColor
                                                : greenColor,
                                    fontSize: screenHeight(context) * 0.012,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Order Id\n${orderData.orderNumber}',
                                  style: TextStyle(
                                    color: matteBlackColor,
                                    fontSize: screenHeight(context) * 0.012,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ],
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
                      SizedBox(
                        height: screenHeight(context) *
                            0.031 *
                            orderData.orderDrinks.cartItems.length,
                        child: ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  Text(
                                    '${orderData.orderDrinks.cartItems[index].productQuantity} x ',
                                    style: TextStyle(
                                      color: brownColor,
                                      fontFamily: 'inter',
                                      fontSize: screenHeight(context) * 0.014,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${orderData.orderDrinks.cartItems[index].productName} ',
                                    style: TextStyle(
                                      color: matteBlackColor,
                                      fontSize: screenHeight(context) * 0.016,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '(${orderData.orderDrinks.cartItems[index].productSize})',
                                    style: TextStyle(
                                      color: textSubHeadingColor,
                                      fontSize: screenHeight(context) * 0.014,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: screenHeight(context) * 0.01,
                              );
                            },
                            itemCount: orderData.orderDrinks.cartItems.length),
                      ),
                      Divider(
                        color: iconColor,
                        thickness: 0.7,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat("MMMM d, y 'at' h:mm a")
                                .format(orderData.orderTime),
                            style: TextStyle(
                              color: iconColor,
                              fontSize: screenHeight(context) * 0.014,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '₹ ${orderData.payableAmount}',
                            style: TextStyle(
                              color: greenColor,
                              fontSize: screenHeight(context) * 0.016,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      if (orderData.orderStatus == 'Served' &&
                          orderData.rating >= 0)
                        Divider(
                          color: iconColor,
                          thickness: 0.7,
                        ),
                      if (orderData.orderStatus == 'Served' &&
                          orderData.rating >= 0)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'You Rated',
                              style: TextStyle(
                                color: matteBlackColor,
                                fontSize: screenHeight(context) * 0.014,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Container(
                            //   padding: EdgeInsets.symmetric(
                            //     horizontal: screenWidth(context) * 0.02,
                            //   ),
                            //   height: screenHeight(context) * 0.035,
                            //   width: screenWidth(context) * 0.4,
                            //   child: ListView.separated(
                            //     scrollDirection: Axis.horizontal,
                            //     itemCount: 5,
                            //     itemBuilder: (context, index) {
                            //       return GestureDetector(
                            //         onTap: () async {
                            //           if (orderData.rating == 0) {
                            //             await fireStore
                            //                 .collection('orders')
                            //                 .doc(orderData.orderId)
                            //                 .update({'rating': index + 1});
                            //           }
                            //         },
                            //         child: Icon(
                            //           orderData.rating - 1 >= 0 &&
                            //                   index <= orderData.rating - 1
                            //               ? Icons.star
                            //               : Icons
                            //                   .star_border_purple500_outlined,
                            //           color: darkYellowColor,
                            //         ),
                            //       );
                            //     },
                            //     separatorBuilder: (context, index) {
                            //       return SizedBox(
                            //         width: screenWidth(context) * 0.01,
                            //       );
                            //     },
                            //   ),
                            // ),
                            SizedBox(
                              width: screenWidth(context) * 0.02,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth(context) * 0.02,
                              ),
                              height: screenHeight(context) * 0.025,
                              color: redColor,
                              child: Row(
                                children: [
                                  Text(
                                    orderData.rating.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: screenHeight(context) * 0.014,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: screenHeight(context) * 0.02,
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                double productPrice = 0;
                                double totalAmount = 0;
                                for (int i = 0;
                                    i < orderData.orderDrinks.cartItems.length;
                                    i++) {
                                  productPrice = orderData
                                      .orderDrinks.cartItems[i].productPrice;
                                  totalAmount += productPrice;
                                }
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type:
                                        PageTransitionType.rightToLeftWithFade,
                                    duration: const Duration(milliseconds: 400),
                                    child: PlaceOrderScreen(
                                      products: orderData.orderDrinks,
                                      isFromCart: false,
                                      totalAmount: totalAmount,
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: greenColor,
                                elevation: 0,
                                minimumSize: Size(screenWidth(context) * 0.15,
                                    screenHeight(context) * 0.035),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.zero, // No rounded corners
                                ),
                              ),
                              child: Row(
                                children: [
                                  Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.rotationY(math.pi),
                                    child: Icon(
                                      Icons.refresh_rounded,
                                      color: Colors.white,
                                      size: screenHeight(context) * 0.016,
                                    ),
                                  ),
                                  SizedBox(
                                    width: screenWidth(context) * 0.005,
                                  ),
                                  Text(
                                    'Reorder',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: screenHeight(context) * 0.016,
                                      fontFamily: 'inter',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: screenHeight(context) * 0.02,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
