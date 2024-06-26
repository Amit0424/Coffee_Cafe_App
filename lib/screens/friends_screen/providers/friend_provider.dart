import 'dart:developer';

import 'package:coffee_cafe_app/screens/friends_screen/models/friend_model.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../utils/data_base_constants.dart';

class FriendProvider with ChangeNotifier {
  List<FriendModel> friendList = [];
  String previousUserId = DBConstants().userID();

  FriendProvider() {
    getFriends();
  }

  getFriends() async {
    await fireStore
        .collection('coffeeDrinkers')
        .doc(DBConstants().userID())
        .collection('friends')
        .get()
        .then((docId) async {
      log(DBConstants().userID());
      for (var doc in docId.docs) {
        log(doc.id);
        await fireStore
            .collection('coffeeDrinkers')
            .doc(doc.id)
            .get()
            .then((doc) {
          friendList.add(
              FriendModel.fromMap(doc.id, doc.data() as Map<String, dynamic>));
        });
        friendList.sort((a, b) => a.name.compareTo(b.name));
      }
      startListener();
      notifyListeners();
    });
  }

  startListener() {
    fireStore
        .collection('coffeeDrinkers')
        .doc(DBConstants().userID())
        .collection('friends')
        .snapshots()
        .listen((event) {
      if (event.docs.length > friendList.length) {
        friendList = [];
        getFriends();
      }
    });
  }
}
