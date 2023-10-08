import 'dart:developer';
import 'dart:io';

import 'package:coffee_cafe_app/constants/cool_icons.dart';
import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:coffee_cafe_app/screens/settings_screen.dart';
import 'package:flutter/material.dart';

import '../screens/favorite_screen.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  static const IconData settingsFuture = CoolIconsData(0xea42);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
          accountName: const Text('Amit Choudhary'),
          accountEmail: const Text('amitjat2406@gmail.com'),
          currentAccountPicture: CircleAvatar(
            child: ClipOval(
              child: Image.network(
                'https://i.pinimg.com/1200x/df/ee/81/dfee81d3be1ed3dffdd248110f03d7d0.jpg',
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
          ),
          decoration: const BoxDecoration(
            color: Colors.redAccent,
            image: DecorationImage(
              image: NetworkImage(
                'https://wallpapercave.com/wp/wp4489041.jpg',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(
            CoolIconsData(0xe9ab),
            color: Colors.black,
          ),
          title: const Text(
            'Favorites',
            style: navBarTextStyle,
          ),
          onTap: () {
            log('Favorite');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FavoriteScreen(),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.people,
            color: Colors.black,
          ),
          title: const Text(
            'Friends',
            style: navBarTextStyle,
          ),
          onTap: () {
            log('Friends');
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.share,
            color: Colors.black,
          ),
          title: const Text(
            'Share',
            style: navBarTextStyle,
          ),
          onTap: () {
            log('Share');
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.notifications_rounded,
            color: Colors.black,
          ),
          title: const Text(
            'Request',
            style: navBarTextStyle,
          ),
          trailing: ClipOval(
            child: Container(
              color: Colors.red,
              width: 20,
              height: 20,
              child: const Center(
                child: Text(
                  '8',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
          onTap: () {
            log('Request');
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(
            settingsFuture,
            color: Colors.black,
          ),
          title: const Text(
            'Settings',
            style: navBarTextStyle,
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (ctx) => const SettingsScreen()));
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.description,
            color: Colors.black,
          ),
          title: const Text(
            'Privacies & Policies',
            style: navBarTextStyle,
          ),
          onTap: () {
            log('Policies');
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(
            Icons.exit_to_app,
            color: Colors.black,
          ),
          title: const Text(
            'Exit',
            style: navBarTextStyle,
          ),
          onTap: () {
            log('exit');
            exit(0);
          },
        ),
      ],
    ));
  }
}
