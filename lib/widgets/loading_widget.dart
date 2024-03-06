import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpinKitFadingCircle(
      color: greenColor,
      size: 45,
    );
  }
}
