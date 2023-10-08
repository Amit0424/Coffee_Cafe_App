import 'package:flutter/material.dart';

const TextStyle welcomeScreenTextStyle = TextStyle(
  color: brownColor,
  fontWeight: FontWeight.bold,
);
const navBarTextStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
);

const productNameTextStyle = TextStyle(
  color: Colors.black87,
  fontWeight: FontWeight.bold,
  fontSize: 18,
);

const productPriceTextStyle = TextStyle(
  color: greenColor,
  fontWeight: FontWeight.bold,
  fontSize: 18,
);

const Color greenColor = Color(0xff006400);
const Color brownColor = Color(0xff9b6b49);
const Color brownishWhite = Color(0xfffef9f0);
const Color iconColor = Colors.black;

const kSendButtonTextStyle = TextStyle(
  color: greenColor,
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
