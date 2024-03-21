import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../chat_model/chat_model.dart';
import 'message_bubble.dart';

class MessagesStream extends StatelessWidget {
  MessagesStream({super.key});

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: fireStore.collection('globalChats').orderBy('time').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
          return const Center(
            child: Text('No messages yet'),
          );
        }

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

        final messages = snapshot.data?.docs;

        List<MessageBubble> messageBubbles = [];

        for (var message in messages ?? []) {
          final messageData = (message.data() as Map<String, dynamic>);
          final ChatModel chatModel = ChatModel.fromJson(messageData);

          final messageBubble = MessageBubble(
            id: chatModel.id,
            userId: chatModel.userId,
            chatMessage: chatModel.chatMessage,
            senderName: chatModel.senderName,
            senderEmail: chatModel.senderEmail,
            time: chatModel.time,
            type: chatModel.type,
            mediaUrl: chatModel.mediaUrl,
            isDeleted: chatModel.isDeleted,
          );
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            controller: _scrollController,
            reverse: false,
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}
