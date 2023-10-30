import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:coffee_cafe_app/widgets/custom_app_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:coffee_cafe_app/models/favorite_model.dart';
import 'package:coffee_cafe_app/providers/favorite_provider.dart';

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
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userID);
    await userDoc.collection('favorites').doc(item.id).delete();
  }

  @override
  Widget build(BuildContext context) {
    final favorite = Provider.of<FavoriteProvider>(context);
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
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Don't you like my coffee?😔\nSo you haven't added even a single coffee to your favorites yet.",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: greenColor),
                  textAlign: TextAlign.center,
                ),
              ),
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
                elevation: 3,
                shadowColor: greenColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Image(
                            height: 100,
                            width: 100,
                            image: CachedNetworkImageProvider(item.imageUrl),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  // mainAxisAlignment:
                                  //     MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item.name,
                                      style: kProductNameTextStyle,
                                    ),
                                    const Spacer(),
                                    SvgPicture.asset('assets/images/close.svg', color: Colors.red, width: 15,),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.red,
                                          textStyle: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                          padding: const EdgeInsets.all(0)),
                                      onPressed: () {
                                        if (isFavorite) {
                                          setState(() async {
                                            await removeFromFavorites(item)
                                                .then((value) => favorite
                                                    .removeItemFromFav());
                                            favoriteItemIds.remove(item.id);
                                          });
                                        }
                                      },
                                      child: const Text('Remove'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '\$${item.price.toString()}',
                                  style: kProductPriceTextStyle,
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
