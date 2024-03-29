import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:coffee_cafe_app/main.dart';
import 'package:coffee_cafe_app/utils/data_base_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../parent_screen/providers/parent_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  static String routeName = '/cartScreen';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double totalPrice = 0;
  Future<List<Map<String, dynamic>>> fetchCartItems() async {
    final DocumentSnapshot userCartSnapshot = await fireStore
        .collection('userCart')
        .doc(DBConstants().userID())
        .get();
    if (userCartSnapshot.exists) {
      Map<String, dynamic>? data =
          userCartSnapshot.data() as Map<String, dynamic>?;

      return List<Map<String, dynamic>>.from(data?['cartItems'] ?? []);
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final ParentProvider parentProvider = Provider.of<ParentProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: appBarTitle(context, 'Cart'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              parentProvider.currentIndex = 0;
            },
          )),
      body: Column(
        children: [
          Container(
            height: screenHeight(context) * 0.829,
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchCartItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.separated(
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return Shimmer.fromColors(
                        baseColor: const Color(0xfff1f1f1),
                        highlightColor: Colors.white,
                        child: Container(
                          color: Colors.white,
                          margin: EdgeInsets.symmetric(
                            horizontal: screenWidth(context) * 0.045,
                          ),
                          height: screenHeight(context) * 0.15,
                          width: screenWidth(context),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: screenHeight(context) * 0.02,
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading cart items'));
                } else {
                  List<Map<String, dynamic>> cartItems = snapshot.data ?? [];
                  totalPrice = cartItems.fold(
                      0, (sum, product) => sum + product['productPrice']);

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final product = cartItems[index];
                            return Container(
                              color: const Color(0xffc0dfd2),
                              margin: EdgeInsets.symmetric(
                                horizontal: screenWidth(context) * 0.045,
                              ),
                              height: screenHeight(context) * 0.15,
                              child: Row(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: product['productImage'],
                                    height: screenHeight(context) * 0.2,
                                    width: screenWidth(context) * 0.35,
                                    fit: BoxFit.cover,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: screenHeight(context) * 0.005,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: screenWidth(context) * 0.03,
                                        ),
                                        child: Text(
                                          product['productName'],
                                          style: TextStyle(
                                            color: matteBlackColor,
                                            fontSize:
                                                screenHeight(context) * 0.016,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: screenWidth(context) * 0.03,
                                        ),
                                        child: Text(
                                          '₹ ${product['productPrice']}',
                                          style: TextStyle(
                                            color: greenColor,
                                            fontSize:
                                                screenHeight(context) * 0.02,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: screenWidth(context) * 0.03,
                                        ),
                                        child: Text(
                                          'Size: ${product['productSize']}',
                                          style: TextStyle(
                                            color: matteBlackColor
                                                .withOpacity(0.5),
                                            fontSize:
                                                screenHeight(context) * 0.016,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: screenHeight(context) * 0.01,
                                      ),
                                      Container(
                                        height: screenHeight(context) * 0.045,
                                        width: screenWidth(context) * 0.56,
                                        color: const Color(0xffe3f1eb),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            GestureDetector(
                                              onTap: () {},
                                              child: Container(
                                                height: screenHeight(context) *
                                                    0.03,
                                                width:
                                                    screenWidth(context) * 0.1,
                                                padding: EdgeInsets.only(
                                                    top:
                                                        product['productQuantity'] ==
                                                                1
                                                            ? 3
                                                            : 0),
                                                decoration: const BoxDecoration(
                                                  color: Color(0xffc0dfd2),
                                                ),
                                                child: Center(
                                                  child:
                                                      product['productQuantity'] ==
                                                              1
                                                          ? SvgPicture.asset(
                                                              'assets/images/svgs/delete.svg',
                                                              color: redColor,
                                                            )
                                                          : const Icon(
                                                              Icons.remove),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              product['productQuantity']
                                                  .toString(),
                                              style: TextStyle(
                                                color: greenColor,
                                                fontSize:
                                                    screenHeight(context) *
                                                        0.02,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {},
                                              child: Container(
                                                height: screenHeight(context) *
                                                    0.03,
                                                width:
                                                    screenWidth(context) * 0.1,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xffc0dfd2),
                                                ),
                                                child: const Icon(Icons.add),
                                              ),
                                            ),
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
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth(context) * 0.045,
                        ),
                        color: const Color(0xffe3f1eb),
                        height: screenHeight(context) * 0.08,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                height: screenHeight(context) * 0.05,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Sub Total (before tax):',
                                      style: TextStyle(
                                        color: matteBlackColor,
                                        fontSize: screenHeight(context) * 0.016,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '₹ $totalPrice',
                                      style: TextStyle(
                                        color: greenColor,
                                        fontSize: screenHeight(context) * 0.02,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: greenColor,
                                elevation: 0,
                                minimumSize: Size(screenWidth(context) * 0.35,
                                    screenHeight(context) * 0.05),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.zero, // No rounded corners
                                ),
                              ),
                              child: Text(
                                'Place Order',
                                style: TextStyle(
                                  fontSize: screenHeight(context) * 0.02,
                                  color: Colors.white,
                                  fontFamily: 'inter',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
