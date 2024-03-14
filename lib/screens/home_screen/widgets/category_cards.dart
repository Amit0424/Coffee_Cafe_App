import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:coffee_cafe_app/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

import '../../../main.dart';

class CategoryCards extends StatefulWidget {
  const CategoryCards({super.key});

  @override
  State<CategoryCards> createState() => _CategoryCardsState();
}

class _CategoryCardsState extends State<CategoryCards> {
  List<Map<String, dynamic>> randomProducts = [];

  Future<void> fetchRandomProducts() async {
    final productsSnapshot = await fireStore.collection('products').get();
    final Set<String> uniqueCategories = {};
    for (var doc in productsSnapshot.docs) {
      uniqueCategories.add(doc.data()['category'] as String);
    }

    List<Map<String, dynamic>> tempRandomProducts = [];
    for (String category in uniqueCategories) {
      var productQuerySnapshot = await fireStore
          .collection('products')
          .where('category', isEqualTo: category)
          .limit(1)
          .get();

      if (productQuerySnapshot.docs.isEmpty) {
        productQuerySnapshot = await fireStore
            .collection('products')
            .where('category', isEqualTo: category)
            .limit(1)
            .get();
      }

      if (productQuerySnapshot.docs.isNotEmpty) {
        tempRandomProducts.add(productQuerySnapshot.docs.first.data());
      }
    }

    setState(() {
      randomProducts = tempRandomProducts;
    });
  }

  List<String> productCategoryImageList = [
    'assets/images/jpgs/hot_coffee.jpeg',
    'assets/images/jpgs/cold_coffee.jpeg',
    'assets/images/jpgs/iced_tea.jpeg',
    'assets/images/jpgs/hot_tea.jpeg',
    'assets/images/jpgs/smoothie.jpeg',
    'assets/images/jpgs/milkshake.jpeg',
    'assets/images/jpgs/soda.jpeg',
    'assets/images/jpgs/juice.jpeg',
  ];

  @override
  Widget build(BuildContext context) {
    return CardSwiper(
      numberOfCardsDisplayed: 3,
      duration: const Duration(milliseconds: 300),
      cardBuilder: (context, index, x, y) {
        return Container(
          height: screenHeight(context) * 0.35,
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                image: AssetImage(productCategoryImageList[index]),
                fit: BoxFit.cover),
          ),
          child: Container(
            height: screenHeight(context) * 0.11,
            color: Colors.white.withOpacity(0.7),
            child: Text(
              productCategoryList[index],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
      backCardOffset: const Offset(0, 20),
      cardsCount: productCategoryList.length,
    );
  }
}
// Swiper(
// itemHeight: screenHeight(context) * 0.4,
// itemWidth: screenWidth(context) * 0.7,
// loop: true,
// duration: 500,
// scrollDirection: Axis.vertical,
// itemCount: randomProducts.length,
// layout: SwiperLayout.STACK,
// itemBuilder: (BuildContext context, int index) {
// return Card(
// child: Text(
// randomProducts[index]['category'],
// style: const TextStyle(
// fontSize: 20,
// fontWeight: FontWeight.bold,
// ),
// ),
// );
// },
// )
