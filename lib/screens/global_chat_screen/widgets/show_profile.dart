import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_cafe_app/screens/friends_screen/models/friend_model.dart';
import 'package:flutter/material.dart';

import '../../../constants/styling.dart';
import '../../../main.dart';
import '../../friends_screen/chat_screen.dart';
import '../utils/format_date.dart';

Future<void> showProfile(BuildContext context, userId) async {
  DocumentReference docRef = fireStore.collection('coffeeDrinkers').doc(userId);

  DocumentSnapshot docSnapshot = await docRef.get();
  FriendModel friendModel = FriendModel.fromMap(
      docSnapshot.id, docSnapshot.data() as Map<String, dynamic>);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          color: Colors.white,
          height: screenHeight(context) * 0.4,
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  Hero(
                    tag: friendModel.email,
                    child: CircleAvatar(
                      backgroundImage: AssetImage(
                          'assets/images/pngs/${friendModel.gender == 'female' ? 'girl' : friendModel.gender == 'male' ? 'boy' : 'other'}_profile.png'),
                      radius: screenHeight(context) * 0.04,
                      backgroundColor: Colors.transparent,
                      foregroundImage: docSnapshot.get('profileImageUrl') != ''
                          ? CachedNetworkImageProvider(
                              docSnapshot.get('profileImageUrl'))
                          : null,
                    ),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        friendModel.name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        friendModel.email,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenHeight(context) * 0.012,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight(context) * 0.016,
              ),
              Container(
                height: screenHeight(context) * 0.2,
                width: screenWidth(context) * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Last Online: ',
                          style: TextStyle(
                            color: iconColor,
                            fontSize: screenHeight(context) * 0.012,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Member Since: ',
                          style: TextStyle(
                            color: iconColor,
                            fontSize: screenHeight(context) * 0.012,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Gender: ',
                          style: TextStyle(
                            color: iconColor,
                            fontSize: screenHeight(context) * 0.012,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Date of Birth: ',
                          style: TextStyle(
                            color: iconColor,
                            fontSize: screenHeight(context) * 0.012,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          formatDateStringForLastOnline(friendModel.lastOnline
                              .toString()
                              .substring(0, 16)),
                          style: TextStyle(
                            color: matteBlackColor,
                            fontSize: screenHeight(context) * 0.012,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          formatDateStringForDateOfBirth(
                              docSnapshot.get('accountCreatedDate')),
                          style: TextStyle(
                            color: matteBlackColor,
                            fontSize: screenHeight(context) * 0.012,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          friendModel.gender[0].toUpperCase() +
                              friendModel.gender.substring(1).toLowerCase(),
                          style: TextStyle(
                            color: matteBlackColor,
                            fontSize: screenHeight(context) * 0.012,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          formatDateStringForDateOfBirth(
                              docSnapshot.get('dateOfBirth')),
                          style: TextStyle(
                            color: matteBlackColor,
                            fontSize: screenHeight(context) * 0.012,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: matteBlackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: screenWidth(context) * 0.1,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            friendModel: friendModel,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Personal Chat',
                      style: TextStyle(
                        color: greenColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
