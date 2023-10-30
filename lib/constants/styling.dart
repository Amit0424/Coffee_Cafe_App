import 'package:flutter/material.dart';

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

const Color greenColor = Color(0xff006400);
const Color brownColor = Color(0xff9b6b49);
const Color brownishWhite = Color(0xfffef9f0);
const Color iconColor = Colors.black;

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

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(seedColor: brownColor, primary: brownColor),
  fontFamily: 'futura',
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: Colors.white,
    onPrimary: Colors.white,
    secondary: Colors.white,
    onSecondary: Colors.white,
    error: Colors.red,
    onError: Colors.red,
    background: Colors.black,
    onBackground: Colors.black,
    surface: Colors.black,
    onSurface: Colors.black,
  ),
  fontFamily: 'futura',
);
