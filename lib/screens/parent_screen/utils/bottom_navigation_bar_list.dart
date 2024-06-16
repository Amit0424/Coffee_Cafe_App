import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants/styling.dart';

List<BottomNavigationBarItem> bottomNavigationBarList(
    BuildContext context, int currentIndex) {
  return [
    BottomNavigationBarItem(
      label: 'Home',
      icon: SvgPicture.asset(
        'assets/images/svgs/coffee.svg',
        color: currentIndex == 0 ? greenColor : matteBlackColor,
        height: screenHeight(context) * 0.03,
      ),
    ),
    BottomNavigationBarItem(
      label: 'Favourites',
      icon: SvgPicture.asset(
        'assets/images/svgs/favorites.svg',
        color: currentIndex == 1 ? greenColor : matteBlackColor,
        height: screenHeight(context) * 0.03,
      ),
    ),
    BottomNavigationBarItem(
      label: 'Chat',
      icon: SvgPicture.asset(
        'assets/images/svgs/chat.svg',
        color: currentIndex == 2 ? greenColor : matteBlackColor,
        height: screenHeight(context) * 0.03,
      ),
    ),
    BottomNavigationBarItem(
      label: 'Cart',
      icon: SvgPicture.asset(
        'assets/images/svgs/cart.svg',
        color: currentIndex == 3 ? greenColor : matteBlackColor,
        height: screenHeight(context) * 0.03,
      ),
    ),
    BottomNavigationBarItem(
      label: 'Profile',
      icon: SvgPicture.asset(
        'assets/images/svgs/profile.svg',
        color: currentIndex == 4 ? greenColor : matteBlackColor,
        height: screenHeight(context) * 0.03,
      ),
    ),
  ];
}
