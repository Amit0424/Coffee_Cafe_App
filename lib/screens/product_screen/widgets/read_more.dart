import 'package:flutter/material.dart';

import '../../../constants/styling.dart';
import 'show_description_dialog.dart';

class ReadMore extends StatelessWidget {
  const ReadMore({super.key, required this.productDescription});

  final String productDescription;

  @override
  Widget build(BuildContext context) {
    return productDescription.length > 128
        ? Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                showDescriptionDialog(context, productDescription);
              },
              child: Text(
                'Read more',
                style: TextStyle(
                  color: darkYellowColor,
                  fontSize: screenHeight(context) * 0.012,
                ),
              ),
            ),
          )
        : SizedBox(height: screenHeight(context) * 0.017);
  }
}
