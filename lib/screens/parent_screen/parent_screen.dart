import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:coffee_cafe_app/screens/cart_screen/cart_screen.dart';
import 'package:coffee_cafe_app/screens/favorite_screen/favorite_screen.dart';
import 'package:coffee_cafe_app/screens/friends_screen/friends_screen.dart';
import 'package:coffee_cafe_app/screens/parent_screen/providers/parent_provider.dart';
import 'package:coffee_cafe_app/screens/parent_screen/utils/bottom_navigation_bar_list.dart';
import 'package:coffee_cafe_app/screens/profile_screen/profile_screen_preview.dart';
import 'package:coffee_cafe_app/utils/data_base_constants.dart';
import 'package:coffee_cafe_app/utils/get_location.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../providers/location_provider.dart';
import '../authentication_screen/widgets/exit_dialog.dart';
import '../friends_screen/providers/friend_provider.dart';
import '../home_screen/home_screen.dart';

class ParentScreen extends StatefulWidget {
  const ParentScreen({super.key});

  static String routeName = '/parentScreen';

  @override
  State<ParentScreen> createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {
  List<Widget> _buildScreens() {
    return [
      const HomeScreen(),
      const FavoriteScreen(),
      const FriendsScreen(),
      const CartScreen(),
      const ProfileScreenPreview(),
    ];
  }

  @override
  void initState() {
    super.initState();
    _sendLastLocationToDB();
  }

  _sendLastLocationToDB() async {
    final LocationProvider locationProvider =
        Provider.of(context, listen: false);
    final locationMap = await getLocation(context);
    locationProvider.setLocation(locationMap);
    locationProvider.setLocationName(await getLocationName(context));
    String id = fireStore.collection('userLastLocation').doc().id;
    await fireStore
        .collection('coffeeDrinkers')
        .doc(DBConstants().userID())
        .update({
      'lastOnline': DateTime.now(),
      'lastLocationName': locationProvider.locationName,
      'latitude': locationProvider.location['latitude'],
      'longitude': locationProvider.location['longitude'],
    });
    await fireStore
        .collection('userLastLocation')
        .doc(DBConstants().userID())
        .collection('lastLocation')
        .doc(id)
        .set({
      'id': id,
      'locationName': locationProvider.locationName,
      'latitude': locationProvider.location['latitude'],
      'longitude': locationProvider.location['longitude'],
      'time': DateTime.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final ParentProvider parentProvider = Provider.of<ParentProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PopScope(
          canPop: false,
          onPopInvoked: (value) {
            if (value) {
              return;
            }
            if (parentProvider.currentIndex == 0) {
              showExitDialog(context);
            } else {
              parentProvider.currentIndex = 0;
            }
          },
          child: _buildScreens()[parentProvider.currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: greenColor,
        selectedFontSize: screenHeight(context) * 0.014,
        unselectedItemColor: matteBlackColor,
        unselectedFontSize: screenHeight(context) * 0.014,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        currentIndex: parentProvider.currentIndex,
        onTap: (index) {
          final FriendProvider friendProvider =
              Provider.of<FriendProvider>(context, listen: false);
          if (friendProvider.previousUserId != DBConstants().userID() &&
              index == 2) {
            friendProvider.friendList.clear();
            friendProvider.getFriends();
          }
          parentProvider.currentIndex = index;
        },
        items: bottomNavigationBarList(context, parentProvider.currentIndex),
      ),
    );
  }
}
