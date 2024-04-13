import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../constants/styling.dart';
import '../../../main.dart';
import '../utils/format_date.dart';

Future<void> showProfile(BuildContext context, userId) async {
  DocumentReference docRef = fireStore.collection('coffeeDrinkers').doc(userId);

  DocumentSnapshot docSnapshot = await docRef.get();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          color: Colors.white,
          height: screenHeight(context) * 0.3,
          width: screenWidth(context) * 0.8,
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(
                        'assets/images/pngs/${docSnapshot.get('gender') == 'female' ? 'girl' : docSnapshot.get('gender') == 'male' ? 'boy' : 'other'}_profile.png'),
                    radius: screenHeight(context) * 0.04,
                    backgroundColor: Colors.transparent,
                    foregroundImage: docSnapshot.get('profileImageUrl') != ''
                        ? CachedNetworkImageProvider(
                            docSnapshot.get('profileImageUrl'))
                        : null,
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        docSnapshot.get('name'),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        docSnapshot.get('email'),
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
              Expanded(
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
                        Text(
                          'Phone: ',
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
                          formatDateStringForLastOnline(docSnapshot
                              .get('lastOnline')
                              .toDate()
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
                          docSnapshot.get('gender')[0].toUpperCase() +
                              docSnapshot
                                  .get('gender')
                                  .substring(1)
                                  .toLowerCase(),
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
                        Text(
                          '+91 ${docSnapshot.get('phone')}',
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Under Development'),
                          duration: Duration(seconds: 2),
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
