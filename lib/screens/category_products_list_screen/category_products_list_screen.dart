import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_cafe_app/main.dart';
import 'package:coffee_cafe_app/screens/product_screen/product_model/product_model.dart';
import 'package:coffee_cafe_app/screens/product_screen/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/styling.dart';

class CategoryProductsListScreen extends StatelessWidget {
  const CategoryProductsListScreen({super.key, required this.categoryName});

  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 3,
        shadowColor: Colors.grey[300],
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: Text(
          '${categoryName}s',
          style: TextStyle(
            fontFamily: 'whisper',
            color: Colors.brown[700],
            fontSize: screenHeight(context) * 0.04,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder(
          stream: fireStore
              .collection('products')
              .where('category', isEqualTo: categoryName)
              .where('isVisible', isEqualTo: true)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    crossAxisSpacing: screenWidth(context) * 0.02,
                    mainAxisSpacing: screenHeight(context) * 0.009,
                  ),
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return Shimmer.fromColors(
                      baseColor: const Color(0xfff1f1f1),
                      highlightColor: Colors.white,
                      child: Container(
                        width: screenWidth(context) * 0.4,
                        height: screenHeight(context) * 0.1,
                        margin: index.isEven
                            ? EdgeInsets.only(left: screenWidth(context) * 0.02)
                            : EdgeInsets.only(
                                right: screenWidth(context) * 0.02),
                        color: const Color(0xffFAF9F6),
                      ),
                    );
                  });
            }

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: screenWidth(context) * 0.02,
                mainAxisSpacing: screenHeight(context) * 0.009,
              ),
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) {
                final ProductModel productModel = ProductModel.fromJson(
                    snapshot.data.docs[index].data() as Map<String, dynamic>);
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.bottomToTop,
                        duration: const Duration(milliseconds: 400),
                        child: ProductScreen(
                          productModel: productModel,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: screenWidth(context) * 0.4,
                    height: screenHeight(context) * 0.1,
                    margin: index.isEven
                        ? EdgeInsets.only(left: screenWidth(context) * 0.02)
                        : EdgeInsets.only(right: screenWidth(context) * 0.02),
                    color: const Color(0x56acd5c3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: screenHeight(context) * 0.01,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Hero(
                            tag: productModel.id,
                            child: CachedNetworkImage(
                              imageUrl: productModel.imageUrl,
                              height: screenHeight(context) * 0.115,
                              width: screenWidth(context) * 0.425,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: screenWidth(context) * 0.02,
                            top: screenHeight(context) * 0.005,
                          ),
                          child: SizedBox(
                            width: screenWidth(context) * 0.425,
                            child: Text(
                              productModel.name,
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
                            '₹${productModel.price.toInt()}',
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
                            productModel.description,
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
            );
          }),
    );
  }
}
