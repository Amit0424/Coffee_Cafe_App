import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:coffee_cafe_app/screens/cart_screen/models/cart_model.dart';
import 'package:coffee_cafe_app/screens/order_placed_screen/order_placed_screen.dart';
import 'package:coffee_cafe_app/screens/place_order_screen/utils/open_map.dart';
import 'package:coffee_cafe_app/widgets/modal_for_two_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen(
      {super.key,
      required this.products,
      this.isFromCart = false,
      required this.totalAmount});

  final CartModel products;
  final bool isFromCart;
  final double totalAmount;

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  TextEditingController orderNameController = TextEditingController();
  bool isOnlinePayment = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: Color(0xffe3f1eb),
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        centerTitle: true,
        title: appBarTitle(context, 'Place Order'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: widget.products.cartItems.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  // color: Colors.red,
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth(context) * 0.045,
                  ),
                  margin: EdgeInsets.only(
                    top: screenHeight(context) * (index == 0 ? 0.01 : 0),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: Colors.white,
                            width: screenWidth(context) * 0.6,
                            height: screenHeight(context) * 0.03,
                            child: Text(
                              widget.products.cartItems[index].productName,
                              style: TextStyle(
                                color: matteBlackColor,
                                // fontSize: screenHeight(context) * 0.02,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                              "${widget.products.cartItems[index].productQuantity} Qty. x ${(widget.products.cartItems[index].productPrice / widget.products.cartItems[index].productQuantity).toStringAsFixed(2)}"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              'Size: ${widget.products.cartItems[index].productSize}'),
                          Text(
                            '₹${widget.products.cartItems[index].productPrice.round()}',
                            style: TextStyle(
                              color: greenColor,
                              fontSize: screenHeight(context) * 0.02,
                              fontWeight: FontWeight.bold,
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
                  height: screenHeight(context) * 0.006,
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: screenWidth(context) * 0.04,
            ),
            padding: EdgeInsets.symmetric(
              vertical: screenHeight(context) * 0.008,
              horizontal: screenWidth(context) * 0.045,
            ),
            width: screenWidth(context),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Name For Your Order',
                  style: TextStyle(
                    color: matteBlackColor,
                    fontSize: screenHeight(context) * 0.016,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  minLines: 1,
                  keyboardType: TextInputType.text,
                  cursorColor: matteBlackColor,
                  controller: orderNameController,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    constraints: BoxConstraints.tight(
                      Size(
                        screenWidth(context) * 0.85,
                        screenHeight(context) * 0.038,
                      ),
                    ),
                    hintText: 'E.g. My Order',
                    hintStyle: TextStyle(
                      color: Colors.grey[500],
                      fontSize: screenHeight(context) * 0.015,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: matteBlackColor,
                        width: 1.5,
                      ),
                    ),
                  ),
                  onTapOutside: (value) {
                    FocusScope.of(context).unfocus();
                  },
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              vertical: screenHeight(context) * 0.01,
              horizontal: screenWidth(context) * 0.04,
            ),
            padding: EdgeInsets.only(
              bottom: screenHeight(context) * 0.01,
              top: screenHeight(context) * 0.005,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.zero,
              border: Border.all(
                color: Colors.grey,
                width: 0.8,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth(context) * 0.045,
                    vertical: screenHeight(context) * 0.005,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Drive for Drink',
                        style: TextStyle(
                          color: matteBlackColor,
                          fontSize: screenHeight(context) * 0.02,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          openMap(26.825338, 75.792416);
                        },
                        child: SvgPicture.asset(
                          'assets/images/svgs/location_pin.svg',
                          height: screenHeight(context) * 0.04,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth(context) * 0.045,
                  ),
                  child: Text(
                    'House No. 123, Street Name, City Name, State Name, Country Name, Pincode: 123456',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: screenHeight(context) * 0.015,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth(context) * 0.045,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Payment Method',
                        style: TextStyle(
                          color: matteBlackColor,
                          fontSize: screenHeight(context) * 0.02,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          modalForTwoOptions(
                            context,
                            () {
                              setState(() {
                                isOnlinePayment = false;
                              });
                            },
                            () {
                              setState(() {
                                isOnlinePayment = true;
                              });
                            },
                            'Payment Method',
                            'Cash',
                            'Online',
                            'cash_on_delivery',
                            'online_payment',
                          );
                        },
                        child: SvgPicture.asset(
                          'assets/images/svgs/edit.svg',
                          height: screenHeight(context) * 0.05,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth(context) * 0.045,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isOnlinePayment ? 'Online' : 'Cash',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: screenHeight(context) * 0.015,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Under Development'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Text(
                          'apply Coupon',
                          style: TextStyle(
                            color: greenColor,
                            fontWeight: FontWeight.bold,
                            fontSize: screenHeight(context) * 0.015,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // const Spacer(),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth(context) * 0.045,
                  vertical: screenHeight(context) * 0.02),
              decoration: const BoxDecoration(
                color: Color(0xffe3f1eb),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sub Total',
                        style: TextStyle(
                          color: matteBlackColor,
                          fontSize: screenHeight(context) * 0.016,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'inter',
                        ),
                      ),
                      Text(
                        widget.totalAmount.toStringAsFixed(2),
                        style: TextStyle(
                          color: matteBlackColor,
                          fontFamily: 'inter',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight(context) * 0.007,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Discount (10%)',
                        style: TextStyle(
                          color: matteBlackColor,
                          fontSize: screenHeight(context) * 0.016,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'inter',
                        ),
                      ),
                      Text(
                        '-${(widget.totalAmount * 0.1).toStringAsFixed(2)}',
                        style: TextStyle(
                          color: matteBlackColor,
                          fontFamily: 'inter',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight(context) * 0.007,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'CGST (5%)',
                        style: TextStyle(
                          color: matteBlackColor,
                          fontSize: screenHeight(context) * 0.016,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'inter',
                        ),
                      ),
                      Text(
                        ((widget.totalAmount - (widget.totalAmount * 0.1)) *
                                0.05)
                            .toStringAsFixed(2),
                        style: TextStyle(
                          color: matteBlackColor,
                          fontFamily: 'inter',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight(context) * 0.007,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'SGST (5%)',
                        style: TextStyle(
                          color: matteBlackColor,
                          fontSize: screenHeight(context) * 0.016,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'inter',
                        ),
                      ),
                      Text(
                        ((widget.totalAmount - (widget.totalAmount * 0.1)) *
                                0.05)
                            .toStringAsFixed(2),
                        style: TextStyle(
                          color: matteBlackColor,
                          fontFamily: 'inter',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight(context) * 0.007,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Service Charge (7%)',
                        style: TextStyle(
                          color: matteBlackColor,
                          fontSize: screenHeight(context) * 0.016,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'inter',
                        ),
                      ),
                      Text(
                        ((widget.totalAmount - (widget.totalAmount * 0.1)) *
                                0.07)
                            .toStringAsFixed(2),
                        style: TextStyle(
                          color: matteBlackColor,
                          fontFamily: 'inter',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight(context) * 0.005,
                  ),
                  const Divider(
                    color: Color(0xffc0dfd2),
                  ),
                  SizedBox(
                    height: screenHeight(context) * 0.005,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Payable (rounded off)',
                        style: TextStyle(
                          color: matteBlackColor,
                          fontSize: screenHeight(context) * 0.016,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'inter',
                        ),
                      ),
                      Text(
                        '₹ ${(widget.totalAmount - (widget.totalAmount * 0.1) + ((widget.totalAmount - (widget.totalAmount * 0.1)) * 0.05) + ((widget.totalAmount - (widget.totalAmount * 0.1)) * 0.05) + ((widget.totalAmount - (widget.totalAmount * 0.1)) * 0.07)).round()}',
                        style: TextStyle(
                          color: greenColor,
                          fontFamily: 'inter',
                          fontSize: screenHeight(context) * 0.02,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight(context) * 0.01,
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (orderNameController.text.isEmpty) {
                            orderNameController.text = 'My Order';
                          }
                          if (isOnlinePayment) {
                          } else {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeftWithFade,
                                duration: const Duration(milliseconds: 300),
                                child: OrderPlacedScreen(
                                  cartItems: widget.products,
                                  payableAmount: widget.totalAmount -
                                      (widget.totalAmount * 0.1) +
                                      ((widget.totalAmount -
                                              (widget.totalAmount * 0.1)) *
                                          0.05) +
                                      ((widget.totalAmount -
                                              (widget.totalAmount * 0.1)) *
                                          0.05) +
                                      ((widget.totalAmount -
                                                  (widget.totalAmount * 0.1)) *
                                              0.07)
                                          .round(),
                                  paymentMethod:
                                      isOnlinePayment ? 'Online' : 'Cash',
                                  orderName: orderNameController.text.trim(),
                                  isFromCart: widget.isFromCart,
                                ),
                              ),
                            );
                          }
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(
                          //     content: Text('Under Development'),
                          //     duration: Duration(seconds: 2),
                          //   ),
                          // );
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
                          isOnlinePayment ? 'Pay Now' : 'Place Order',
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
        ],
      ),
    );
  }
}
