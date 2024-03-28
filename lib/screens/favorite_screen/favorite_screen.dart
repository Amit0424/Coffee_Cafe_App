import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../main.dart';
import '../../utils/data_base_constants.dart';
import '../parent_screen/providers/parent_provider.dart';
import '../product_screen/product_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  static String routeName = '/favoriteScreen';

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    final ParentProvider parentProvider = Provider.of<ParentProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: appBarTitle(context, 'Favorites'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              parentProvider.currentIndex = 0;
            },
          )),
      body: StreamBuilder<QuerySnapshot>(
        stream: fireStore
            .collection('products')
            .orderBy('name', descending: false)
            .where('zFavoriteUsersList', arrayContains: DBConstants().userID())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.separated(
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return Shimmer.fromColors(
                  baseColor: const Color(0xfff1f1f1),
                  highlightColor: Colors.white,
                  child: Container(
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(
                      horizontal: screenWidth(context) * 0.045,
                    ),
                    height: screenHeight(context) * 0.15,
                    width: screenWidth(context),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: screenHeight(context) * 0.02,
                );
              },
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "Share your favorite products with me\nand I'll keep them safe for you!",
                style: TextStyle(
                  fontSize: screenHeight(context) * 0.016,
                  fontWeight: FontWeight.w500,
                  color: greenColor,
                  fontFamily: 'inter',
                ),
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.separated(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final product = snapshot.data!.docs[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.bottomToTop,
                      duration: const Duration(milliseconds: 400),
                      child: ProductScreen(
                        productId: product['id'],
                        productName: product['name'],
                        productPrice: product['price'],
                        productDescription: product['description'],
                        productImage: product['imageUrl'],
                        productCategory: product['category'],
                        productMakingMinutes: product['makingTime'],
                        productInStock: product['inStock'],
                        zFavoriteUsersList: product['zFavoriteUsersList'],
                      ),
                    ),
                  );
                },
                child: Container(
                  height: screenHeight(context) * 0.1,
                  width: screenWidth(context),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth(context) * 0.02,
                  ),
                  margin: EdgeInsets.only(
                    left: screenWidth(context) * 0.045,
                    right: screenWidth(context) * 0.045,
                    top: screenHeight(context) * (index == 0 ? 0.02 : 0.0),
                  ),
                  color: const Color(0x56acd5c3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CachedNetworkImage(
                        imageUrl: product['imageUrl'],
                        height: screenHeight(context) * 0.08,
                        width: screenWidth(context) * 0.3,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(
                        width: screenWidth(context) * 0.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: screenHeight(context) * 0.005,
                            ),
                            SizedBox(
                              width: screenWidth(context) * 0.45,
                              height: screenHeight(context) * 0.05,
                              child: Text(
                                snapshot.data!.docs.isEmpty
                                    ? 'Product Name'
                                    : product['name'],
                                style: TextStyle(
                                  color: matteBlackColor,
                                  fontSize: screenHeight(context) * 0.02,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                maxLines: 2,
                              ),
                            ),

                            // const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '₹${product['price'].toString()}',
                                  style: TextStyle(
                                    color: greenColor,
                                    fontSize: screenHeight(context) * 0.016,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    fireStore
                                        .collection('products')
                                        .doc(product['id'])
                                        .update({
                                      'zFavoriteUsersList':
                                          FieldValue.arrayRemove(
                                              [DBConstants().userID()])
                                    });
                                  },
                                  child: Text(
                                    'Remove',
                                    style: TextStyle(
                                      color: redColor,
                                      fontSize: screenHeight(context) * 0.014,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'inter',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  product['category'],
                                  style: TextStyle(
                                    color: matteBlackColor.withOpacity(0.5),
                                    fontSize: screenHeight(context) * 0.014,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'inter',
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: screenHeight(context) * 0.01,
              );
            },
          );
        },
      ),
    );
  }
}
