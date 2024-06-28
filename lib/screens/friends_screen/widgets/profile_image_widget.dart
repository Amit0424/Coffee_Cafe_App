import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget profileImageWidget(String gender, String imageUrl) {
  return CircleAvatar(
    backgroundColor: Colors.transparent,
    backgroundImage: AssetImage(
      gender == 'male'
          ? 'assets/images/pngs/boy_profile.png'
          : gender == 'female'
              ? 'assets/images/pngs/girl_profile.png'
              : 'assets/images/pngs/others_profile.png',
    ),
    foregroundImage:
        imageUrl == '' ? null : CachedNetworkImageProvider(imageUrl),
  );
}
