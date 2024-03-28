import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:coffee_cafe_app/main.dart';
import 'package:coffee_cafe_app/utils/data_base_constants.dart';
import 'package:coffee_cafe_app/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              parentProvider.currentIndex = 0;
            },
          )),
      body: Column(
        children: [
          Container(
            height: screenHeight(context) * 0.749,
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchCartItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: LoadingWidget());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading cart items'));
                } else {
                  List<Map<String, dynamic>> cartItems = snapshot.data ?? [];
                  totalPrice = cartItems.fold(
                      0, (sum, item) => sum + item['productPrice']);

                  return ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return ListTile(
                        title: Text(item['productName']),
                        subtitle: Text('\$${item['productPrice']}'),
                        trailing: IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            // Implement decrement quantity logic
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          const Spacer(),
          SizedBox(
            height: screenHeight(context) * 0.08,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Sub Total: ',
                    style: TextStyle(
                      color: matteBlackColor,
                      fontSize: screenWidth(context) * 0.04,
                    ),
                    children: [
                      TextSpan(
                        text: '₹ ${totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: matteBlackColor,
                          fontSize: screenWidth(context) * 0.04,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
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
                    'Place Order',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth(context) * 0.05,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
