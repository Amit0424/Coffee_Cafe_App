import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:coffee_cafe_app/screens/cart_screen/cart_screen.dart';
import 'package:coffee_cafe_app/screens/favorite_screen/favorite_screen.dart';
import 'package:coffee_cafe_app/screens/global_chat_screen/chat_screen.dart';
import 'package:coffee_cafe_app/screens/parent_screen/utils/bottom_navigation_bar_list.dart';
import 'package:coffee_cafe_app/screens/profile_screen/profile_screen_preview.dart';
import 'package:coffee_cafe_app/utils/data_base_constants.dart';
import 'package:coffee_cafe_app/utils/get_location.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../providers/location_provider.dart';
import '../authentication_screen/widgets/exit_dialog.dart';
import '../home_screen/home_screen.dart';

class ParentScreen extends StatefulWidget {
  const ParentScreen({super.key});

  static String routeName = '/parentScreen';

  @override
  State<ParentScreen> createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {
  int currentIndex = 0;

  List<Widget> _buildScreens() {
    return [
      const HomeScreen(),
      const FavoriteScreen(),
      const ChatScreen(),
      const CartScreen(),
      const ProfileScreenPreview(),
    ];
  }

  @override
  void initState() {
    super.initState();
    _sendLiveDataToDB();
  }

  _sendLiveDataToDB() async {
    final LocationProvider locationProvider =
        Provider.of(context, listen: false);
    locationProvider.setLocation(await getLocation(context));
    await fireStore
        .collection('coffeeDrinkers')
        .doc(DBConstants().userID())
        .update({
      'lastOnline': DateTime.now(),
      'latitude': locationProvider.location['latitude'],
      'longitude': locationProvider.location['longitude'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
          canPop: false,
          onPopInvoked: (value) {
            if (value) {
              return;
            }
            showExitDialog(context);
          },
          child: _buildScreens()[currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: greenColor,
        selectedFontSize: 12,
        unselectedItemColor: matteBlackColor,
        unselectedFontSize: 12,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: bottomNavigationBarList(context, currentIndex),
      ),
    );
  }
}
