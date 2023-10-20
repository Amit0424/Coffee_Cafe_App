import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:coffee_cafe_app/widgets/custom_app_bar.dart';

import '../models/favorite_model.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final userID = FirebaseAuth.instance.currentUser!.uid;
  List<String> favoriteItemIds = [];
  @override
  void initState() {
    super.initState();
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    final userFavoritesDoc =
        FirebaseFirestore.instance.collection('users').doc(userID);
    final snapshot = await userFavoritesDoc.collection('favorites').get();
    setState(() {
      favoriteItemIds = snapshot.docs.map((doc) => doc.id).toList();
    });
  }

  Future<void> removeFromFavorites(Item item) async {
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(userID);
    await userDoc.collection('favorites').doc(item.id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: 'Favorites',
          rightIconData: Icons.favorite,
          rightIconFunction: () {},
          leftIconFunction: () {
            Navigator.pop(context);
          },
          leftIconData: Icons.arrow_back_ios,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(userID)
              .collection('favorites')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Text(
                "No items available",
                style: TextStyle(fontSize: 24),
              );
            }

            List<Item> items = snapshot.data!.docs
                .map((doc) => Item.fromJson(doc.data() as Map<String, dynamic>))
                .toList();

            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isFavorite = favoriteItemIds.contains(item.id);

                return Card(
                  color: brownishWhite,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image(
                        image: NetworkImage(item.imageUrl),
                        height: 40,
                        width: 80,
                      ),
                      Text(item.name),
                      const Spacer(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 5),
                          InkWell(
                            onTap: () {
                              if(isFavorite){
                                removeFromFavorites(item);
                                setState(() {
                                  favoriteItemIds.remove(item.id);
                                });
                              }
                            },
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.clear_sharp,
                                  color: Colors.redAccent,
                                  size: 18,
                                ),
                                Text(
                                  'Remove',
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text('₹ ${item.price.toString()}'),
                          const SizedBox(height: 5),
                        ],
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                );
              },
            );
          },
        ));
  }
}
