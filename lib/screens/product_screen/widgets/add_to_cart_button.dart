import 'package:flutter/material.dart';

import '../../../constants/styling.dart';

class AddToCartButton extends StatelessWidget {
  const AddToCartButton(
      {super.key, required this.onPressed, required this.productInStock});

  final Function() onPressed;
  final bool productInStock;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.white),
        elevation: WidgetStateProperty.all(0),
        side: WidgetStateProperty.all(const BorderSide(color: greenColor)),
        minimumSize: WidgetStateProperty.all(Size(
          screenWidth(context) * 0.35,
          screenHeight(context) * 0.05,
        )),
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return const Color(0xffa5d6a7); // Splash color
            }
            return null; // Use the component's default.
          },
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // No rounded corners
          ),
        ),
      ),
      child: Text(
        'Add to Cart',
        style: TextStyle(
          fontSize: screenHeight(context) * 0.02,
          color: productInStock ? greenColor : Colors.grey,
          fontFamily: 'inter',
        ),
      ),
    );
  }
}
