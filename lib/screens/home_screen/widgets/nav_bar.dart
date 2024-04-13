import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_cafe_app/constants/cool_icons.dart';
import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:coffee_cafe_app/main.dart';
import 'package:coffee_cafe_app/screens/profile_screen/providers/gender_selection_provider.dart';
import 'package:coffee_cafe_app/screens/profile_screen/providers/profile_provider.dart';
import 'package:coffee_cafe_app/utils/data_base_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../authentication_screen/widgets/exit_dialog.dart';
import '../../contact_us_screen/contact_us_screen.dart';
import '../../parent_screen/providers/parent_provider.dart';
import '../../profile_screen/profile_model/profile_model.dart';
import '../../setting_screen/settings_screen.dart';

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
    final ParentProvider parentProvider = Provider.of<ParentProvider>(context);
    return Drawer(
        backgroundColor: Colors.white,
        child: Container(
          color: Colors.white,
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
                          profileProvider.profileModelMap.name,
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
                          profileProvider.profileModelMap.email,
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
                  foregroundImage:
                      profileProvider.profileModelMap.profileImageUrl != null &&
                              profileProvider.profileModelMap.profileImageUrl !=
                                  ''
                          ? CachedNetworkImageProvider(
                              profileProvider.profileModelMap.profileImageUrl)
                          : null,
                ),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      profileProvider.profileModelMap
                                      .profileBackgroundImageUrl !=
                                  null &&
                              profileProvider.profileModelMap
                                      .profileBackgroundImageUrl !=
                                  ''
                          ? profileProvider
                              .profileModelMap.profileBackgroundImageUrl
                          : 'https://assets-global.website-files.com/5a9ee6416e90d20001b20038/6289f5f9c122094a332133d2_dark-gradient.png',
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Container(
                height: screenHeight(context) * 0.7,
                color: Colors.white,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        parentProvider.currentIndex = 1;
                      },
                      child: Container(
                        height: screenHeight(context) * 0.065,
                        color: Colors.white,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: screenWidth(context) * 0.04,
                            ),
                            SvgPicture.asset(
                              'assets/images/svgs/favorites.svg',
                              height: screenHeight(context) * 0.04,
                            ),
                            SizedBox(
                              width: screenWidth(context) * 0.04,
                            ),
                            Text(
                              'Favorites',
                              style: TextStyle(
                                color: const Color(0xff2d2d2d),
                                fontSize: screenHeight(context) * 0.018,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            ClipOval(
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
                                        child: Text(
                                          '0',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenWidth(context) * 0.04,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 1,
                      margin: EdgeInsets.only(
                        left: screenWidth(context) * 0.155,
                      ),
                      color: const Color(0xffdddddd),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Under Development'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Container(
                        color: Colors.white,
                        height: screenHeight(context) * 0.065,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: screenWidth(context) * 0.04,
                            ),
                            SvgPicture.asset(
                              'assets/images/svgs/friends.svg',
                              height: screenHeight(context) * 0.04,
                            ),
                            SizedBox(
                              width: screenWidth(context) * 0.04,
                            ),
                            Text(
                              'Friends',
                              style: TextStyle(
                                color: const Color(0xff2d2d2d),
                                fontSize: screenHeight(context) * 0.018,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 1,
                      margin: EdgeInsets.only(
                        left: screenWidth(context) * 0.155,
                      ),
                      color: const Color(0xffdddddd),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Under Development'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Container(
                        color: Colors.white,
                        height: screenHeight(context) * 0.065,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: screenWidth(context) * 0.04,
                            ),
                            SvgPicture.asset(
                              'assets/images/svgs/share.svg',
                              height: screenHeight(context) * 0.04,
                            ),
                            SizedBox(
                              width: screenWidth(context) * 0.04,
                            ),
                            Text(
                              'Share',
                              style: TextStyle(
                                color: const Color(0xff2d2d2d),
                                fontSize: screenHeight(context) * 0.018,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 1,
                      margin: EdgeInsets.only(
                        left: screenWidth(context) * 0.155,
                      ),
                      color: const Color(0xffdddddd),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Under Development'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Container(
                        color: Colors.white,
                        height: screenHeight(context) * 0.065,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: screenWidth(context) * 0.04,
                            ),
                            SvgPicture.asset(
                              'assets/images/svgs/request.svg',
                              height: screenHeight(context) * 0.04,
                            ),
                            SizedBox(
                              width: screenWidth(context) * 0.04,
                            ),
                            Text(
                              'Request',
                              style: TextStyle(
                                color: const Color(0xff2d2d2d),
                                fontSize: screenHeight(context) * 0.018,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: screenHeight(context) * 0.005,
                      color: const Color(0xffdddddd),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => const SettingsScreen()));
                      },
                      child: Container(
                        color: Colors.white,
                        height: screenHeight(context) * 0.065,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: screenWidth(context) * 0.04,
                            ),
                            SvgPicture.asset(
                              'assets/images/svgs/settings.svg',
                              height: screenHeight(context) * 0.04,
                            ),
                            SizedBox(
                              width: screenWidth(context) * 0.04,
                            ),
                            Text(
                              'Settings',
                              style: TextStyle(
                                color: const Color(0xff2d2d2d),
                                fontSize: screenHeight(context) * 0.018,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 1,
                      margin: EdgeInsets.only(
                        left: screenWidth(context) * 0.155,
                      ),
                      color: const Color(0xffdddddd),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Under Development'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Container(
                        color: Colors.white,
                        height: screenHeight(context) * 0.065,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: screenWidth(context) * 0.04,
                            ),
                            SvgPicture.asset(
                              'assets/images/svgs/privacy&policies.svg',
                              height: screenHeight(context) * 0.04,
                            ),
                            SizedBox(
                              width: screenWidth(context) * 0.04,
                            ),
                            Text(
                              'Privacy & Policies',
                              style: TextStyle(
                                color: const Color(0xff2d2d2d),
                                fontSize: screenHeight(context) * 0.018,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: screenHeight(context) * 0.005,
                      color: const Color(0xffdddddd),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => const ContactUsScreen(),
                          ),
                        );
                      },
                      child: Container(
                        color: Colors.white,
                        height: screenHeight(context) * 0.065,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: screenWidth(context) * 0.04,
                            ),
                            SvgPicture.asset(
                              'assets/images/svgs/contactus.svg',
                              height: screenHeight(context) * 0.04,
                            ),
                            SizedBox(
                              width: screenWidth(context) * 0.04,
                            ),
                            Text(
                              'Contact Us',
                              style: TextStyle(
                                color: const Color(0xff2d2d2d),
                                fontSize: screenHeight(context) * 0.018,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 1,
                      margin: EdgeInsets.only(
                        left: screenWidth(context) * 0.155,
                      ),
                      color: const Color(0xffdddddd),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        showExitDialog(context);
                      },
                      child: Container(
                        color: Colors.white,
                        height: screenHeight(context) * 0.065,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: screenWidth(context) * 0.04,
                            ),
                            SvgPicture.asset(
                              'assets/images/svgs/exit.svg',
                              height: screenHeight(context) * 0.04,
                            ),
                            SizedBox(
                              width: screenWidth(context) * 0.04,
                            ),
                            Text(
                              'Exit',
                              style: TextStyle(
                                color: const Color(0xff2d2d2d),
                                fontSize: screenHeight(context) * 0.018,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: screenHeight(context) * 0.005,
                      color: const Color(0xffdddddd),
                    ),
                    const Spacer(),
                    Container(
                      color: Colors.white,
                      height: screenHeight(context) * 0.065,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: screenWidth(context) * 0.04,
                          ),
                          SvgPicture.asset(
                            'assets/images/svgs/appversion.svg',
                            height: screenHeight(context) * 0.04,
                          ),
                          SizedBox(
                            width: screenWidth(context) * 0.04,
                          ),
                          Text(
                            'App Version 2.0.0',
                            style: TextStyle(
                              color: const Color(0xff2d2d2d),
                              fontSize: screenHeight(context) * 0.018,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
