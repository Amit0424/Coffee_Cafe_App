import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

changePhotoModel(
    BuildContext context, Function firstFunction, Function secondFunction) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0xff000000).withOpacity(0.6),
    context: context,
    builder: (ctx) {
      return Container(
        height: screenHeight(context) * 0.3,
        width: screenWidth(context),
        padding: EdgeInsets.symmetric(horizontal: screenWidth(context) * 0.04),
        color: Colors.transparent,
        child: Center(
          child: Container(
            height: screenHeight(context) * 0.2,
            width: screenWidth(context),
            decoration: const BoxDecoration(color: Color(0xffeeeeee)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: screenHeight(context) * 0.059,
                  width: double.infinity,
                  color: const Color(0xfff4f4f4),
                  child: const Center(
                    child: Text(
                      'Which',
                      style: TextStyle(
                        color: Color(0xff2d2d2d),
                        fontSize: 15,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Container(
                  color: const Color(0xffeeeeee),
                  height: screenHeight(context) * 0.007,
                  width: double.infinity,
                ),
                Container(
                  height: screenHeight(context) * 0.132,
                  color: const Color(0xfff4f4f4),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          firstFunction();
                        },
                        child: Container(
                          height: screenHeight(context) * 0.065,
                          color: const Color(0xfff4f4f4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: screenWidth(context) * 0.04,
                              ),
                              SvgPicture.asset(
                                'assets/images/svgs/profile_photo.svg',
                                height: screenHeight(context) * 0.05,
                              ),
                              SizedBox(
                                width: screenWidth(context) * 0.04,
                              ),
                              Text(
                                'Profile Photo',
                                style: TextStyle(
                                  color: const Color(0xff2d2d2d),
                                  fontSize: screenHeight(context) * 0.018,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 1,
                        margin: EdgeInsets.only(
                          left: screenWidth(context) * 0.17,
                        ),
                        color: const Color(0xffdddddd),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          secondFunction();
                        },
                        child: Container(
                          color: const Color(0xfff4f4f4),
                          height: screenHeight(context) * 0.065,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: screenWidth(context) * 0.04,
                              ),
                              SvgPicture.asset(
                                'assets/images/svgs/background_photo.svg',
                                height: screenHeight(context) * 0.05,
                              ),
                              SizedBox(
                                width: screenWidth(context) * 0.04,
                              ),
                              Text(
                                'Background Photo',
                                style: TextStyle(
                                  color: const Color(0xff2d2d2d),
                                  fontSize: screenHeight(context) * 0.018,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
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
      );
    },
  );
}
