import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:coffee_cafe_app/main.dart';
import 'package:coffee_cafe_app/screens/favorite_screen/utils/remove_from_favorites_function.dart';
import 'package:coffee_cafe_app/screens/parent_screen/providers/parent_provider.dart';
import 'package:coffee_cafe_app/screens/product_screen/product_model/utils/product_size.dart';
import 'package:coffee_cafe_app/screens/product_screen/product_screen.dart';
import 'package:coffee_cafe_app/screens/product_screen/utils/add_to_cart_function.dart';
import 'package:coffee_cafe_app/utils/data_base_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

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
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              if (parentProvider.currentIndex == 1) {
                parentProvider.currentIndex = 0;
              } else {
                Navigator.pop(context);
              }
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
            return SizedBox(
              width: screenWidth(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/svgs/empty_favorites.svg',
                    height: screenHeight(context) * 0.2,
                    color: matteBlackColor,
                  ),
                  Text(
                    "Share your favorite products with me\nand I'll keep them safe for you!",
                    style: TextStyle(
                      fontSize: screenHeight(context) * 0.016,
                      fontWeight: FontWeight.w500,
                      color: greenColor,
                      fontFamily: 'inter',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final product = snapshot.data!.docs[index];
              return Container(
                color: const Color(0x56acd5c3),
                margin: EdgeInsets.symmetric(
                  horizontal: screenWidth(context) * 0.045,
                ),
                height: screenHeight(context) * 0.15,
                child: Row(
                  children: [
                    GestureDetector(
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
                        height: screenHeight(context) * 0.15,
                        width: screenWidth(context) * 0.78,
                        color: const Color(0xa3acd5c3),
                        child: Row(
                          children: [
                            CachedNetworkImage(
                              imageUrl: product['imageUrl'],
                              height: screenHeight(context) * 0.2,
                              width: screenWidth(context) * 0.35,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(
                              width: screenWidth(context) * 0.02,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: screenHeight(context) * 0.005,
                                ),
                                SizedBox(
                                  width: screenWidth(context) * 0.39,
                                  // height: screenHeight(context) * 0.05,
                                  child: Text(
                                    product['name'],
                                    style: TextStyle(
                                      color: matteBlackColor,
                                      fontSize: screenHeight(context) * 0.015,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 2,
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '₹${product['price'].toString()} ( Tall )',
                                  style: TextStyle(
                                    color: greenColor,
                                    fontSize: screenHeight(context) * 0.016,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Spacer(),
                                Text(
                                  product['category'],
                                  style: TextStyle(
                                    color: matteBlackColor.withOpacity(0.5),
                                    fontSize: screenHeight(context) * 0.014,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'inter',
                                  ),
                                ),
                                SizedBox(
                                  height: screenHeight(context) * 0.01,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    addProductToCart({
                                      'productId': product['id'],
                                      'productName': product['name'],
                                      'productPrice': product['price'],
                                      'productSize': getProductSizeString(
                                          ProductSize.tall),
                                      'productQuantity': 1,
                                      'productImage': product['imageUrl'],
                                    }, 'Add to Cart');
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color(0xffe3f1eb)),
                                    elevation: MaterialStateProperty.all(0),
                                    side: MaterialStateProperty.all(
                                        const BorderSide(color: greenColor)),
                                    minimumSize: MaterialStateProperty.all(Size(
                                      screenWidth(context) * 0.39,
                                      screenHeight(context) * 0.03,
                                    )),
                                    overlayColor: MaterialStateProperty
                                        .resolveWith<Color?>(
                                      (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.pressed)) {
                                          return const Color(
                                              0xffa5d6a7); // Splash color
                                        }
                                        return null; // Use the component's default.
                                      },
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      const RoundedRectangleBorder(
                                        borderRadius: BorderRadius
                                            .zero, // No rounded corners
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Add to Cart',
                                    style: TextStyle(
                                      fontSize: screenHeight(context) * 0.016,
                                      color: greenColor,
                                      fontFamily: 'inter',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        removeFromFavorites(
                          product['id'],
                        );
                      },
                      child: SvgPicture.asset(
                        'assets/images/svgs/delete.svg',
                        height: screenHeight(context) * 0.038,
                        color: redColor,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: screenHeight(context) * 0.02,
              );
            },
          );
        },
      ),
    );
  }
}
