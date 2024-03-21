import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';

Future<File> takeDocuments() async {
  final result = await FilePicker.platform
      .pickFiles(type: FileType.custom, allowMultiple: true);
  if (result == null) {
    return File('');
  }
  return File(result.files.single.path!);
}
