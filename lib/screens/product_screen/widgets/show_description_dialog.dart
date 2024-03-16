import 'package:flutter/material.dart';

import '../../../constants/styling.dart';

showDescriptionDialog(BuildContext context, String productDescription) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xffFAF9F6),
          title: Text(
            'Description',
            style: TextStyle(
              color: matteBlackColor,
              fontSize: screenHeight(context) * 0.018,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          content: Text(
            productDescription,
            style: TextStyle(
              color: matteBlackColor,
              fontSize: screenHeight(context) * 0.016,
            ),
            textAlign: TextAlign.justify,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Close',
                style: TextStyle(
                  color: redColor,
                  fontWeight: FontWeight.w600,
                  fontSize: screenHeight(context) * 0.016,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ],
        );
      });
}
