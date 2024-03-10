import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:coffee_cafe_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> authenticateUser(
    BuildContext context,
    GlobalKey<FormState> formKey,
    bool isLogin,
    String enteredEmail,
    String enteredPassword) async {
  UserCredential userCredentials;
  final isValid = formKey.currentState!.validate();
  if (!isValid) return;
  formKey.currentState!.save();
  try {
    if (isLogin) {
      userCredentials = await firebaseAuth.signInWithEmailAndPassword(
        email: enteredEmail,
        password: enteredPassword,
      );
    } else {
      userCredentials = await firebaseAuth.createUserWithEmailAndPassword(
        email: enteredEmail,
        password: enteredPassword,
      );
    }
  } on FirebaseAuthException catch (error) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: Text(
          'Error 404',
          style: TextStyle(
            color: matteBlackColor,
            fontSize: screenHeight(context) * 0.016,
          ),
        ),
      ),
    );
    if (error.code == 'email-already-in-use') {}
  }
}
