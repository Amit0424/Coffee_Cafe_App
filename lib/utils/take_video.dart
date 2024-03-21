import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future<File> takeVideo(ImageSource imageSource) async {
  final pickedFile = await ImagePicker().pickVideo(source: imageSource);

  if (pickedFile == null) {
    return File('');
  }
  return File(pickedFile.path);
}
