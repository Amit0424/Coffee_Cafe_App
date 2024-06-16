import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget profileImageWidget(String gender, String imageUrl) {
  return CircleAvatar(
    backgroundColor: Colors.transparent,
    backgroundImage: CachedNetworkImageProvider(
      gender == 'male'
          ? 'https://firebasestorage.googleapis.com/v0/b/coffee-cafe-app-45ff3.appspot.com/o/profileImages%2Fboy_profile.png?alt=media&token=4a360718-892e-4d0f-b2b0-981ed78e7d5f'
          : gender == 'female'
              ? 'https://firebasestorage.googleapis.com/v0/b/coffee-cafe-app-45ff3.appspot.com/o/profileImages%2Fgirl_profile.png?alt=media&token=1f402e19-bad6-451e-96da-92e46f706185'
              : 'https://firebasestorage.googleapis.com/v0/b/coffee-cafe-app-45ff3.appspot.com/o/profileImages%2Fother_profile.png?alt=media&token=a7aa7f12-0075-4e52-bd27-9a7f9ca01537',
    ),
    foregroundImage:
        imageUrl == '' ? null : CachedNetworkImageProvider(imageUrl),
  );
}
