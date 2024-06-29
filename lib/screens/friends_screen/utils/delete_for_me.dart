import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_cafe_app/screens/friends_screen/models/chat_model.dart';
import 'package:coffee_cafe_app/screens/friends_screen/models/friend_model.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../utils/data_base_constants.dart';

deleteForMe(BuildContext context, ChatModel chat, FriendModel friendModel){
  fireStore.runTransaction((transaction) async {
    try {
      String userId = DBConstants().userID();
      String friendId = friendModel.friendId;
      final String docId = chat.chatId;
      final ChatModel chatModel = ChatModel(
        chatId: docId,
        content: chat.content,
        time: chat.time,
        isSender: chat.isSender,
        messageType: chat.messageType,
        delete: DeleteModel(
          status: false,
          isForMe: true,
          deleteTime: DateTime.now(),
        ),
      );

      DocumentReference senderDocRef = fireStore
          .collection('coffeeDrinkers')
          .doc(userId)
          .collection('friends')
          .doc(friendId);

      DocumentSnapshot senderDocSnapshot = await transaction.get(senderDocRef);

      if (senderDocSnapshot.exists) {
        transaction.update(senderDocRef, {
          docId: chatModel.toMap(),
        });
        debugPrint("Document updated successfully");
      } else {
        transaction.set(senderDocRef, {
          docId: chatModel.toMap(),
        });
        debugPrint("Document created successfully");
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  });
  Navigator.pop(context);
}