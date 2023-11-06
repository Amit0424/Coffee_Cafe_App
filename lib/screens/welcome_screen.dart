import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_cafe_app/constants/border_radius.dart';
import 'package:coffee_cafe_app/constants/cool_icons.dart';
import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:coffee_cafe_app/widgets/custom_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

final _firebase = FirebaseAuth.instance;

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  static const IconData helpQuestionMark = CoolIconsData(0xe9ae);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  final _formKey = GlobalKey<FormState>();

  DateTime timeBackPressed = DateTime.now();
  var _enteredName = 'Anonymous';
  var _enteredEmail = '';
  var _enteredPassword = '';
  bool _isLogin = true;
  bool isShowSpinner = false;
  bool _isPasswordVisible = false;
  late UserCredential userCredentials;

  @override
  void initState() {
    _updateProfileImages();
    super.initState();
  }

  _updateProfileImages() async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'profileImageUrl':
          'https://www.shareicon.net/data/512x512/2016/09/15/829459_man_512x512.png',
      'profileBackgroundImageUrl':
          'https://cdn.pixabay.com/photo/2016/12/29/18/44/background-1939128_1280.jpg',
    });
  }

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;
    _formKey.currentState!.save();
    setState(() {
      isShowSpinner = true;
    });
    try {
      if (_isLogin) {
        userCredentials = await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
        setState(() {
          isShowSpinner = false;
        });
      } else {
        userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
        String uid = userCredentials.user!.uid;
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'name': _enteredName,
          'email': _enteredEmail,
        });
        setState(() {
          isShowSpinner = false;
        });
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {}
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              height: 90,
              decoration: const BoxDecoration(
                  color: Color(0xffc72c41),
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: Row(
                children: [
                  const SizedBox(
                    width: 48,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Authentication Failed",
                          style: kWelcomeScreenTextStyle.copyWith(
                              fontSize: 16, color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Text(
                          _isLogin
                              ? "Enter correct I'd or Password"
                              : "Incorrect email or existing email",
                          style: kWelcomeScreenTextStyle.copyWith(
                              fontSize: 14, color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.only(bottomLeft: Radius.circular(20.0)),
                child: SvgPicture.asset(
                  'assets/images/bubbles.svg',
                  height: 48,
                  width: 40,
                  color: const Color(0xff801336),
                ),
              ),
            ),
            Positioned(
              top: -20.0,
              left: 0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/fail.svg',
                    height: 40,
                  ),
                  Positioned(
                    top: 10.0,
                    child: SvgPicture.asset(
                      'assets/images/close.svg',
                      height: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ));
      setState(() {
        isShowSpinner = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final nameProvider = Provider.of<UserNameProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        final difference = DateTime.now().difference(timeBackPressed);
        final isExitWarning = difference >= const Duration(seconds: 2);
        timeBackPressed = DateTime.now();

        if (isExitWarning) {
          const message = 'Press back again to exit';
          Fluttertoast.showToast(
            msg: message,
            fontSize: 18,
            gravity: ToastGravity.TOP,
            backgroundColor: brownishWhite,
          );
          return false;
        } else {
          return exit(0);
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Coffee',
          leftIconData: Icons.arrow_back_ios,
          leftIconFunction: () {
            exit(1);
          },
          rightIconData: WelcomeScreen.helpQuestionMark,
          rightIconFunction: () {},
        ),
        body: ModalProgressHUD(
          inAsyncCall: isShowSpinner,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              image: DecorationImage(
                alignment: Alignment.topCenter,
                image: AssetImage("assets/images/coffee_post_3.png"),
                fit: BoxFit.fitWidth,
              ),
              borderRadius: borderRadius20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 375,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 10.0),
                  decoration: const BoxDecoration(
                    color: brownishWhite,
                    borderRadius: borderRadius30,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _isLogin
                            ? const SizedBox.shrink()
                            : TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Name',
                                  labelStyle: kWelcomeScreenTextStyle,
                                  hintText: 'Enter your full name',
                                  hintStyle: kWelcomeScreenTextStyle.copyWith(
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                keyboardType: TextInputType.name,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter you name';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _enteredName = value!;
                                },
                              ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: kWelcomeScreenTextStyle,
                            hintText: 'Enter your email address',
                            hintStyle: kWelcomeScreenTextStyle.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains('@')) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredEmail = value!;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                              icon: Icon(_isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                            labelText: 'Password',
                            labelStyle: kWelcomeScreenTextStyle,
                            hintText: _isLogin
                                ? 'Enter your password'
                                : 'Create your password',
                            hintStyle: kWelcomeScreenTextStyle.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          obscureText: !_isPasswordVisible,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value == null || value.trim().length < 6) {
                              return 'Password must be at least 6 characters long.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredPassword = value!;
                          },
                        ),
                        ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            primary: const Color(0xfffbf1f2),
                            elevation: 2,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                            shadowColor: greenColor,
                          ),
                          child: Text(
                            _isLogin ? 'Log In' : 'SignUp',
                            style: kWelcomeScreenTextStyle,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isLogin = !_isLogin;
                                  });
                                },
                                child: Text(
                                  _isLogin
                                      ? 'Create an account'
                                      : 'I already have an account',
                                  style: kWelcomeScreenTextStyle.copyWith(
                                    color: greenColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: brownishWhite,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 4.0),
                    child: Text(
                      "Hey, coffee enthusiasts! I'm Amit Choudhary,\nand this app is your ticket to my coffee wonderland.",
                      style: kWelcomeScreenTextStyle.copyWith(
                          fontWeight: FontWeight.normal, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
