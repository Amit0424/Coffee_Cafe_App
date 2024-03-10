import 'package:flutter/material.dart';

const Color greenColor = Color(0xff006400);
const Color brownColor = Color(0xff9b6b49);
const Color brownishWhite = Color(0xfffef9f0);
Color redColor = const Color(0xFFFF2E00);
Color darkYellowColor = const Color(0xFFE69A15);
Color yellowColor = const Color(0xFFF8A245);
Color iconColor = const Color(0xFF9DB2CE);
Color textHeadingColor = const Color(0xFFCBC8C8);
Color textSubHeadingColor = const Color(0xFF847D7D);
Color matteBlackColor = const Color(0xFF2D2D2D);
Color blackColor = const Color(0xFF131313);

double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;
double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;

InputDecoration formInputDecoration(String labelText, String hintText) =>
    InputDecoration(
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        borderSide: BorderSide(width: 1.5, color: greenColor),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(width: 1.5, color: greenColor),
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(width: 1.5, color: greenColor),
      ),
      hintText: hintText,
      hintStyle: const TextStyle(color: brownColor),
      hintTextDirection: TextDirection.rtl,
      alignLabelWithHint: true,
      labelText: labelText,
      labelStyle: const TextStyle(
        color: greenColor,
      ),
    );

const TextStyle kWelcomeScreenTextStyle = TextStyle(
  color: brownColor,
  fontWeight: FontWeight.bold,
);
const kNavBarTextStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
);

const kProductNameTextStyle = TextStyle(
  color: Colors.black87,
  fontWeight: FontWeight.bold,
  fontSize: 18,
);

const kProductPriceTextStyle = TextStyle(
  color: greenColor,
  fontWeight: FontWeight.bold,
  fontSize: 18,
);

const kContactUsTextStyle = TextStyle(
  color: greenColor,
  fontWeight: FontWeight.bold,
  fontSize: 20,
  letterSpacing: 1,
);

const kSendButtonTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: greenColor, width: 2.0),
  ),
);

const colorizeColors = [
  Colors.purple,
  Colors.blue,
  Colors.yellow,
  Colors.red,
];

kProfileTextFieldDecoration(labelText, BuildContext context) => InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        color: greenColor,
        fontWeight: FontWeight.bold,
        fontSize: screenHeight(context) * 0.016,
      ),
      counterText: '',
      suffixIcon: labelText == 'Email'
          ? const Icon(
              Icons.check,
              color: brownColor,
            )
          : null,
      prefix: labelText == 'Mobile'
          ? const Text(
              '+91 ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            )
          : null,
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
        borderSide: BorderSide(
          width: 1.5,
          color: greenColor,
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        borderSide: BorderSide(
          width: 1.5,
          color: greenColor,
        ),
      ),
    );
