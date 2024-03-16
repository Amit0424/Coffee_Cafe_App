import 'package:flutter/material.dart';

import '../../../constants/styling.dart';

class Description extends StatelessWidget {
  const Description({
    super.key,
    required this.productDescription,
  });

  final String productDescription;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: screenWidth(context) * 0.12),
      child: Text(
        productDescription,
        style: TextStyle(
          color: matteBlackColor,
          fontSize: screenHeight(context) * 0.012,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
