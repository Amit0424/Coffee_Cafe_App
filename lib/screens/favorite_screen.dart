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
            fetchFavorites();
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
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   return const Center(child: CircularProgressIndicator());
            // }

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

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      backgroundColor: Colors.transparent,
                      padding: const EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      shadowColor: Colors.redAccent,
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          height: 120,
                          decoration: const BoxDecoration(
                              color: Color(0x91c72c41),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 80,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: welcomeScreenTextStyle.copyWith(
                                        fontSize: 20, color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '\$${item.price.toString()}',
                                    style: welcomeScreenTextStyle.copyWith(
                                        fontSize: 18, color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Container(
                                height: 80,
                                width: 120,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(item.imageUrl),
                                    fit: BoxFit.fill,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(20.0)),
                            child: SvgPicture.asset(
                              'assets/images/bubbles.svg',
                              height: 90,
                              width: 100,
                              color: const Color(0xff801336),
                            ),
                          ),
                        ),
                        Positioned(
                          top: -20.0,
                          right: 10,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/fail.svg',
                                height: 60,
                              ),
                              Positioned(
                                top: 12.0,
                                child: InkWell(
                                  onTap: () {
                                    if (isFavorite) {
                                      setState(() async {
                                        await removeFromFavorites(item).then(
                                            (value) =>
                                                favorite.removeItemFromFav());
                                        favoriteItemIds.remove(item.id);
                                      });
                                    }
                                  },
                                  child: SvgPicture.asset(
                                    'assets/images/close.svg',
                                    height: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ));
  }
}
