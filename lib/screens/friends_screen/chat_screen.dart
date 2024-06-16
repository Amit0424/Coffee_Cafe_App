import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_cafe_app/main.dart';
import 'package:coffee_cafe_app/screens/friends_screen/models/chat_model.dart';
import 'package:coffee_cafe_app/screens/friends_screen/models/friend_model.dart';
import 'package:coffee_cafe_app/screens/friends_screen/widgets/profile_image_widget.dart';
import 'package:coffee_cafe_app/utils/data_base_constants.dart';
import 'package:coffee_cafe_app/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import '../../constants/styling.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key, required this.friendModel});
  final FriendModel friendModel;
  late VideoPlayerController controller;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 5,
        surfaceTintColor: Colors.white,
        shadowColor: greenColor,
        backgroundColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        // centerTitle: true,
        title: Text(
          friendModel.name.split(' ')[0],
          style: TextStyle(
            color: greenColor,
            fontFamily: 'whisper',
            fontSize: screenHeight(context) * 0.04,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: EdgeInsets.only(left: screenWidth(context) * 0.02),
            child: Row(
              children: [
                const Icon(
                  Icons.arrow_back_ios,
                  color: greenColor,
                ),
                Hero(
                  tag: friendModel.email,
                  child: profileImageWidget(
                      friendModel.gender, friendModel.imageUrl),
                ),
              ],
            ),
          ),
        ),
        leadingWidth: screenWidth(context) * 0.20,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: fireStore
                  .collection('coffeeDrinkers')
                  .doc(DBConstants().userID())
                  .collection('friends')
                  .doc(friendModel.friendId)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: LoadingWidget(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text('No data found'),
                  );
                }

                final chatData = snapshot.data!.data() as Map<String, dynamic>?;

                if (chatData == null) {
                  return const Center(
                    child: Text('No chats found'),
                  );
                }

                // Convert chatData map to a list of ChatModel entries and sort based on the 'time' field
                List<ChatModel> chatList = chatData.entries
                    .map((entry) => ChatModel.fromMap(
                        entry.key, entry.value as Map<String, dynamic>))
                    .toList();
                chatList.sort((a, b) => a.time.compareTo(b.time));

                if (snapshot.connectionState == ConnectionState.active &&
                    snapshot.hasData) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_scrollController.hasClients) {
                      _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        curve: Curves.easeOut,
                        duration: const Duration(milliseconds: 300),
                      );
                    }
                  });
                }

                // Continue with your UI rendering logic using sorted chatEntries
                return ListView.builder(
                  itemCount: chatList.length,
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 20.0),
                  itemBuilder: (context, index) {
                    final chat = chatList[index];
                    if (chat.messageType == 'video') {
                      controller = VideoPlayerController.networkUrl(
                          Uri.parse(chat.content));
                    }
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: chat.isSender
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onLongPress: () {
                              if (chat.delete.status) {}
                            },
                            child: Container(
                              margin: chat.isSender
                                  ? EdgeInsets.only(
                                      left: screenWidth(context) * 0.2)
                                  : EdgeInsets.only(
                                      right: screenWidth(context) * 0.2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft:
                                      Radius.circular(chat.isSender ? 10 : 0),
                                  bottomLeft: const Radius.circular(10),
                                  bottomRight: const Radius.circular(10),
                                  topRight:
                                      Radius.circular(chat.isSender ? 0 : 10),
                                ),
                                color: chat.isSender
                                    ? greenColor
                                    : whatsDeletedMessageBarColor,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth(context) * 0.03,
                                    vertical: screenHeight(context) * 0.01),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      chat.delete.status
                                          ? 'This message was Deleted'
                                          : chat.content,
                                      style: TextStyle(
                                        color: chat.delete.status
                                            ? whatsDeletedMessageColor
                                            : Colors.white,
                                        fontSize: screenHeight(context) * 0.017,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    SizedBox(
                                      height: screenHeight(context) * 0.005,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: chat.delete.status
                                                ? 'This message was De'
                                                : chat.content.length >= 37
                                                    ? chat.content
                                                        .substring(0, 33)
                                                    : chat.content.length > 5
                                                        ? chat.content.substring(
                                                            0,
                                                            chat.content
                                                                    .length -
                                                                5)
                                                        : chat.content,
                                            style: TextStyle(
                                              color: chat.isSender
                                                  ? greenColor
                                                  : whatsDeletedMessageBarColor,
                                              fontSize:
                                                  screenHeight(context) * 0.017,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                '${chat.time.hour <= 12 ? chat.time.hour == 0 ? 12 : chat.time.hour : chat.time.hour % 12}:${chat.time.minute.toString().length == 1 ? '0' : ''}${chat.time.minute} ${chat.time.hour < 12 ? 'am' : 'pm'}',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize:
                                                  screenHeight(context) * 0.012,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
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
                  },
                );
              },
            ),
          ),
          Container(
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
                    controller: _messageTextController,
                    onChanged: (value) {},
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
                      if (_messageTextController.text.isNotEmpty) {
                        try {
                          String userId = DBConstants().userID();
                          String friendId = friendModel.friendId;
                          final String docId =
                              fireStore.collection('coffeeDrinkers').doc().id;
                          final ChatModel chatModel = ChatModel(
                            chatId: docId,
                            content: _messageTextController.text,
                            time: DateTime.now(),
                            isSender: true,
                            messageType: 'text',
                            delete: DeleteModel(
                              status: false,
                              isForMe: false,
                              deleteTime: DateTime.now(),
                            ),
                          );

                          DocumentReference senderDocRef = fireStore
                              .collection('coffeeDrinkers')
                              .doc(userId)
                              .collection('friends')
                              .doc(friendId);
                          DocumentReference receiverDocRef = fireStore
                              .collection('coffeeDrinkers')
                              .doc(friendId)
                              .collection('friends')
                              .doc(userId);

                          DocumentSnapshot senderDocSnapshot =
                              await senderDocRef.get();
                          DocumentSnapshot receiverDocSnapshot =
                              await receiverDocRef.get();

                          if (senderDocSnapshot.exists) {
                            await senderDocRef.update({
                              docId: chatModel.toMap(),
                            });
                            debugPrint("Document updated successfully");
                          } else {
                            await senderDocRef.set({
                              docId: chatModel.toMap(),
                            });
                            debugPrint("Document created successfully");
                          }
                          chatModel.isSender = false;
                          if (receiverDocSnapshot.exists) {
                            await receiverDocRef.update({
                              docId: chatModel.toMap(),
                            });
                            debugPrint("Document updated successfully");
                          } else {
                            await receiverDocRef.set({
                              docId: chatModel.toMap(),
                            });
                            debugPrint("Document created successfully");
                          }
                        } catch (e) {
                          debugPrint("Error updating or creating document: $e");
                        }
                        _messageTextController.clear();
                      }
                    },
                    child: const Icon(
                      Icons.send_sharp,
                      color: Colors.white,
                    )),
                SizedBox(width: screenWidth(context) * 0.02),
              ],
            ),
          )
        ],
      ),
    );
  }
}
