import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../utils/data_base_constants.dart';
import '../models/chat_model.dart';
import '../models/friend_model.dart';

deleteForEveryone(
    BuildContext context, ChatModel chat, FriendModel friendModel) {
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
          status: true,
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

      DocumentSnapshot senderDocSnapshot = await transaction.get(senderDocRef);
      // await senderDocRef.get();
      DocumentSnapshot receiverDocSnapshot =
          await transaction.get(receiverDocRef);
      // await receiverDocRef.get();

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
      chatModel.isSender = false;
      if (receiverDocSnapshot.exists) {
        transaction.update(receiverDocRef, {
          docId: chatModel.toMap(),
        });
        debugPrint("Document updated successfully");
      } else {
        transaction.set(receiverDocRef, {
          docId: chatModel.toMap(),
        });
        debugPrint("Document created successfully");
      }
    } catch (e) {
      debugPrint("Error updating or creating document: $e");
    }
  });
  Navigator.pop(context);
}
