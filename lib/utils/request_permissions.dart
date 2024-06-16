import 'package:coffee_cafe_app/widgets/dialog_for_permissions.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestLocationPermission(BuildContext context) async {
  PermissionStatus locationStatus = await Permission.location.request();
  if (locationStatus.isDenied) {
    showDialogForPermission(context, 'Location Permission');
  }
}

Future<void> requestCameraPermission(BuildContext context) async {
  PermissionStatus cameraStatus = await Permission.camera.request();
  if (cameraStatus.isDenied) {
    showDialogForPermission(context, 'Camera Permission');
  }
}

Future<void> requestStoragePermission(BuildContext context) async {
  PermissionStatus storageStatus = await Permission.photos.request();
  if (storageStatus.isDenied) {
    showDialogForPermission(context, 'Storage Permission');
  }
}
