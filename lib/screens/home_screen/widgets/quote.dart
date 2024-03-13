import 'package:flutter/material.dart';

import '../../../constants/styling.dart';

class Quote extends StatelessWidget {
  const Quote({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: screenWidth(context) * 0.038),
        child: Text(
          'We are happy to serve you!\nEnjoy your cup of coffee with us.',
          style: TextStyle(
            fontSize: screenHeight(context) * 0.016,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
