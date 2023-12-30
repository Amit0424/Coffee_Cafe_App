import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_cafe_app/constants/cool_icons.dart';
import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:coffee_cafe_app/models/profile_model.dart';
import 'package:coffee_cafe_app/providers/favorite_provider.dart';
import 'package:coffee_cafe_app/screens/contact_us_screen.dart';
import 'package:coffee_cafe_app/screens/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:coffee_cafe_app/screens/favorite_screen.dart';
import 'package:provider/provider.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  static const IconData settingsFuture = CoolIconsData(0xea42);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final userID = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    final favCounter = Provider.of<FavoriteProvider>(context);
    return Drawer(
      backgroundColor: Colors.white,
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
          accountName: Container(
            width: double.infinity,
            height: 22,
            decoration: const BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                topLeft: Radius.circular(10),
              ),
            ),
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Text(
              profile.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textDirection: TextDirection.rtl,
            ),
          ),
          accountEmail: Container(
            width: double.infinity,
            height: 22,
            padding: const EdgeInsets.only(left: 10, right: 10),
            decoration: const BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                topLeft: Radius.circular(10),
              ),
            ),
            child: Text(
              profile.email,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textDirection: TextDirection.rtl,
            ),
          ),
          currentAccountPicture: CircleAvatar(
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: profile.profileImageUrl,
                // 'https://i.pinimg.com/1200x/df/ee/81/dfee81d3be1ed3dffdd248110f03d7d0.jpg',
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.redAccent,
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                profile.profileBackgroundImageUrl,
                // 'https://wallpapercave.com/wp/wp4489041.jpg',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        ListTile(
          trailing: ClipOval(
            child: Container(
              color: Colors.red,
              width: 20,
              height: 20,
              child: Center(
                child: Text(
                  favCounter.count.toString(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          leading: const Icon(
            CoolIconsData(0xe9ab),
            color: Colors.black54,
          ),
          title: const Text(
            'Favorites',
            style: kNavBarTextStyle,
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
            color: Colors.black54,
          ),
          title: const Text(
            'Friends',
            style: kNavBarTextStyle,
          ),
          onTap: () {
            log('Friends');
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.share,
            color: Colors.black54,
          ),
          title: const Text(
            'Share',
            style: kNavBarTextStyle,
          ),
          onTap: () {
            log('Share');
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.notifications_rounded,
            color: Colors.black54,
          ),
          title: const Text(
            'Request',
            style: kNavBarTextStyle,
          ),
          onTap: () {
            log('Request');
          },
        ),
        const Divider(thickness: 2),
        ListTile(
          leading: const Icon(
            NavBar.settingsFuture,
            color: Colors.black54,
          ),
          title: const Text(
            'Settings',
            style: kNavBarTextStyle,
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
            color: Colors.black54,
          ),
          title: const Text(
            'Privacies & Policies',
            style: kNavBarTextStyle,
          ),
          onTap: () {
            log('Policies');
          },
        ),
        const Divider(thickness: 2),
        ListTile(
          leading: const Icon(
            Icons.call,
            color: Colors.black54,
          ),
          title: const Text(
            'Contact Us',
            style: kNavBarTextStyle,
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => const ContactUsScreen(),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.exit_to_app,
            color: Colors.black54,
          ),
          title: const Text(
            'Exit',
            style: kNavBarTextStyle,
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
