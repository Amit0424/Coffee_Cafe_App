import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:flutter/material.dart';

class IncreaseDecreaseButton extends StatelessWidget {
  const IncreaseDecreaseButton(
      {super.key, required this.onPressed, required this.icon});

  final void Function() onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.white),
          elevation: WidgetStateProperty.all(0),
          side: WidgetStateProperty.all(BorderSide(color: matteBlackColor)),
          minimumSize: WidgetStateProperty.all(Size(
            screenWidth(context) * 0.05,
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
        child: Icon(icon,
            color: matteBlackColor, size: screenHeight(context) * 0.03));
  }
}
