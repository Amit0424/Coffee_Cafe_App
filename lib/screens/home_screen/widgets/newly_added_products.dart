import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_cafe_app/main.dart';
import 'package:coffee_cafe_app/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constants/styling.dart';
import '../../product_screen/product_screen.dart';

class NewlyAddedProducts extends StatelessWidget {
  const NewlyAddedProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth(context) * 0.045),
      width: screenWidth(context),
      color: Colors.transparent,
      child: StreamBuilder(
        stream: fireStore
            .collection('products')
            .where('isVisible', isEqualTo: true)
            .orderBy('addedDate', descending: true)
            .limit(5)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: const Color(0xfff1f1f1),
                  highlightColor: Colors.white,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: screenHeight(context) * 0.01),
                    width: screenWidth(context),
                    color: Colors.white,
                    child: const Text('Loading...'),
                  ),
                ),
                SizedBox(
                  height: screenHeight(context) * 0.21,
                  width: screenWidth(context),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return Shimmer.fromColors(
                        baseColor: const Color(0xfff1f1f1),
                        highlightColor: Colors.white,
                        child: Container(
                          color: Colors.white,
                          width: screenWidth(context) * 0.4,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(
                      width: screenWidth(context) * 0.02,
                    ),
                  ),
                ),
              ],
            );
          }
          if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
            return const SizedBox.shrink();
          }
          if (snapshot.connectionState == ConnectionState.active &&
              snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: screenHeight(context) * 0.01),
                  width: screenWidth(context),
                  child: Text(
                    'Newly Added',
                    style: TextStyle(
                        color: greenColor,
                        fontSize: screenHeight(context) * 0.016,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'inter'),
                  ),
                ),
                SizedBox(
                  height: screenHeight(context) * 0.21,
                  width: screenWidth(context),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.bottomToTop,
                              duration: const Duration(milliseconds: 400),
                              child: ProductScreen(
                                productId: snapshot.data.docs[index]['id'],
                                productName: snapshot.data.docs[index]['name'],
                                productPrice: snapshot.data.docs[index]
                                    ['price'],
                                productDescription: snapshot.data.docs[index]
                                    ['description'],
                                productImage: snapshot.data.docs[index]
                                    ['imageUrl'],
                                productCategory: snapshot.data.docs[index]
                                    ['category'],
                                productMakingMinutes: snapshot.data.docs[index]
                                    ['makingTime'],
                                productInStock: snapshot.data.docs[index]
                                    ['inStock'],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: screenWidth(context) * 0.4,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: const Color(0xffedebde),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: screenHeight(context) * 0.01,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: screenWidth(context) * 0.02,
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: snapshot.data.docs[index]
                                      ['imageUrl'],
                                  height: screenHeight(context) * 0.1,
                                  width: screenWidth(context) * 0.36,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: screenWidth(context) * 0.02,
                                  top: screenHeight(context) * 0.005,
                                ),
                                child: SizedBox(
                                  width: screenWidth(context) * 0.36,
                                  child: Text(
                                    snapshot.data.docs[index]['name'],
                                    style: TextStyle(
                                      color: matteBlackColor,
                                      fontSize: screenHeight(context) * 0.014,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    softWrap: true,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: screenWidth(context) * 0.02,
                                ),
                                child: Text(
                                  '₹${snapshot.data.docs[index]['price']}',
                                  style: TextStyle(
                                    fontSize: screenHeight(context) * 0.016,
                                    fontWeight: FontWeight.bold,
                                    color: greenColor,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: screenHeight(context) * 0.002,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth(context) * 0.02,
                                ),
                                child: Text(
                                  snapshot.data.docs[index]['description'],
                                  style: TextStyle(
                                    fontSize: screenHeight(context) * 0.009,
                                    color: Colors.grey[500],
                                  ),
                                  softWrap: false,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(
                      width: screenWidth(context) * 0.02,
                    ),
                  ),
                ),
              ],
            );
          }
          return const Center(
            child: LoadingWidget(),
          );
        },
      ),
    );
  }
}
