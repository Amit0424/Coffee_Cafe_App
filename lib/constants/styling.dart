import 'package:flutter/material.dart';

const Color greenColor = Color(0xFF006400);
const Color brownColor = Color(0xFF9B6B49);
const Color brownishWhite = Color(0xFFFEF9F0);
Color redColor = const Color(0xFFFF2E00);
Color darkYellowColor = const Color(0xFFE69A15);
Color yellowColor = const Color(0xFFF8A245);
Color iconColor = const Color(0xFF9DB2CE);
Color textHeadingColor = const Color(0xFFCBC8C8);
Color textSubHeadingColor = const Color(0xFF847D7D);
Color matteBlackColor = const Color(0xFF2D2D2D);
Color blackColor = const Color(0xFF131313);
Color whatsMessageBarColor = const Color(0xFF005C4B);
Color whatsDeletedMessageBarColor = const Color(0xFF202C33);
Color whatsDeletedMessageColor = const Color(0xFF8696A0);
Color lightGreenColor = const Color(0xFFC0DFD2);

double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;

Widget appBarTitle(BuildContext context, String title) => Text(
      title,
      style: TextStyle(
        color: Colors.brown[700],
        fontFamily: 'whisper',
        fontSize: screenHeight(context) * 0.04,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
      ),
    );

InputDecoration formInputDecoration(String labelText, String hintText) =>
    InputDecoration(
      focusedBorder: const UnderlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(width: 1.5, color: greenColor),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(width: 1.5, color: greenColor),
      ),
      border: const UnderlineInputBorder(
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

final searchBarDecoration = InputDecoration(
  contentPadding: const EdgeInsets.only(top: 10.0),
  labelText: 'Search...',
  labelStyle: kNavBarTextStyle.copyWith(fontWeight: FontWeight.w500),
  prefixIcon: const Icon(Icons.search),
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.brown),
    borderRadius: BorderRadius.circular(20.0),
  ),
);

const TextStyle kWelcomeScreenTextStyle = TextStyle(
  color: brownColor,
  fontWeight: FontWeight.bold,
);
final kNavBarTextStyle = TextStyle(
  color: matteBlackColor,
  fontWeight: FontWeight.bold,
);

const kContactUsTextStyle = TextStyle(
  color: greenColor,
  fontWeight: FontWeight.bold,
  fontSize: 20,
  letterSpacing: 1,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.fromLTRB(10, 30, 10, 0),
  hintText: 'Type your message here...',
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
  ),
);

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
              color: greenColor,
            )
          : null,
      prefix: labelText == 'Mobile'
          ? Text(
              '+91 ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: matteBlackColor,
              ),
            )
          : null,
      focusedBorder: const UnderlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        borderSide: BorderSide(
          width: 1.5,
          color: greenColor,
        ),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        borderSide: BorderSide(
          width: 1.5,
          color: greenColor,
        ),
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(width: 1.5, color: greenColor),
      ),
    );
