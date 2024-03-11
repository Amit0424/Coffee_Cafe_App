import 'package:coffee_cafe_app/constants/cool_icons.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.rightIconData,
    required this.rightIconFunction,
    required this.leftIconFunction,
    required this.leftIconData,
    required this.title,
    required this.rightIconColor,
    required this.leftIconColor,
  });

  final Function() rightIconFunction;
  final Function() leftIconFunction;
  final IconData rightIconData;
  final IconData leftIconData;
  final String title;
  final Color rightIconColor;
  final Color leftIconColor;

  static const IconData menuDuo = CoolIconsData(0xe9f8);
  static const IconData settingsFuture = CoolIconsData(0xea42);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: IconButton(
              onPressed: leftIconFunction,
              icon: Icon(
                leftIconData,
                color: leftIconColor,
              ),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Image.asset(
              'assets/images/pngs/coffee_ring.png',
              height: kToolbarHeight + MediaQuery.of(context).padding.top,
              width: 50,
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          left: 16.0,
          right: 16.0,
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Futura',
                color: Colors.brown[700],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: IconButton(
              onPressed: rightIconFunction,
              icon: Icon(
                rightIconData,
                color: rightIconColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
