import 'dart:developer';
import 'dart:io';

import 'package:coffee_cafe_app/constants/cool_icons.dart';
import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FullScreenImageViewer extends StatelessWidget {
  FullScreenImageViewer({super.key, required this.imageUrl});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String imageUrl;

  Future<String> getExternalStorageDirectoryPath(String fileName) async {
    Directory? directory = await getExternalStorageDirectory();
    String newPath = '';
    List<String> paths = directory!.path.split('/');
    for (int x = 1; x < paths.length; x++) {
      String folder = paths[x];
      if (folder != "Android") {
        newPath += '/$folder';
      } else {
        break;
      }
    }
    newPath = '$newPath/Coffee Cafe/Downloads/$fileName';
    directory = Directory(newPath);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return newPath;
  }

  Future<void> downloadFile(String url, String fileName) async {
    Dio dio = Dio();
    final String savePath = await getExternalStorageDirectoryPath(fileName);
    try {
      var response = await dio.download(url, savePath);
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Download completed. 😁",
          fontSize: 18,
          gravity: ToastGravity.TOP,
          backgroundColor: brownishWhite,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Download failed! 😒",
          fontSize: 18,
          gravity: ToastGravity.TOP,
          backgroundColor: brownishWhite,
        );
      }
    } catch (e) {
      print('Amit');
      log("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Wrap(
                      children: [
                        ListTile(
                          trailing: const Icon(Icons.download_outlined),
                          title: const Text('Download'),
                          onTap: () async {
                            Navigator.pop(context);
                            openAppSettings();
                            if (await Permission.storage.status.isGranted) {
                              Fluttertoast.showToast(
                                msg: "Downloading...",
                                fontSize: 18,
                                gravity: ToastGravity.TOP,
                                backgroundColor: brownishWhite,
                              );
                              final String fileName =
                                  'myImage_${DateTime.now().millisecondsSinceEpoch}.jpg';
                              downloadFile(imageUrl, fileName);
                            } else {
                              Fluttertoast.showToast(
                                msg: "Permission Not granted! 🤦‍♂️",
                                fontSize: 18,
                                gravity: ToastGravity.TOP,
                                backgroundColor: brownishWhite,
                              );
                              if (await Permission.storage.status.isDenied) {
                                openAppSettings();
                              }
                              await Permission.storage.request();
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(CoolIconsData(0xea0c)))
        ],
      ),
      body: Center(
        child: Image.network(imageUrl),
      ),
    );
  }
}
