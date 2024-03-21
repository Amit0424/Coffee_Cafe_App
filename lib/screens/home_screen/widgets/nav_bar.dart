import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_cafe_app/constants/cool_icons.dart';
import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:coffee_cafe_app/main.dart';
import 'package:coffee_cafe_app/screens/authentication_screen/widgets/exit_dialog.dart';
import 'package:coffee_cafe_app/screens/contact_us_screen/contact_us_screen.dart';
import 'package:coffee_cafe_app/screens/favorite_screen/favorite_screen.dart';
import 'package:coffee_cafe_app/screens/profile_screen/providers/gender_selection_provider.dart';
import 'package:coffee_cafe_app/screens/profile_screen/providers/profile_provider.dart';
import 'package:coffee_cafe_app/screens/setting_screen/settings_screen.dart';
import 'package:coffee_cafe_app/utils/data_base_constants.dart';
import 'package:coffee_cafe_app/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../profile_screen/profile_model/profile_model.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  static const IconData settingsFuture = CoolIconsData(0xea42);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  int _favoriteCount = 0;

  Stream<int> getFavoriteProductsCount() {
    return fireStore
        .collection('products')
        .orderBy('name', descending: false)
        .where('zFavoriteUsersList', arrayContains: DBConstants().userID())
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  @override
  Widget build(BuildContext context) {
    final ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context);
    final GenderSelectionProvider genderProvider =
        Provider.of<GenderSelectionProvider>(context);
    final gender = genderProvider.selectedGender;
    return Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: screenHeight(context) * 0.028,
                    decoration: BoxDecoration(
                      color: matteBlackColor.withOpacity(0.7),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        topLeft: Radius.circular(30),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Center(
                      child: Text(
                        profileProvider.profileModelMap['name'],
                        style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: screenHeight(context) * 0.016,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ),
                ],
              ),
              accountEmail: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: screenHeight(context) * 0.028,
                    decoration: BoxDecoration(
                      color: matteBlackColor.withOpacity(0.7),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        topLeft: Radius.circular(30),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Center(
                      child: Text(
                        profileProvider.profileModelMap['email'],
                        style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: screenHeight(context) * 0.016,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ),
                ],
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage(
                    'assets/images/pngs/${gender == Gender.female ? 'girl' : gender == Gender.male ? 'boy' : 'other'}_profile.png'),
                radius: screenHeight(context) * 0.04,
                backgroundColor: Colors.transparent,
                foregroundImage: profileProvider
                                .profileModelMap['profileImageUrl'] !=
                            null &&
                        profileProvider.profileModelMap['profileImageUrl'] != ''
                    ? CachedNetworkImageProvider(
                        profileProvider.profileModelMap['profileImageUrl'])
                    : null,
              ),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    profileProvider.profileModelMap[
                                    'profileBackgroundImageUrl'] !=
                                null &&
                            profileProvider.profileModelMap[
                                    'profileBackgroundImageUrl'] !=
                                ''
                        ? profileProvider
                            .profileModelMap['profileBackgroundImageUrl']
                        : 'https://assets-global.website-files.com/5a9ee6416e90d20001b20038/6289f5f9c122094a332133d2_dark-gradient.png',
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
                  child: StreamBuilder<int>(
                      stream: getFavoriteProductsCount(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          _favoriteCount = snapshot.data!;
                          return Center(
                            child: Text(
                              _favoriteCount.toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        } else {
                          return const Center(
                            child: LoadingWidget(),
                          );
                        }
                      }),
                ),
              ),
              leading: const Icon(
                CoolIconsData(0xe9ab),
                color: Colors.black54,
              ),
              title: Text(
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
              title: Text(
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
              title: Text(
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
              title: Text(
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
                CustomDrawer.settingsFuture,
                color: Colors.black54,
              ),
              title: Text(
                'Settings',
                style: kNavBarTextStyle,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (ctx) => const SettingsScreen()));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.description,
                color: Colors.black54,
              ),
              title: Text(
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
              title: Text(
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
              title: Text(
                'Exit',
                style: kNavBarTextStyle,
              ),
              onTap: () {
                Navigator.pop(context);
                showExitDialog(context);
              },
            ),
          ],
        ));
  }
}
