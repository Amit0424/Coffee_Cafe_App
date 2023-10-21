import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:flutter/material.dart';
import 'package:coffee_cafe_app/screens/settings_screen.dart';
import 'package:coffee_cafe_app/widgets/custom_app_bar.dart';
import 'package:coffee_cafe_app/constants/cool_icons.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brownishWhite,
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                const CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.redAccent,
                  backgroundImage: AssetImage('assets/images/profile_photo.png'),
                ),
                Positioned(
                  right: -5,
                  bottom: -5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffefefef),
                      borderRadius: BorderRadius.circular(30)
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.camera_alt),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'NAME',
                labelStyle: TextStyle(
                  color: greenColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    width: 1.5,
                    color: greenColor,
                  ),
                ),
              ),
            ),
            const SizedBox(
                height: 10
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: 'DATE OF BIRTH',
                labelStyle: TextStyle(
                  color: greenColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    width: 1.5,
                    color: greenColor,
                  ),
                ),
              ),
            ),
            const SizedBox(
                height: 10
            ),
            TextField(
              controller: _mobileController,
              decoration: const InputDecoration(
                labelText: 'MOBILE',
                labelStyle: TextStyle(
                  color: greenColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    width: 1.5,
                    color: greenColor,
                  ),
                ),
              ),
            ),
            const SizedBox(
                height: 10
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'EMAIL ADDRESS',
                labelStyle: TextStyle(
                  color: greenColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    width: 1.5,
                    color: greenColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
