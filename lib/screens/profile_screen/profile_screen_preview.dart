import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_cafe_app/screens/profile_screen/profile_model/profile_model.dart';
import 'package:coffee_cafe_app/screens/profile_screen/providers/gender_selection_provider.dart';
import 'package:coffee_cafe_app/screens/profile_screen/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/cool_icons.dart';
import '../../constants/styling.dart';
import '../../widgets/custom_app_bar.dart';

class ProfileScreenPreview extends StatelessWidget {
  const ProfileScreenPreview({super.key});

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
        leftIconFunction: () {
          Navigator.pop(context);
        },
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
                  foregroundImage:
                      profileProvider.profileModelMap['profileUrl'] != null &&
                              profileProvider.profileModelMap['profileUrl'] !=
                                  ''
                          ? CachedNetworkImageProvider(
                              profileProvider.profileModelMap['profileUrl'])
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
            height: screenHeight(context) * 0.11,
          ),
          Container(
            color: Colors.red,
            width: screenWidth(context),
            child: Column(
              children: [
                Row(
                  children: [
                    SvgPicture.asset('assets/images/svgs/cake.svg'),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
