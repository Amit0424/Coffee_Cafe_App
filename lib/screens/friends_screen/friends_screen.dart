import 'package:coffee_cafe_app/screens/friends_screen/providers/friend_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../constants/styling.dart';

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
        backgroundColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        centerTitle: true,
        title: appBarTitle(context, 'My Friends'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: friendProvider.friendList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(friendProvider.friendList[index].name),
            subtitle: Text(friendProvider.friendList[index].email.toString()),
          );
        },
      ),
    );
  }
}
