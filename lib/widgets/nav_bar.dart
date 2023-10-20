import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_cafe_app/constants/cool_icons.dart';
import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:coffee_cafe_app/screens/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:coffee_cafe_app/screens/favorite_screen.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  static const IconData settingsFuture = CoolIconsData(0xea42);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final userID = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    log(getUserName(userID).toString());
  }

  Future<String> getUserName(String userId) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userDoc['name'];
  }

  Future<String> getUserEmail(String userId) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userDoc['email'];
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
          accountName: FutureBuilder<String>(
            future: getUserName(userID),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              String userName = snapshot.data ?? 'Anonymous';
              return Text(userName, style: const TextStyle(fontWeight: FontWeight.bold),);
            },
          ),
          accountEmail: FutureBuilder<String>(
          future: getUserEmail(userID),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          String userEmail = snapshot.data ?? 'Anonymous';
          return Text(userEmail, style: const TextStyle(fontWeight: FontWeight.bold),);
          },
          ),
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
            NavBar.settingsFuture,
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
