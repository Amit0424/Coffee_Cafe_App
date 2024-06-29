import 'package:coffee_cafe_app/main.dart';
import 'package:coffee_cafe_app/screens/friends_screen/models/chat_model.dart';
import 'package:coffee_cafe_app/screens/friends_screen/models/friend_model.dart';
import 'package:coffee_cafe_app/screens/friends_screen/utils/send_message.dart';
import 'package:coffee_cafe_app/screens/friends_screen/widgets/delete_dialog.dart';
import 'package:coffee_cafe_app/screens/friends_screen/widgets/profile_image_widget.dart';
import 'package:coffee_cafe_app/utils/data_base_constants.dart';
import 'package:coffee_cafe_app/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/styling.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key, required this.friendModel});
  final FriendModel friendModel;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 5,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.grey[200],
        backgroundColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        // centerTitle: true,
        title: Text(
          friendModel.name.split(' ')[0],
          style: TextStyle(
            color: matteBlackColor,
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
                Icon(
                  Icons.arrow_back_ios,
                  color: matteBlackColor,
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
                    child: Text('No chats found for this user'),
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
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: chat.isSender
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onLongPress: () {
                              if (!chat.delete.status && !chat.delete.isForMe) {
                                deleteDialog(context, chat, friendModel);
                              }
                            },
                            child: Container(
                              margin: chat.isSender
                                  ? EdgeInsets.only(
                                      left: screenWidth(context) * 0.2)
                                  : EdgeInsets.only(
                                      right: screenWidth(context) * 0.2),
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth(context) * 0.03,
                                  vertical: screenHeight(context) * 0.01),
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
                              child: IntrinsicWidth(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      chat.delete.status || chat.delete.isForMe
                                          ? 'This message was Deleted'
                                          : chat.content,
                                      style: TextStyle(
                                        color: chat.delete.status ||
                                                chat.delete.isForMe
                                            ? whatsDeletedMessageColor
                                            : Colors.white,
                                        fontSize: screenHeight(context) * 0.017,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          '${chat.time.hour == 0 ? '' : (chat.time.hour % 12).toString().length == 1 ? '0' : ''}${chat.time.hour <= 12 ? chat.time.hour == 0 ? 12 : chat.time.hour : chat.time.hour % 12}:${chat.time.minute.toString().length == 1 ? '0' : ''}${chat.time.minute} ${chat.time.hour < 12 ? 'am' : 'pm'}',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize:
                                                screenHeight(context) * 0.012,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              // const Spacer(),
              SizedBox(width: screenWidth(context) * 0.02),
              Expanded(
                // width: screenWidth(context) * 0.7,
                child: TextField(
                  minLines: 1,
                  maxLines: 6,
                  controller: _messageTextController,
                  onChanged: (value) {},
                  cursorColor: greenColor,
                  decoration: kMessageTextFieldDecoration,
                ),
              ),
              // const Spacer(),
              SizedBox(width: screenWidth(context) * 0.02),
              SizedBox(
                height: screenHeight(context) * 0.065,
                child: FloatingActionButton(
                    shape: const CircleBorder(),
                    backgroundColor: greenColor,
                    onPressed: () async {
                      if (_messageTextController.text.isNotEmpty) {
                        sendMessage(
                            context, friendModel, _messageTextController);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter a message'),
                          ),
                        );
                      }
                    },
                    child: const Icon(
                      Icons.send_sharp,
                      color: Colors.white,
                    )),
              ),
              SizedBox(width: screenWidth(context) * 0.02),
            ],
          ),
          SizedBox(
            height: screenHeight(context) * 0.01,
          ),
        ],
      ),
    );
  }
}
