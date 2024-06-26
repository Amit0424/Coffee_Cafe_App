import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:coffee_cafe_app/providers/cache_provider.dart';
import 'package:coffee_cafe_app/screens/category_products_list_screen/category_products_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CategoryCards extends StatefulWidget {
  const CategoryCards({super.key});

  @override
  State<CategoryCards> createState() => _CategoryCardsState();
}

class _CategoryCardsState extends State<CategoryCards> {
  @override
  initState() {
    super.initState();
  }

  List<String> productCategoryImageList = [
    'https://firebasestorage.googleapis.com/v0/b/coffee-cafe-app-45ff3.appspot.com/o/coffeeCategoryImages%2Fhot_coffee.jpeg?alt=media&token=a7fa4c79-3fd8-4393-9915-f2a41e64dafc',
    'https://firebasestorage.googleapis.com/v0/b/coffee-cafe-app-45ff3.appspot.com/o/coffeeCategoryImages%2Fcold_coffee.jpeg?alt=media&token=5ace3abd-fcee-4409-b708-e8e8e8a5da50',
    'https://firebasestorage.googleapis.com/v0/b/coffee-cafe-app-45ff3.appspot.com/o/coffeeCategoryImages%2Ficed_tea.jpeg?alt=media&token=53f2f0fd-b737-4c68-ace1-618cfc184922',
    'https://firebasestorage.googleapis.com/v0/b/coffee-cafe-app-45ff3.appspot.com/o/coffeeCategoryImages%2Fhot_tea.jpeg?alt=media&token=3f59aff4-08fa-4321-93a8-31c64ce66260',
    'https://firebasestorage.googleapis.com/v0/b/coffee-cafe-app-45ff3.appspot.com/o/coffeeCategoryImages%2Fsmoothie.jpeg?alt=media&token=27709458-8651-4a17-85c2-6bba0e85699d',
    'https://firebasestorage.googleapis.com/v0/b/coffee-cafe-app-45ff3.appspot.com/o/coffeeCategoryImages%2Fmilkshake.jpeg?alt=media&token=23f41920-e800-464c-a738-d2119f9e78dc',
    'https://firebasestorage.googleapis.com/v0/b/coffee-cafe-app-45ff3.appspot.com/o/coffeeCategoryImages%2Fsoda.jpeg?alt=media&token=a084ae8e-0453-4036-b5b3-67bdfb10b775',
    'https://firebasestorage.googleapis.com/v0/b/coffee-cafe-app-45ff3.appspot.com/o/coffeeCategoryImages%2Fjuice.jpeg?alt=media&token=9132c4fe-ff31-4ffb-9c8d-f6ef4bcd6588',
  ];

  _getProductCategoryImage(String category) {
    switch (category) {
      case 'Hot Coffee':
        return productCategoryImageList[0];
      case 'Cold Coffee':
        return productCategoryImageList[1];
      case 'Iced Tea':
        return productCategoryImageList[2];
      case 'Hot Tea':
        return productCategoryImageList[3];
      case 'Smoothie':
        return productCategoryImageList[4];
      case 'Milkshake':
        return productCategoryImageList[5];
      case 'Soda':
        return productCategoryImageList[6];
      case 'Juice':
        return productCategoryImageList[7];
      default:
        return productCategoryImageList[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CacheProvider>(builder: (context, cacheProvider, child) {
      return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          if (cacheProvider.categoryList.isEmpty) {
            return Shimmer.fromColors(
              baseColor: const Color(0xfff1f1f1),
              highlightColor: Colors.white,
              child: Container(
                color: Colors.white,
                height: screenHeight(context) * 0.15,
                width: screenWidth(context),
                margin: EdgeInsets.symmetric(
                    horizontal: screenWidth(context) * 0.045),
              ),
            );
          }
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.topToBottom,
                      duration: const Duration(milliseconds: 400),
                      child: CategoryProductsListScreen(
                        categoryName: cacheProvider.categoryList[index]
                            ['category'],
                      )));
            },
            child: Container(
              height: screenHeight(context) * 0.15,
              width: screenWidth(context),
              margin: EdgeInsets.only(
                  left: screenWidth(context) * 0.045,
                  right: screenWidth(context) * 0.045,
                  bottom: index == cacheProvider.categoryList.length - 1
                      ? screenHeight(context) * 0.015
                      : 0,
                  top: index == 0 ? screenHeight(context) * 0.015 : 0),
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth(context) * 0.02,
              ),
              color: const Color(0x56acd5c3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image.asset(
                  //     'assets/images/jpgs/${cacheProvider.categoryList[index]['category'].toLowerCase().toString().replaceFirst(' ', '_')}.jpeg',
                  //     height: screenHeight(context) * 0.13,
                  //     width: screenWidth(context) * 0.4,
                  //     fit: BoxFit.cover),
                  CachedNetworkImage(
                    imageUrl: _getProductCategoryImage(
                        cacheProvider.categoryList[index]['category']),
                    height: screenHeight(context) * 0.13,
                    width: screenWidth(context) * 0.4,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: screenWidth(context) * 0.02,
                  ),
                  SizedBox(
                    width: screenWidth(context) * 0.45,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: screenHeight(context) * 0.01,
                        ),
                        Text(
                          cacheProvider.categoryList[index]['category'] + "'s",
                          style: TextStyle(
                            color: matteBlackColor,
                            fontSize: screenHeight(context) * 0.02,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Here are some ${cacheProvider.categoryList[index]['category']} drinks you can find in our store.',
                          style: TextStyle(
                            color: matteBlackColor,
                            fontSize: screenHeight(context) * 0.014,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 4,
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Text(
                          'View All',
                          style: TextStyle(
                            color: matteBlackColor,
                            fontSize: screenHeight(context) * 0.014,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'inter',
                          ),
                        ),
                        SizedBox(
                          height: screenHeight(context) * 0.01,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => SizedBox(
          height: screenHeight(context) * 0.01,
        ),
        itemCount: cacheProvider.categoryList.isEmpty
            ? 4
            : cacheProvider.categoryList.length,
      );
    });
  }
}
