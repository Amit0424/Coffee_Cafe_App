import 'package:flutter/material.dart';

import '../../../constants/styling.dart';

class CupSelectionText extends StatelessWidget {
  const CupSelectionText({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(
          top: screenHeight(context) * 0.02,
        ),
        child: Text(
          'Select Cup $name',
          style: TextStyle(
            color: matteBlackColor,
            fontSize: screenHeight(context) * 0.018,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
