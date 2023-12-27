import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:coffee_cafe_app/widgets/custom_app_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:coffee_cafe_app/models/favorite_model.dart';
import 'package:coffee_cafe_app/providers/cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final userID = FirebaseAuth.instance.currentUser!.uid;
  List<String> cartItemIds = [];
  @override
  void initState() {
    super.initState();
    fetchCart();
  }

  Future<void> fetchCart() async {
    final userCartDoc =
    FirebaseFirestore.instance.collection('users').doc(userID);
    final snapshot = await userCartDoc.collection('cart').get();
    setState(() {
      cartItemIds = snapshot.docs.map((doc) => doc.id).toList();
    });
  }

  Future<void> removeFromCart(Item item) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userID);
    await userDoc.collection('cart').doc(item.id).delete();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Cart',
        rightIconData: Icons.shopping_cart,
        rightIconFunction: () {},
        leftIconFunction: () {
          Navigator.pop(context);
        },
        leftIconData: Icons.arrow_back_ios,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userID)
            .collection('cart')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Don't you like my coffee?😔\nSo order fast add your coffee to your cart.",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: greenColor),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          List<Item> items = snapshot.data!.docs
              .map((doc) => Item.fromJson(doc.data() as Map<String, dynamic>))
              .toList();

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final isCart = cartItemIds.contains(item.id);

              return Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Card(
                  elevation: 3,
                  shadowColor: const Color(0x7a7a7aff),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Image(
                              height: 100,
                              width: 100,
                              image: CachedNetworkImageProvider(item.imageUrl),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    // mainAxisAlignment:
                                    //     MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        item.name,
                                        style: kProductNameTextStyle,
                                      ),
                                      const Spacer(),
                                      SvgPicture.asset('assets/images/close.svg', color: Colors.red, width: 15,),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                            foregroundColor: Colors.red,
                                            textStyle: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                            padding: const EdgeInsets.all(0)),
                                        onPressed: () {
                                          if (isCart) {
                                            setState(() async {
                                              await removeFromCart(item)
                                                  .then((value) => cart
                                                  .removeItemFromCart(item.price));
                                              cartItemIds.remove(item.id);
                                            });
                                          }
                                        },
                                        child: const Text('Remove'),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '\$${item.price.toString()}',
                                    style: kProductPriceTextStyle,
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Sub Total', style: kProductNameTextStyle,),
            Text('\$${cart.totalAmount.toStringAsFixed(2)}', style: kProductPriceTextStyle,),
          ],
        ),
      ),
    );
  }
}
