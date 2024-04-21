import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_cafe_app/main.dart';
import 'package:coffee_cafe_app/screens/global_chat_screen/widgets/show_profile.dart';
import 'package:coffee_cafe_app/screens/profile_screen/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../constants/styling.dart';
import '../utils/delete_message.dart';
import 'full_screen_image_viewer.dart';
import 'full_screen_video_player.dart';

class MessageBubble extends StatefulWidget {
  const MessageBubble({
    super.key,
    required this.id,
    required this.userId,
    required this.chatMessage,
    required this.senderName,
    required this.senderEmail,
    required this.time,
    required this.type,
    required this.mediaUrl,
    required this.isDeleted,
  });

  final String id;
  final String userId;
  final String chatMessage;
  final String senderName;
  final String senderEmail;
  final DateTime time;
  final String type;
  final String mediaUrl;
  final bool isDeleted;

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  late VideoPlayerController _controller;
  late Future<void> initializeVideoPlayerFuture;
  String senderName = '';
  String senderEmail = '';

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.mediaUrl.toString()));
    initializeVideoPlayerFuture = _controller.initialize();
    setFieldValue();
  }

  Future<void> setFieldValue() async {
    DocumentReference docRef =
        fireStore.collection('coffeeDrinkers').doc(widget.userId);
    DocumentSnapshot docSnapshot = await docRef.get();

    String? name = docSnapshot.get('name');
    String? email = docSnapshot.get('email');

    setState(() {
      senderName = name ?? 'Unknown'; // Provide a default value in case of null
      senderEmail = email ?? 'Unknown';
    });
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
    final ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context);
    final bool isMe =
        profileProvider.profileModelMap.email == widget.senderEmail;
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              if (!isMe) {
                showProfile(context, widget.userId);
              }
            },
            child: Text(
              senderName,
              style: TextStyle(
                color: matteBlackColor,
                fontSize: screenHeight(context) * 0.012,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (!isMe) {
                showProfile(context, widget.userId);
              }
            },
            child: Text(
              senderEmail,
              style: TextStyle(
                color: matteBlackColor,
                fontSize: screenHeight(context) * 0.01,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 2.0),
          GestureDetector(
            onLongPress: () {
              if (isMe && !widget.isDeleted) {
                deleteMessage(context, widget.id);
              }
            },
            child: Container(
              margin: isMe
                  ? EdgeInsets.only(left: screenWidth(context) * 0.2)
                  : EdgeInsets.only(right: screenWidth(context) * 0.2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isMe ? 10 : 0),
                  bottomLeft: const Radius.circular(10),
                  bottomRight: const Radius.circular(10),
                  topRight: Radius.circular(isMe ? 0 : 10),
                ),
                // border: Border.all(
                //   color: isMe ? greenColor : blackColor,
                //   width: 2,
                // ),
                color: isMe ? greenColor : whatsDeletedMessageBarColor,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth(context) * 0.03,
                    vertical: screenHeight(context) * 0.01),
                child: Column(
                  children: [
                    widget.type == 'image'
                        ? GestureDetector(
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
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: (MediaQuery.of(context).size.width *
                                      2 /
                                      3),
                                  // Adjust the size according to your needs
                                  maxHeight: 300.0,
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: widget.mediaUrl.toString(),
                                  memCacheHeight: 300,
                                  memCacheWidth:
                                      MediaQuery.of(context).size.width *
                                          2 ~/
                                          3,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : widget.type == 'video'
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FullScreenVideoPlayer(
                                              videoUrl:
                                                  widget.mediaUrl.toString()),
                                    ),
                                  );
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      width:
                                          (MediaQuery.of(context).size.width /
                                              3),
                                      height: 300,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          child: VideoPlayer(_controller)),
                                    ),
                                    Positioned(
                                      left: 0,
                                      right: 0,
                                      top: 0,
                                      bottom: 0,
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
                                ? GestureDetector(
                                    onTap: () {
                                      _openFile(widget.mediaUrl.toString());
                                    },
                                    child: AspectRatio(
                                      aspectRatio:
                                          _controller.value.aspectRatio,
                                      child: PDFView(
                                          filePath: widget.mediaUrl.toString()),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                    Text(
                      widget.isDeleted
                          ? 'This message was Deleted'
                          : widget.chatMessage,
                      style: TextStyle(
                        color: widget.isDeleted
                            ? whatsDeletedMessageColor
                            : Colors.white,
                        fontSize: screenHeight(context) * 0.016,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
