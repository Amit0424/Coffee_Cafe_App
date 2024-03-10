import 'package:coffee_cafe_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void authenticateUser(BuildContext context, GlobalKey<FormState> formKey,
    bool isLogin, String enteredEmail, String enteredPassword) async {
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
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.transparent, content: Text('Error 404')));
    if (error.code == 'email-already-in-use') {}
  }
}
