import 'package:coffee_cafe_app/main.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constants/styling.dart';

class RandomProductsPage extends StatefulWidget {
  const RandomProductsPage({super.key});

  @override
  State<RandomProductsPage> createState() => _RandomProductsPageState();
}

class _RandomProductsPageState extends State<RandomProductsPage>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> randomProducts = [];
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    fetchRandomProducts();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
      lowerBound: 0,
      upperBound: 1,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) => SlideTransition(
          position: Tween(
            begin: const Offset(0, 0.3),
            end: const Offset(0, 0),
          ).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeInOut,
            ),
          ),
          child: child,
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            // crossAxisSpacing: 5.0,
            mainAxisSpacing: 10.0,
          ),
          itemCount: randomProducts.isEmpty ? 8 : randomProducts.length,
          itemBuilder: (context, index) {
            if (randomProducts.isEmpty) {
              return Shimmer.fromColors(
                baseColor: const Color(0xfff1f1f1),
                highlightColor: const Color(0xfff7f7f7),
                child: Container(
                  margin: index.isEven
                      ? EdgeInsets.only(
                          left: screenWidth(context) * 0.022,
                          right: screenWidth(context) * 0.011,
                        )
                      : EdgeInsets.only(
                          left: screenWidth(context) * 0.011,
                          right: screenWidth(context) * 0.022,
                        ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(index.isEven ? 20.0 : 0.0),
                      topRight: Radius.circular(index.isEven ? 0.0 : 20.0),
                      bottomLeft: Radius.circular(index.isEven ? 20.0 : 0.0),
                      bottomRight: Radius.circular(index.isEven ? 0.0 : 20.0),
                    ),
                  ),
                ),
              );
            }
            final product = randomProducts[index];
          },
        ),
      ),
    );
  }
}
