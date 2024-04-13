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
        backgroundColor: MaterialStateProperty.all(Colors.white),
        elevation: MaterialStateProperty.all(0),
        side: MaterialStateProperty.all(const BorderSide(color: greenColor)),
        minimumSize: MaterialStateProperty.all(Size(
          screenWidth(context) * 0.35,
          screenHeight(context) * 0.05,
        )),
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return const Color(0xffa5d6a7); // Splash color
            }
            return null; // Use the component's default.
          },
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
