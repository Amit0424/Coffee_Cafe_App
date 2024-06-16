import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_cafe_app/utils/data_base_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../constants/styling.dart';
import '../utils/add_to_favorite_function.dart';

class ImageFrame extends StatefulWidget {
  const ImageFrame({
    super.key,
    required this.productImage,
    required this.productCategory,
    required this.productMakingMinutes,
    required this.productId,
    required this.zFavoriteUsersList,
  });

  final String productImage;
  final String productCategory;
  final int productMakingMinutes;
  final String productId;
  final List zFavoriteUsersList;

  @override
  State<ImageFrame> createState() => _ImageFrameState();
}

class _ImageFrameState extends State<ImageFrame>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.zFavoriteUsersList.contains(DBConstants().userID())) {
      _controller.forward();
    }
    return Stack(
      children: [
        Hero(
          tag: widget.productId,
          child: CachedNetworkImage(
            imageUrl: widget.productImage,
            height: screenHeight(context) * 0.4,
            width: screenWidth(context),
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            height: screenHeight(context) * 0.05,
            width: screenWidth(context),
            color: Colors.black.withOpacity(0.5),
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth(context) * 0.06,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.productCategory,
                  style: TextStyle(
                    color: textHeadingColor,
                    fontSize: screenHeight(context) * 0.014,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Making Time ${widget.productMakingMinutes} mins.',
                  style: TextStyle(
                    color: textHeadingColor,
                    fontSize: screenHeight(context) * 0.016,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: screenWidth(context) * 0.04,
          bottom: -screenHeight(context) * 0.006,
          child: GestureDetector(
            onTap: () {
              addProductToFavorites(
                  widget.productId, widget.zFavoriteUsersList);
              if (widget.zFavoriteUsersList.contains(DBConstants().userID())) {
                _controller.forward();
              } else {
                _controller.reverse();
              }
            },
            child: Lottie.asset(
              'assets/animations/add_to_favorite_animation.json',
              controller: _controller,
              height: screenHeight(context) * 0.06,
              // width: screenWidth(context) * 0.1,
              reverse: false,
              repeat: false,
            ),
          ),
        ),
      ],
    );
  }
}
