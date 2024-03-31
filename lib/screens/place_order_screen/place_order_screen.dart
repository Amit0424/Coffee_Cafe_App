import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:coffee_cafe_app/widgets/modal_for_two_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen(
      {super.key,
      required this.products,
      required this.isFromCart,
      required this.totalAmount});

  final List products;
  final bool isFromCart;
  final double totalAmount;

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  bool isOnlinePayment = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: appBarTitle(context, 'Place Order'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: widget.products.length,
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
                        children: [
                          Text(
                            widget.products[index]['productName'],
                            style: TextStyle(
                              color: matteBlackColor,
                              fontSize: screenHeight(context) * 0.02,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                              "${widget.products[index]['productQuantity']} Qty. x ${widget.products[index]['productPrice'] / widget.products[index]['productQuantity']}"),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight(context) * 0.005,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              'Size: ${widget.products[index]['productSize']}'),
                          Text(
                            '₹${widget.products[index]['productPrice']}',
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
            margin: EdgeInsets.all(
              screenHeight(context) * 0.02,
            ),
            height: screenHeight(context) * 0.2,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Under Development'),
                              duration: Duration(seconds: 2),
                            ),
                          );
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
                            'Cash in Exchange Coffee',
                            'Online Payment',
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth(context) * 0.045,
                    ),
                    child: Text(
                      isOnlinePayment
                          ? 'Online Payment'
                          : 'Cash in Exchange Coffee',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: screenHeight(context) * 0.015,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // const Spacer(),
          Container(
            height: screenHeight(context) * 0.3,
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth(context) * 0.045,
                vertical: screenHeight(context) * 0.02),
            decoration: const BoxDecoration(
              color: Color(0xffe3f1eb),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
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
                      ((widget.totalAmount - (widget.totalAmount * 0.1)) * 0.05)
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
                      ((widget.totalAmount - (widget.totalAmount * 0.1)) * 0.05)
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
                      ((widget.totalAmount - (widget.totalAmount * 0.1)) * 0.07)
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
                      'Total Payable',
                      style: TextStyle(
                        color: matteBlackColor,
                        fontSize: screenHeight(context) * 0.016,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'inter',
                      ),
                    ),
                    Text(
                      (widget.totalAmount -
                              (widget.totalAmount * 0.1) +
                              ((widget.totalAmount -
                                      (widget.totalAmount * 0.1)) *
                                  0.05) +
                              ((widget.totalAmount -
                                      (widget.totalAmount * 0.1)) *
                                  0.05) +
                              ((widget.totalAmount -
                                      (widget.totalAmount * 0.1)) *
                                  0.07))
                          .toStringAsFixed(2),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (isOnlinePayment) {
                        } else {}
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Under Development'),
                            duration: Duration(seconds: 2),
                          ),
                        );
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
                        isOnlinePayment ? 'Pay Online' : 'Confirm Order',
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
        ],
      ),
    );
  }
}
