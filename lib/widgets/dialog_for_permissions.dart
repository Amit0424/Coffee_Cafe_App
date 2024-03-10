import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants/styling.dart';

showDialogForPermission(BuildContext context, String permissionName) {
  showCupertinoDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          SizedBox(
            height: screenHeight(context) * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                permissionName,
                style: TextStyle(
                  color: const Color(0xff2d2d2d),
                  fontSize: screenHeight(context) * 0.02,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight(context) * 0.01),
          Text(
            'Please allow storage permission to use this feature',
            style: TextStyle(
              color: const Color(0xff2d2d2d),
              fontSize: screenHeight(context) * 0.016,
              letterSpacing: 1,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: screenHeight(context) * 0.016),
          InkWell(
            onTap: () async {
              await openAppSettings();
            },
            child: Text(
              'Allow',
              style: TextStyle(
                fontSize: screenHeight(context) * 0.02,
                fontWeight: FontWeight.bold,
                color: greenColor,
              ),
            ),
          ),
        ],
      );
    },
  );
}
