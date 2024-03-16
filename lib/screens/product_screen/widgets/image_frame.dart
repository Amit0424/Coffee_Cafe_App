import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../constants/styling.dart';

class ImageFrame extends StatefulWidget {
  const ImageFrame({
    super.key,
    required this.productImage,
    required this.productCategory,
    required this.productMakingMinutes,
    required this.onTap,
  });

  final String productImage;
  final String productCategory;
  final int productMakingMinutes;
  final Function() onTap;

  @override
  State<ImageFrame> createState() => _ImageFrameState();
}

class _ImageFrameState extends State<ImageFrame> {
  bool isFavorite = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: widget.productImage,
          height: screenHeight(context) * 0.4,
          width: screenWidth(context),
          fit: BoxFit.fill,
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
          right: screenWidth(context) * 0.06,
          bottom: screenHeight(context) * 0.003,
          child: GestureDetector(
            onTap: () {
              widget.onTap();
              setState(() {
                isFavorite = !isFavorite;
              });
              Fluttertoast.showToast(
                msg: isFavorite
                    ? 'Added to favorites'
                    : 'Removed from favorites',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
              );
            },
            child: SvgPicture.asset(
              'assets/images/svgs/${isFavorite ? 'solid_' : ''}favorites.svg',
              height: screenHeight(context) * 0.035,
              color: yellowColor,
            ),
          ),
        ),
      ],
    );
  }
}
