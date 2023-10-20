import 'package:flutter/material.dart';
import 'package:coffee_cafe_app/screens/settings_screen.dart';
import 'package:coffee_cafe_app/widgets/custom_app_bar.dart';
import 'package:coffee_cafe_app/constants/cool_icons.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        rightIconData: const CoolIconsData(0xea42),
        rightIconFunction: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (ctx) => const SettingsScreen()));
        },
        leftIconFunction: () {
          Navigator.pop(context);
        },
        leftIconData: Icons.arrow_back_ios,
        title: 'Profile',
      ),
      body: const Center(
        child: Text("Profile"),
      ),
    );
  }
}
