import 'package:coffee_cafe_app/screens/friends_screen/models/chat_model.dart';
import 'package:flutter/material.dart';

import '../../../constants/styling.dart';
import '../models/friend_model.dart';
import '../utils/delete_for_everyone.dart';
import '../utils/delete_for_me.dart';

deleteDialog(BuildContext context, ChatModel chat, FriendModel friendModel) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Container(
          width: screenWidth(context) * 0.6,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.zero,
          ),
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth(context) * 0.02,
              vertical: screenHeight(context) * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Delete message?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: screenHeight(context) * 0.02,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight(context) * 0.02,
              ),
              if (chat.isSender)
                ElevatedButton(
                  onPressed: () {
                    deleteForEveryone(context, chat, friendModel);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: lightGreenColor,
                  ),
                  child: Text(
                    'Delete for everyone',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: screenHeight(context) * 0.015,
                    ),
                  ),
                ),
              if (chat.isSender)
                SizedBox(
                  height: screenHeight(context) * 0.017,
                ),
              ElevatedButton(
                onPressed: () {
                  deleteForMe(context, chat, friendModel);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: lightGreenColor,
                ),
                child: Text(
                  'Delete for me',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: screenHeight(context) * 0.015,
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight(context) * 0.017,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: lightGreenColor,
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: screenHeight(context) * 0.015,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
