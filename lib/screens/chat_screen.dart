import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_cafe_app/constants/cool_icons.dart';
import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:coffee_cafe_app/widgets/custom_app_bar.dart';
import 'package:coffee_cafe_app/widgets/full_screen_image_viewer.dart';
import 'package:coffee_cafe_app/widgets/full_screen_video_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:video_player/video_player.dart';

final _firestore = FirebaseFirestore.instance;
final _firebase = FirebaseAuth.instance;
late User loggedInUser;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = _firebase;
  late String messageText;
  DateTime timeBackPressed = DateTime.now();

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  Future<void> pickFile(String type) async {
    File? file;
    if (type == 'image') {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        file = File(pickedFile.path);
      }
    } else if (type == 'video') {
      final pickedFile =
          await ImagePicker().pickVideo(source: ImageSource.gallery);
      if (pickedFile != null) {
        file = File(pickedFile.path);
      }
    } else if (type == 'document') {
      final result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowMultiple: true);
      if (result != null) {
        file = File(result.files.single.path!);
      }
    }

    if (file != null) {
      // Upload to Firebase Storage and send message
      String filePath = 'chat_media/${DateTime.now().millisecondsSinceEpoch}';
      await FirebaseStorage.instance.ref(filePath).putFile(file);
      String downloadURL =
          await FirebaseStorage.instance.ref(filePath).getDownloadURL();
      _firestore.collection('messages').add({
        'userId': loggedInUser.uid,
        'mediaUrl': downloadURL,
        'type': type,
        'sender': loggedInUser.email,
        'time': DateTime.now(),
      });
    }
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void messagesStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var messages in snapshot.docs) {
        log(messages.data().toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          rightIconData: const CoolIconsData(0xe926),
          rightIconFunction: () {},
          leftIconFunction: () {
            Navigator.pop(context);
          },
          leftIconData: Icons.arrow_back_ios,
          title: 'Chat Screen'),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.attach_file),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Wrap(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.image),
                                title: const Text('Image'),
                                onTap: () => pickFile('image'),
                              ),
                              ListTile(
                                leading: const Icon(Icons.video_library),
                                title: const Text('Video'),
                                onTap: () => pickFile('video'),
                              ),
                              ListTile(
                                leading: const Icon(Icons.insert_drive_file),
                                title: const Text('Document'),
                                onTap: () => pickFile('document'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      messageTextController.clear();
                      User? currentUser = FirebaseAuth.instance.currentUser;
                      String userId = currentUser!.uid;

                      // final receiveData =
                      //     await _firestore.collection('userToken').get();
                      _firestore.collection('messages').add({
                        'userId': userId,
                        'text': messageText,
                        'sender': loggedInUser.email,
                        'time': DateTime.now(),
                      });
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  const MessagesStream({super.key});

  Future<String> getUserName(String userId) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userDoc['name'];
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy('time').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: brownColor,
            ),
          );
        }
        final messages = snapshot.data!.docs;

        List<MessageBubble> messageBubbles = [];

        for (var message in messages) {
          final userId = (message.data() as Map)["userId"].toString();
          final messageText = (message.data() as Map)["text"].toString();
          final messageSender = (message.data() as Map)["sender"].toString();
          final currentUser = loggedInUser.email;
          final mediaUrl = (message.data() as Map)["mediaUrl"];
          final type = (message.data() as Map)["type"];

          final messageBubble = MessageBubble(
            userNameFuture: getUserName(userId),
            sender: messageSender,
            text: messageText,
            isMe: currentUser == messageSender,
            mediaUrl: mediaUrl,
            type: type,
          );
          messageBubbles.insert(0, messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatefulWidget {
  const MessageBubble({
    super.key,
    required this.sender,
    required this.text,
    required this.isMe,
    required this.userNameFuture,
    this.mediaUrl,
    this.type,
  });

  final String sender;
  final String text;
  final bool isMe;
  final Future<String> userNameFuture;
  final String? mediaUrl;
  final String? type;

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.mediaUrl.toString()));
    _initializeVideoPlayerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openFile(String file) {
    OpenFile.open(file);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: widget.userNameFuture,
      builder: (context, snapshot) {
        String userName = snapshot.data ?? 'Anonymous';
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment:
                widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: navBarTextStyle.copyWith(fontSize: 12.0),
              ),
              Text(
                widget.sender,
                style: navBarTextStyle.copyWith(fontSize: 10.0),
              ),
              Material(
                borderRadius: widget.isMe
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0))
                    : const BorderRadius.only(
                        topRight: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0)),
                elevation: 5.0,
                color: widget.isMe ? greenColor : brownishWhite,
                shadowColor: widget.isMe ? brownColor : greenColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10.0),
                  child: widget.type == 'image'
                      ? InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenImageViewer(
                                  imageUrl: widget.mediaUrl.toString(),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: (MediaQuery.of(context).size.width / 3),
                            height: 300,
                            padding: const EdgeInsets.all(0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        widget.mediaUrl.toString()))),
                          ),
                        )
                      : widget.type == 'video'
                          ? GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullScreenVideoPlayer(
                                        videoUrl: widget.mediaUrl.toString()),
                                  ),
                                );
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    width:
                                        (MediaQuery.of(context).size.width / 3),
                                    height: 300,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        child: VideoPlayer(_controller)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 110,
                                        horizontal:
                                            (MediaQuery.of(context).size.width /
                                                        3 -
                                                    80) /
                                                2),
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        color: const Color.fromARGB(
                                            82, 211, 211, 211),
                                      ),
                                      child: const Icon(
                                        Icons.play_arrow_outlined,
                                        size: 80,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : widget.type == 'document'
                              ? InkWell(
                                  onTap: () {
                                    _openFile(widget.mediaUrl.toString());
                                  },
                                  child: AspectRatio(
                                    aspectRatio: _controller.value.aspectRatio,
                                    child: PDFView(
                                        filePath: widget.mediaUrl.toString()),
                                  ),
                                )
                              : Text(
                                  widget.text,
                                  style: TextStyle(
                                    color:
                                        widget.isMe ? Colors.white : greenColor,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
