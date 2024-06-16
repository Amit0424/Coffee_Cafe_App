import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_cafe_app/providers/cache_provider.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constants/styling.dart';
import '../../product_screen/product_model/product_model.dart';
import '../../product_screen/product_screen.dart';

class NewlyAddedProducts extends StatelessWidget {
  const NewlyAddedProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CacheProvider>(builder: (context, cacheProvider, child) {
      return SizedBox(
          width: screenWidth(context),
          child: cacheProvider.newlyAddedProductList.isEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: const Color(0xfff1f1f1),
                      highlightColor: Colors.white,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: screenHeight(context) * 0.01),
                        margin: EdgeInsets.symmetric(
                            horizontal: screenWidth(context) * 0.045),
                        width: screenWidth(context),
                        color: Colors.white,
                        child: Text(
                          'Loading...',
                          style: TextStyle(
                              fontSize: screenHeight(context) * 0.016,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'inter'),
                        ),
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
                              margin: index == 0
                                  ? EdgeInsets.only(
                                      left: screenWidth(context) * 0.045)
                                  : index == 4
                                      ? EdgeInsets.only(
                                          right: screenWidth(context) * 0.045)
                                      : EdgeInsets.zero,
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => SizedBox(
                          width: screenWidth(context) * 0.02,
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        log(cacheProvider.newlyAddedProductList.length
                            .toString());
                        log(cacheProvider.newlyAddedProductList.toString());
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: screenHeight(context) * 0.01,
                            horizontal: screenWidth(context) * 0.045),
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
                    ),
                    SizedBox(
                      height: screenHeight(context) * 0.21,
                      width: screenWidth(context),
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: cacheProvider.newlyAddedProductList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final ProductModel productModel =
                              cacheProvider.newlyAddedProductList[index];
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
                              margin: index == 0
                                  ? EdgeInsets.only(
                                      left: screenWidth(context) * 0.045)
                                  : index == 4
                                      ? EdgeInsets.only(
                                          right: screenWidth(context) * 0.045)
                                      : EdgeInsets.zero,
                              color: const Color(0x56acd5c3),
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
                                    child: Hero(
                                      tag: productModel.id,
                                      child: CachedNetworkImage(
                                        imageUrl: productModel.imageUrl,
                                        height: screenHeight(context) * 0.1,
                                        width: screenWidth(context) * 0.36,
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
                                      width: screenWidth(context) * 0.36,
                                      child: Text(
                                        productModel.name,
                                        style: TextStyle(
                                          color: matteBlackColor,
                                          fontSize:
                                              screenHeight(context) * 0.014,
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
                                      textAlign: TextAlign.justify,
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
                ));
    });
  }
}
