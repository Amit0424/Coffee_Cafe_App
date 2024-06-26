import 'package:flutter/material.dart';

import '../../../constants/styling.dart';

class OrderNowButton extends StatelessWidget {
  const OrderNowButton(
      {super.key, required this.onPressed, required this.productInStock});

  final Function() onPressed;
  final bool productInStock;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: greenColor,
        elevation: 0,
        minimumSize:
            Size(screenWidth(context) * 0.35, screenHeight(context) * 0.05),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // No rounded corners
        ),
      ),
      child: Text(
        'Order Now',
        style: TextStyle(
          fontSize: screenHeight(context) * 0.02,
          color: productInStock ? Colors.white : Colors.grey,
          fontFamily: 'inter',
        ),
      ),
    );
  }
}
