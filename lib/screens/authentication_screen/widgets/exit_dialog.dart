import 'dart:io';

import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void showExitDialog(BuildContext context) {
  showDialog<void>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return PopScope(
        canPop: false,
        onPopInvoked: (value) {
          return;
        },
        child: AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Container(
            padding: EdgeInsets.all(screenHeight(context) * 0.02),
            height: screenHeight(context) * 0.2,
            width: screenWidth(context) * 0.8,
            color: Colors.white,
            child: Column(
              children: [
                Text(
                  'Do you really want to exit?',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'inter',
                    fontSize: screenHeight(context) * 0.02,
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SvgPicture.asset(
                        'assets/images/svgs/happy_man.svg',
                        height: screenHeight(context) * 0.08,
                        // color: greenColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'No',
                        style: TextStyle(
                          color: greenColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth(context) * 0.1),
                    GestureDetector(
                      onTap: () {
                        exit(0);
                      },
                      child: SvgPicture.asset(
                        'assets/images/svgs/sad_man.svg',
                        height: screenHeight(context) * 0.08,
                        // color: redColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        exit(0);
                      },
                      child: Text(
                        'Yes',
                        style: TextStyle(
                          color: redColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
