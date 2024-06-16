import 'dart:io';

import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:coffee_cafe_app/main.dart';
import 'package:coffee_cafe_app/screens/global_chat_screen/widgets/message_stream.dart';
import 'package:coffee_cafe_app/utils/data_base_constants.dart';
import 'package:coffee_cafe_app/utils/take_video.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../utils/take_documents.dart';
import '../../utils/take_image.dart';
import '../profile_screen/providers/profile_provider.dart';

class GlobalChatScreen extends StatefulWidget {
  const GlobalChatScreen({super.key});

  static String routeName = '/chatScreen';

  @override
  State<GlobalChatScreen> createState() => _GlobalChatScreenState();
}

class _GlobalChatScreenState extends State<GlobalChatScreen> {
  final TextEditingController messageTextController = TextEditingController();
  String type = 'text';
  String mediaUrl = '';

  Future<void> pickFile(String type, ImageSource imageSource) async {
    File? file;
    if (type == 'image') {
      file = await takeImage(imageSource);
      if (file != File('')) {
        type = 'text';
      }
    } else if (type == 'video') {
      file = await takeVideo(imageSource);
      if (file != File('')) {
        type = 'video';
      }
    } else if (type == 'pdf') {
      file = await takeDocuments();
      if (file != File('')) {
        type = 'pdf';
      }
    }

    if (file != File('')) {
      String filePath = 'chat_media/${DateTime.now().millisecondsSinceEpoch}';
      await FirebaseStorage.instance.ref(filePath).putFile(file!);
      mediaUrl = await FirebaseStorage.instance.ref(filePath).getDownloadURL();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 3,
        shadowColor: Colors.grey[300],
        surfaceTintColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        title: appBarTitle(context, 'Global Chat'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: <Widget>[
          MessagesStream(),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: screenHeight(context) * 0.065,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: greenColor, width: 2.0),
                  bottom: BorderSide(color: greenColor, width: 2.0),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // IconButton(
                  //   icon: const Icon(Icons.attach_file),
                  //   onPressed: () {
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       const SnackBar(
                  //         content: Text('Under Development'),
                  //         duration: Duration(seconds: 2),
                  //       ),
                  //     );
                  //   },
                  // ),
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        if (mediaUrl == '') {
                          type = 'text';
                        }
                      },
                      cursorColor: greenColor,
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: greenColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        if (messageTextController.text.isNotEmpty ||
                            mediaUrl.isNotEmpty) {
                          final String docId =
                              fireStore.collection('globalChats').doc().id;
                          fireStore.collection('globalChats').doc(docId).set({
                            'id': docId,
                            'userId': DBConstants().userID(),
                            'chatMessage': messageTextController.text,
                            'senderName': profileProvider.profileModelMap.name,
                            'senderEmail':
                                profileProvider.profileModelMap.email,
                            'time': DateTime.now(),
                            'isDeleted': false,
                            'type': type,
                            'mediaUrl': mediaUrl,
                          });
                          mediaUrl = '';
                          messageTextController.clear();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please enter a message or select a file'),
                            ),
                          );
                        }
                      },
                      child: const Icon(
                        Icons.send_sharp,
                        color: Colors.white,
                      )),
                  SizedBox(width: screenWidth(context) * 0.02),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
