import 'dart:async';

import 'package:coffee_cafe_app/screens/profile_screen.dart';
import 'package:flutter/material.dart';

import '../constants/cool_icons.dart';
import '../screens/cart_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/favorite_screen.dart';
import 'navigation_buttons.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar({
    super.key,
  });

  final StreamController<int> favCounterController = StreamController<int>();

  @override
  Widget build(BuildContext context) {
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
          NavigationButtons(
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
          NavigationButtons(
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
          NavigationButtons(
            icon: const CoolIconsData(0xea89),
            title: 'Profile',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (ctx) => const ProfileScreen()));
            },
          ),
        ],
      ),
    );
  }
}
//
