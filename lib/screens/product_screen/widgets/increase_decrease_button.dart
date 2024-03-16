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
          backgroundColor: MaterialStateProperty.all(Colors.white),
          elevation: MaterialStateProperty.all(0),
          side: MaterialStateProperty.all(BorderSide(color: matteBlackColor)),
          minimumSize: MaterialStateProperty.all(Size(
            screenWidth(context) * 0.05,
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
        child: Icon(icon,
            color: matteBlackColor, size: screenHeight(context) * 0.03));
  }
}
