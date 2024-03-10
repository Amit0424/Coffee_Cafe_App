import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

Future<File> takeImage(ImageSource imageSource) async {
  final image = await ImagePicker().pickImage(source: imageSource);

  if (image == null) {
    return File('');
  }

  final dir = await getTemporaryDirectory();
  final targetPath = '${dir.absolute.path}/temp.jpg';

  final result = await FlutterImageCompress.compressAndGetFile(
    image.path,
    targetPath,
    minHeight: 1080,
    minWidth: 1080,
    quality: 35,
  );

  return File(result!.path);
}
