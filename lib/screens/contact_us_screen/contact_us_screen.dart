import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:flutter/material.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  static String routeName = '/ContactUsScreen';

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff1e6d8),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/pngs/contact_us.png'),
              fit: BoxFit.fill),
        ),
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.265,
            ),
            const Text(
              'In Your Heart 💕',
              style: kContactUsTextStyle,
            ),
            SizedBox(height: screenHeight * 0.045),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 15),
                Text(
                  'amitjat2406@gmail.com',
                  style: kContactUsTextStyle,
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.048),
            const Text(
              'Coming soon...',
              style: kContactUsTextStyle,
            ),
            SizedBox(height: screenHeight * 0.05),
            const Text(
              '+91 8561911466',
              style: kContactUsTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
