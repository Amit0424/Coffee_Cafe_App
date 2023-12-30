import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants/styling.dart';
import '../screens/coffee_screen.dart';
import '../screens/welcome_screen.dart';

class NavigatorPage extends StatelessWidget {
  const NavigatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.active) {
          return const Center(
            child: CircularProgressIndicator(
              color: brownColor,
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: brownColor,
            ),
          );
        }
        if (snapshot.hasData) {
          return const CoffeeScreen();
        }
        if (!snapshot.hasData) {
          return const WelcomeScreen();
        }
        return const Scaffold(body: CircularProgressIndicator());
      },
    );
  }
}
