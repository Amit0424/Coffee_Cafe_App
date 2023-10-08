import 'package:coffee_cafe_app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Favorites',
        rightIconData: Icons.favorite,
        rightIconFunction: () {},
        leftIconFunction: () {
          Navigator.pop(context);
        },
        leftIconData: Icons.arrow_back_ios,
      ),
      body: const Center(
        child: Text('Favorite Screen'),
      ),
    );
  }
}
