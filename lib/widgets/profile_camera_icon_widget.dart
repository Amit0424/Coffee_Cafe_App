import 'package:flutter/material.dart';

class ProfileCameraIconWidget extends StatelessWidget {
  const ProfileCameraIconWidget(
      {super.key, required this.color, required this.takeImage});

  final Color color;
  final VoidCallback takeImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(30)),
      child: IconButton(
        onPressed: takeImage,
        icon: const Icon(Icons.camera_alt),
      ),
    );
  }
}
