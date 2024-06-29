import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_cafe_app/screens/friends_screen/models/chat_model.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../utils/data_base_constants.dart';
import '../models/friend_model.dart';

sendMessage(BuildContext context, FriendModel friendModel,
    TextEditingController messageTextController){
  fireStore.runTransaction((transaction) async {
    try {
      String userId = DBConstants().userID();
      String friendId = friendModel.friendId;
      final String docId =
          fireStore.collection('coffeeDrinkers').doc().id;
      final ChatModel chatModel = ChatModel(
        chatId: docId,
        content: messageTextController.text,
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
      await transaction.get(senderDocRef);
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
      debugPrint(
          "Error updating or creating document: $e");
    }
    messageTextController.clear();
  });
}
