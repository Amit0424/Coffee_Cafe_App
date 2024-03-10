import 'dart:io';

import 'package:coffee_cafe_app/constants/border_radius.dart';
import 'package:coffee_cafe_app/constants/cool_icons.dart';
import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:coffee_cafe_app/screens/authentication_screen/utils/login_signup_function.dart';
import 'package:coffee_cafe_app/screens/authentication_screen/widgets/exit_dialog.dart';
import 'package:coffee_cafe_app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  static String routeName = '/authenticationScreen';

  static const IconData helpQuestionMark = CoolIconsData(0xe9ae);

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLogin = true;
  bool _isShowSpinner = false;
  bool _isPasswordVisible = false;

  _authenticate() async {
    setState(() {
      _isShowSpinner = true;
    });
    await authenticateUser(context, _formKey, _isLogin, _emailController.text,
        _passwordController.text);
    setState(() {
      _isShowSpinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (value) async {
        if (value) {
          return;
        }
        showExitDialog(context);
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Coffee',
          rightIconColor: Colors.transparent,
          leftIconData: Icons.arrow_back_ios,
          leftIconFunction: () {
            exit(1);
          },
          rightIconData: AuthenticationScreen.helpQuestionMark,
          rightIconFunction: () {},
        ),
        body: ModalProgressHUD(
          inAsyncCall: _isShowSpinner,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              image: DecorationImage(
                alignment: Alignment.topCenter,
                image: AssetImage("assets/images/pngs/coffee_post_3.png"),
                fit: BoxFit.fitWidth,
              ),
              borderRadius: borderRadius20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: screenHeight(context) * 0.4,
                  width: screenWidth(context),
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth(context) * 0.07),
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
                        SizedBox(
                          height: screenHeight(context) * 0.015,
                        ),
                        Text(
                          _isLogin
                              ? 'OPEN YOUR ACCOUNT'
                              : 'REGISTER YOUR ACCOUNT',
                          style: TextStyle(
                            color: greenColor,
                            fontSize: screenHeight(context) * 0.02,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextFormField(
                          decoration:
                              formInputDecoration('Email', 'Enter your email'),
                          cursorColor: greenColor,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains('@') ||
                                !value.contains('.')) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          controller: _emailController,
                        ),
                        TextFormField(
                          decoration: formInputDecoration(
                            'Password',
                            _isLogin
                                ? 'Enter your password'
                                : 'Create your password',
                          ).copyWith(
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
                          ),
                          cursorColor: greenColor,
                          obscureText: !_isPasswordVisible,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value == null || value.trim().length < 6) {
                              return 'Password must be at least 6 characters long.';
                            }
                            return null;
                          },
                          controller: _passwordController,
                        ),
                        ElevatedButton(
                          onPressed: _authenticate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: greenColor,
                            elevation: 1,
                            fixedSize: Size(screenWidth(context) * 0.4,
                                screenHeight(context) * 0.05),
                            minimumSize: Size(screenWidth(context) * 0.3,
                                screenHeight(context) * 0.04),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                            shadowColor: brownColor,
                          ),
                          child: Text(
                            _isLogin ? 'Log In' : 'SignUp',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenHeight(context) * 0.02,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
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
