import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/styling.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  static String routeName = '/ContactUsScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffe3f1eb),
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: Color(0xffe3f1eb),
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
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
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                final Uri launchUri = Uri(
                  scheme: 'tel',
                  path: '+918561911466',
                );
                if (await canLaunchUrl(launchUri)) {
                  await launchUrl(launchUri);
                } else {
                  throw 'Could not launch $launchUri';
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: greenColor,
                elevation: 0,
                minimumSize: Size(
                    screenWidth(context) * 0.35, screenHeight(context) * 0.05),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, // No rounded corners
                ),
              ),
              child: Text(
                'Contact Us Now',
                style: TextStyle(
                  fontSize: screenHeight(context) * 0.02,
                  color: Colors.white,
                  fontFamily: 'inter',
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: screenHeight(context) * 0.05,
            ),
          ],
        ),
      ),
    );
  }
}
