import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:coffee_cafe_app/screens/cart_screen/cart_providers/cart_provider.dart';
import 'package:coffee_cafe_app/screens/order_placed_screen/order_placed_screen.dart';
import 'package:coffee_cafe_app/widgets/custom_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  static String routeName = '/cartScreen';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final userID = FirebaseAuth.instance.currentUser!.uid;
  List<String> cartItemIds = [];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Cart',
        rightIconColor: Colors.transparent,
        rightIconData: Icons.shopping_cart,
        rightIconFunction: () {},
        leftIconFunction: () {
          Navigator.pop(context);
        },
        leftIconData: Icons.arrow_back_ios,
        leftIconColor: Colors.transparent,
      ),
      // body: StreamBuilder<QuerySnapshot>(
      //   stream: FirebaseFirestore.instance
      //       .collection('cart')
      //       .doc(userID)
      //       .collection('cart')
      //       .snapshots(),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasError) {
      //       return const Text('Something went wrong');
      //     }
      //     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      //       return const Center(
      //         child: Padding(
      //           padding: EdgeInsets.all(10.0),
      //           child: Text(
      //             "Don't you like my coffee?😔\nSo order fast add your coffee to your cart.",
      //             style: TextStyle(
      //                 fontSize: 16,
      //                 fontWeight: FontWeight.bold,
      //                 color: greenColor),
      //             textAlign: TextAlign.center,
      //           ),
      //         ),
      //       );
      //     }
      //     if (snapshot.hasData) {
      //       List<Item> items = snapshot.data!.docs
      //           .map((doc) => Item.fromJson(doc.data() as Map<String, dynamic>))
      //           .toList();
      //
      //       return ListView.builder(
      //         itemCount: items.length,
      //         itemBuilder: (context, index) {
      //           final item = items[index];
      //           final isCart = cartItemIds.contains(item.id);
      //
      //           return const Padding(
      //             padding: EdgeInsets.only(left: 10.0, right: 10.0),
      //             child: Text('Cart Item'),
      //           );
      //         },
      //       );
      //     }
      //
      //     return const LoadingWidget();
      //   },
      // ),
      bottomNavigationBar: Container(
        height: 70,
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.money_outlined,
                      size: 20,
                    ),
                    Text(
                      'Pay using',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.arrow_upward_outlined,
                      size: 15,
                    )
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                const Text(
                  'Cash on Delivery',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              width: screenWidth * 0.66 - 40,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: greenColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '\$${cart.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'TOTAL',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => const OrderPlacedScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Place Order',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
