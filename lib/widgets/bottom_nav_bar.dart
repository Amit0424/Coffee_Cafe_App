import 'dart:async';

import 'package:coffee_cafe_app/constants/cool_icons.dart';
import 'package:coffee_cafe_app/screens/cart_screen/cart_providers/cart_provider.dart';
import 'package:coffee_cafe_app/screens/cart_screen/cart_screen.dart';
import 'package:coffee_cafe_app/screens/favorite_screen/favorite_providers/favorite_provider.dart';
import 'package:coffee_cafe_app/screens/favorite_screen/favorite_screen.dart';
import 'package:coffee_cafe_app/screens/global_chat_screen/chat_screen.dart';
import 'package:coffee_cafe_app/screens/profile_screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'navigation_buttons.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar({super.key});

  final StreamController<int> favCounterController = StreamController<int>();

  @override
  Widget build(BuildContext context) {
    final favoriteCount = Provider.of<FavoriteProvider>(context);
    final cartCount = Provider.of<CartProvider>(context);
    return Container(
      height: 50,
      color: Colors.transparent,
      margin: const EdgeInsets.only(top: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          NavigationButtons(
            icon: Icons.home_outlined,
            title: 'Home',
            onPressed: () {},
          ),
          Badge(
            label: Text(
              favoriteCount.count.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            child: NavigationButtons(
              icon: Icons.favorite_border_outlined,
              title: 'Favorite',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavoriteScreen(),
                  ),
                );
              },
            ),
          ),
          NavigationButtons(
            icon: const CoolIconsData(0xe926),
            title: 'Chat',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatScreen(),
                ),
              );
            },
          ),
          Badge(
            label: Text(
              cartCount.count.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            child: NavigationButtons(
              icon: Icons.shopping_cart_outlined,
              title: 'Cart',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CartScreen(),
                  ),
                );
              },
            ),
          ),
          NavigationButtons(
            icon: const CoolIconsData(0xea89),
            title: 'Profile',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => const ProfileScreen(
                            buttonName: 'Update',
                          )));
            },
          ),
        ],
      ),
    );
  }
}
//
