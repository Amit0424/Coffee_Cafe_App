import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:coffee_cafe_app/main.dart';
import 'package:coffee_cafe_app/screens/cart_screen/models/cart_model.dart';
import 'package:coffee_cafe_app/screens/cart_screen/utils/decrease_product_quantity_function.dart';
import 'package:coffee_cafe_app/screens/cart_screen/utils/increase_product_quantity_function.dart';
import 'package:coffee_cafe_app/screens/parent_screen/providers/parent_provider.dart';
import 'package:coffee_cafe_app/screens/place_order_screen/place_order_screen.dart';
import 'package:coffee_cafe_app/utils/data_base_constants.dart';
import 'package:coffee_cafe_app/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  static String routeName = '/cartScreen';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double totalPrice = 0;

  @override
  Widget build(BuildContext context) {
    final ParentProvider parentProvider = Provider.of<ParentProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 3,
          shadowColor: Colors.grey[300],
          surfaceTintColor: Colors.white,
          systemOverlayStyle: const SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.light,
          ),
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
          SizedBox(
            height: screenHeight(context) * 0.02,
          ),
          Expanded(
            child: StreamBuilder(
              stream: fireStore
                  .collection('userCart')
                  .doc(DBConstants().userID())
                  .snapshots(),
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
                }
                if (!snapshot.hasData ||
                    snapshot.data!.data()?['cartItems'].isEmpty) {
                  return SizedBox(
                    width: screenWidth(context),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/svgs/empty_cart.svg',
                          height: screenHeight(context) * 0.2,
                          color: matteBlackColor,
                        ),
                        Text(
                          "Don't you feel like drink coffee today?\nAdd some products to your cart!",
                          style: TextStyle(
                            fontSize: screenHeight(context) * 0.016,
                            fontWeight: FontWeight.w500,
                            color: greenColor,
                            fontFamily: 'inter',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(
                      child: Text(
                          'Error loading cart items\nCheck your internet connection'));
                }
                if (snapshot.hasData) {
                  try {
                    CartModel cartModel = CartModel.fromMap(
                        snapshot.data!.data() as Map<String, dynamic>);
                    totalPrice = cartModel.cartItems
                        .fold(0, (sum, product) => sum + product.productPrice);

                    return Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            itemCount: cartModel.cartItems.length,
                            itemBuilder: (context, index) {
                              final product = cartModel.cartItems[index];

                              return Container(
                                color: lightGreenColor,
                                margin: EdgeInsets.symmetric(
                                  horizontal: screenWidth(context) * 0.045,
                                ),
                                height: screenHeight(context) * 0.15,
                                child: Row(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: product.productImage,
                                      height: screenHeight(context) * 0.2,
                                      width: screenWidth(context) * 0.35,
                                      fit: BoxFit.cover,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: screenHeight(context) * 0.005,
                                        ),
                                        Container(
                                          width: screenWidth(context) * 0.55,
                                          padding: EdgeInsets.only(
                                            left: screenWidth(context) * 0.03,
                                          ),
                                          child: Text(
                                            product.productName,
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
                                            '₹ ${product.productPrice.toInt()}',
                                            style: TextStyle(
                                              color: greenColor,
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
                                            product.productSize,
                                            style: TextStyle(
                                              color: matteBlackColor
                                                  .withOpacity(0.5),
                                              fontSize:
                                                  screenHeight(context) * 0.013,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: screenHeight(context) * 0.01,
                                        ),
                                        Container(
                                          // height: screenHeight(context) * 0.04,
                                          width: screenWidth(context) * 0.56,
                                          padding: EdgeInsets.symmetric(
                                            vertical:
                                                screenHeight(context) * 0.005,
                                          ),
                                          color: const Color(0xffe3f1eb),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  decreaseQuantity(context,
                                                      product, cartModel);
                                                },
                                                child: Container(
                                                  height:
                                                      screenHeight(context) *
                                                          0.03,
                                                  width: screenWidth(context) *
                                                      0.1,
                                                  padding: EdgeInsets.only(
                                                      top:
                                                          product.productQuantity ==
                                                                  1
                                                              ? 3
                                                              : 0),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Color(0xffc0dfd2),
                                                  ),
                                                  child: Center(
                                                    child:
                                                        product.productQuantity ==
                                                                1
                                                            ? SvgPicture.asset(
                                                                'assets/images/svgs/delete.svg',
                                                                color: redColor,
                                                              )
                                                            : Icon(
                                                                Icons.remove,
                                                                color:
                                                                    matteBlackColor,
                                                              ),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                product.productQuantity
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
                                                onTap: () {
                                                  increaseQuantity(context,
                                                      product, cartModel);
                                                },
                                                child: Container(
                                                  height:
                                                      screenHeight(context) *
                                                          0.03,
                                                  width: screenWidth(context) *
                                                      0.1,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Color(0xffc0dfd2),
                                                  ),
                                                  child: Icon(
                                                    Icons.add,
                                                    color: matteBlackColor,
                                                  ),
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
                            separatorBuilder:
                                (BuildContext context, int index) {
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
                          // color: const Color(0xffe3f1eb),
                          height: screenHeight(context) * 0.08,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                    '₹ ${totalPrice.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: greenColor,
                                      fontSize: screenHeight(context) * 0.02,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.bottomToTop,
                                      duration:
                                          const Duration(milliseconds: 800),
                                      child: PlaceOrderScreen(
                                        products: cartModel,
                                        isFromCart: true,
                                        totalAmount: totalPrice,
                                      ),
                                    ),
                                  );
                                },
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
                                  'Confirm Order',
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
                  } catch (e) {
                    log(e.toString());
                    fireStore
                        .collection('userCart')
                        .doc(DBConstants().userID())
                        .set({
                      'cartItems': [],
                    });
                  }
                }
                return const LoadingWidget();
              },
            ),
          ),
        ],
      ),
    );
  }
}
