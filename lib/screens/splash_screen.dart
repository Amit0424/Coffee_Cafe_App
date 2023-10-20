import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:coffee_cafe_app/widgets/navigator_page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (ctx) => const NavigatorPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: brownishWhite,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Coffee Cafe',
              style: TextStyle(
                color: greenColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 10,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'By',
              style: TextStyle(
                color: brownColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                fontSize: 22,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Amit Choudhary',
              style: TextStyle(
                color: greenColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
