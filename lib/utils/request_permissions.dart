import 'package:coffee_cafe_app/widgets/dialog_for_permissions.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions(BuildContext context) async {
  PermissionStatus storageStatus = await Permission.photos.request();
  PermissionStatus cameraStatus = await Permission.camera.request();
  PermissionStatus locationStatus = await Permission.location.request();
  if (storageStatus.isDenied) {
    showDialogForPermission(context, 'Storage Permission');
  }
  if (cameraStatus.isDenied) {
    showDialogForPermission(context, 'Camera Permission');
  }
  if (locationStatus.isDenied) {
    showDialogForPermission(context, 'Location Permission');
  }
}
