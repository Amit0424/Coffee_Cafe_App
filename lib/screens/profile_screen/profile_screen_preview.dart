import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_cafe_app/screens/profile_screen/profile_model/profile_model.dart';
import 'package:coffee_cafe_app/screens/profile_screen/profile_screen.dart';
import 'package:coffee_cafe_app/screens/profile_screen/providers/gender_selection_provider.dart';
import 'package:coffee_cafe_app/screens/profile_screen/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/cool_icons.dart';
import '../../constants/styling.dart';
import '../../widgets/custom_app_bar.dart';

class ProfileScreenPreview extends StatelessWidget {
  const ProfileScreenPreview({super.key, required this.backFunction});

  final Function backFunction;

  @override
  Widget build(BuildContext context) {
    final ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context);
    final String dateString =
        profileProvider.profileModelMap['accountCreatedDate']; // Example date
    final DateFormat inputFormat = DateFormat("dd/MM/yyyy");
    DateTime dateTime = inputFormat.parse(dateString);
    String monthName = DateFormat("MMMM").format(dateTime);
    final GenderSelectionProvider genderSelectionProvider =
        Provider.of<GenderSelectionProvider>(context);
    Gender gender = genderSelectionProvider.selectedGender;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        rightIconData: const CoolIconsData(0xea42),
        rightIconFunction: () {},
        rightIconColor: Colors.transparent,
        leftIconFunction: () {},
        leftIconColor: Colors.transparent,
        leftIconData: Icons.arrow_back_ios,
        title: 'Profile',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                height: screenHeight(context) * 0.2,
                width: screenWidth(context),
                child: CachedNetworkImage(
                  imageUrl: profileProvider.profileModelMap[
                                  'profileBackgroundImageUrl'] !=
                              null &&
                          profileProvider.profileModelMap[
                                  'profileBackgroundImageUrl'] !=
                              ''
                      ? profileProvider
                          .profileModelMap['profileBackgroundImageUrl']
                      : 'https://assets-global.website-files.com/5a9ee6416e90d20001b20038/6289f5f9c122094a332133d2_dark-gradient.png',
                  fit: BoxFit.fill,
                  placeholder: (context, url) => Shimmer(
                    direction: ShimmerDirection.ltr,
                    gradient: const LinearGradient(
                      colors: [
                        greenColor,
                        brownColor,
                        brownishWhite,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    child: SizedBox(
                      height: screenHeight(context) * 0.2,
                      width: screenWidth(context),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 3,
                right: 3,
                child: CircleAvatar(
                  backgroundImage: AssetImage(
                      'assets/images/pngs/${gender == Gender.female ? 'girl' : gender == Gender.male ? 'boy' : 'other'}_profile.png'),
                  radius: screenHeight(context) * 0.04,
                  backgroundColor: Colors.transparent,
                  foregroundImage: profileProvider
                                  .profileModelMap['profileImageUrl'] !=
                              null &&
                          profileProvider.profileModelMap['profileImageUrl'] !=
                              ''
                      ? CachedNetworkImageProvider(
                          profileProvider.profileModelMap['profileImageUrl'])
                      : null,
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: -screenHeight(context) * 0.03,
                child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: screenWidth(context) * 0.25),
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight(context) * 0.01,
                    horizontal: screenWidth(context) * 0.01,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        profileProvider.profileModelMap['name'],
                        style: TextStyle(
                          color: matteBlackColor,
                          fontSize: screenHeight(context) * 0.02,
                        ),
                      ),
                      Text(
                        'Member Since ${[
                          'June',
                          'July'
                        ].contains(monthName) ? monthName : monthName.substring(0, 3)} ${dateTime.year}',
                        style: TextStyle(
                          color: iconColor,
                          fontSize: screenHeight(context) * 0.016,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: screenHeight(context) * 0.06,
          ),
          SizedBox(
            width: screenWidth(context),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildProfileInfo(context, 'Date of Birth',
                        profileProvider.profileModelMap['dateOfBirth'], 'cake'),
                    _buildProfileInfo(
                        context,
                        'Age',
                        '${calculateAge(profileProvider.profileModelMap['dateOfBirth'])} yrs',
                        'age'),
                  ],
                ),
                SizedBox(
                  height: screenHeight(context) * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildProfileInfo(
                        context,
                        'Gender',
                        profileProvider.profileModelMap['gender']
                                .toString()
                                .replaceFirst('Gender.', '')[0]
                                .toUpperCase() +
                            profileProvider.profileModelMap['gender']
                                .toString()
                                .replaceFirst('Gender.', '')
                                .substring(1)
                                .toLowerCase(),
                        'gender'),
                    InkWell(
                      onTap: () async {
                        final Uri launchUri = Uri(
                          scheme: 'tel',
                          path:
                              '+91${profileProvider.profileModelMap['phone']}',
                        );
                        if (await canLaunchUrl(launchUri)) {
                          await launchUrl(launchUri);
                        } else {
                          throw 'Could not launch $launchUri';
                        }
                      },
                      child: _buildProfileInfo(
                          context,
                          'Mobile',
                          '+91${profileProvider.profileModelMap['phone']}',
                          'phone'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            color: const Color(0xffeeeeee),
            thickness: 1,
            indent: screenWidth(context) * 0.1,
            endIndent: screenWidth(context) * 0.1,
          ),
          SizedBox(
            height: screenHeight(context) * 0.03,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: screenWidth(context) * 0.1,
              ),
              SvgPicture.asset('assets/images/svgs/email.svg',
                  height: screenHeight(context) * 0.05, color: iconColor),
              SizedBox(
                width: screenWidth(context) * 0.03,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email',
                    style: TextStyle(
                      color: matteBlackColor,
                      fontSize: screenHeight(context) * 0.02,
                    ),
                  ),
                  Text(
                    profileProvider.profileModelMap['email'],
                    style: TextStyle(
                      color: iconColor,
                      fontSize: screenHeight(context) * 0.016,
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: screenHeight(context) * 0.03,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: screenWidth(context) * 0.1,
              ),
              SvgPicture.asset('assets/images/svgs/orders_completed.svg',
                  height: screenHeight(context) * 0.05, color: iconColor),
              SizedBox(
                width: screenWidth(context) * 0.03,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Orders Completed',
                    style: TextStyle(
                      color: matteBlackColor,
                      fontSize: screenHeight(context) * 0.02,
                    ),
                  ),
                  Text(
                    0.toString(),
                    style: TextStyle(
                      color: iconColor,
                      fontSize: screenHeight(context) * 0.016,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: screenHeight(context) * 0.03,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.bottomToTop,
                  duration: const Duration(milliseconds: 400),
                  child: const ProfileScreen(buttonName: 'Update'),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/images/svgs/edit.svg',
                    height: screenHeight(context) * 0.05, color: iconColor),
                Text(
                  'Edit Profile',
                  style: TextStyle(
                    color: matteBlackColor,
                    fontSize: screenHeight(context) * 0.02,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String calculateAge(String birthDateString) {
    DateFormat dateFormat = DateFormat("dd/MM/yyyy");
    DateTime birthDate = dateFormat.parse(birthDateString);
    DateTime today = DateTime.now();

    int age = today.year - birthDate.year;

    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return age.toString();
  }

  Widget _buildProfileInfo(
      BuildContext context, String title, String value, String svgName) {
    return Container(
      height: screenHeight(context) * 0.1,
      width: screenWidth(context) * 0.45,
      padding: const EdgeInsets.only(left: 20),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/svgs/$svgName.svg',
            height: screenHeight(context) * 0.05,
            color: iconColor,
          ),
          SizedBox(
            width: screenWidth(context) * 0.03,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: matteBlackColor,
                  fontSize: screenHeight(context) * 0.02,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: iconColor,
                  fontSize: screenHeight(context) * 0.016,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}