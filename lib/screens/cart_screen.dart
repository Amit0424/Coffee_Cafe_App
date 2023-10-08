import 'package:coffee_cafe_app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Cart',
        rightIconData: Icons.shopping_cart_outlined,
        rightIconFunction: () {},
        leftIconFunction: () {
          Navigator.pop(context);
        },
        leftIconData: Icons.arrow_back_ios,
      ),
      body: const Center(
        child: Text('Cart Screen'),
      ),
    );
  }
}
