import 'package:coffee_cafe_app/screens/friends_screen/providers/friend_provider.dart';
import 'package:coffee_cafe_app/screens/friends_screen/widgets/profile_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../constants/styling.dart';
import '../parent_screen/providers/parent_provider.dart';
import 'chat_screen.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  @override
  Widget build(BuildContext context) {
    final FriendProvider friendProvider = Provider.of<FriendProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 3,
        shadowColor: Colors.grey[300],
        surfaceTintColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        centerTitle: true,
        title: appBarTitle(context, 'My Friends'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            final parentProvider =
                Provider.of<ParentProvider>(context, listen: false);
            parentProvider.currentIndex = 0;
          },
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: screenHeight(context) * 0.01,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: friendProvider.friendList.length,
              itemBuilder: (context, index) {
                final friend = friendProvider.friendList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          friendModel: friend,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: screenWidth(context) * 0.025,
                        vertical: screenHeight(context) * 0.005),
                    padding: const EdgeInsets.all(10),
                    color: lightGreenColor,
                    child: Row(
                      children: [
                        Hero(
                          tag: friend.email,
                          child: profileImageWidget(
                              friend.gender, friend.imageUrl),
                        ),
                        SizedBox(width: screenWidth(context) * 0.03),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              friend.name,
                              style: TextStyle(
                                color: matteBlackColor,
                                fontSize: screenHeight(context) * 0.02,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              friend.email,
                              style: TextStyle(
                                color: matteBlackColor,
                                fontSize: screenHeight(context) * 0.018,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
