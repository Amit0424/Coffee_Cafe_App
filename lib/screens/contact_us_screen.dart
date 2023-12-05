import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:flutter/material.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              image: AssetImage('assets/images/contact_us.png'),
              fit: BoxFit.fill),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 232,
              child: Column(
                children: [
                  const Text(
                    'In Your Heart 💕',
                    style: kContactUsTextStyle,
                  ),
                  const SizedBox(height: 45),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(width: 15),
                      Text(
                        'amitjat2406@gmail.com',
                        style: kContactUsTextStyle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 45),
                  const Text(
                    'Coming soon...',
                    style: kContactUsTextStyle,
                  ),
                  const SizedBox(height: 45),
                  const Text(
                    '+91 8561911466',
                    style: kContactUsTextStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}