import 'package:flutter/material.dart';

import '../../../constants/styling.dart';

showDescriptionDialog(BuildContext context, String productDescription) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Container(
            height: screenHeight(context) * 0.25,
            width: screenWidth(context) * 0.6,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.zero,
            ),
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth(context) * 0.05,
                vertical: screenHeight(context) * 0.02),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Description',
                  style: TextStyle(
                    color: matteBlackColor,
                    fontSize: screenHeight(context) * 0.02,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                Text(
                  productDescription,
                  style: TextStyle(
                    color: textSubHeadingColor,
                    fontSize: screenHeight(context) * 0.014,
                  ),
                  textAlign: TextAlign.justify,
                ),
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
            ),
          ),
        );
      });
}
