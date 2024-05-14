import 'package:flutter/material.dart';

import '../main.dart';
import '../screens/product_screen/product_model/product_model.dart';

class CacheProvider with ChangeNotifier {
  List<ProductModel> newlyAddedProductList = [];
  List<Map<String, dynamic>> categoryList = [];

  CacheProvider() {
    _getNewlyAddedProducts();
    _fetchRandomProducts();
  }

  _getNewlyAddedProducts() async {
    if (newlyAddedProductList.isEmpty) {
      final newlyAddedProducts = await fireStore
          .collection('products')
          .where('isVisible', isEqualTo: true)
          .where('inStock', isEqualTo: true)
          .orderBy('addedDate', descending: true)
          .limit(5)
          .get();

      for (int i = 0; i < 5; i++) {
        final ProductModel productModel =
            ProductModel.fromJson(newlyAddedProducts.docs[i].data());
        newlyAddedProductList.add(productModel);
      }
      notifyListeners();
    }
  }

  // getCategoryList() async {
  //   final categoryProducts =
  // }
  Future<void> _fetchRandomProducts() async {
    final productsSnapshot = await fireStore.collection('products').get();
    final Set<String> uniqueCategories = {};
    for (var doc in productsSnapshot.docs) {
      uniqueCategories.add(doc.data()['category'] as String);
    }

    for (String category in uniqueCategories) {
      var productQuerySnapshot = await fireStore
          .collection('products')
          .where('category', isEqualTo: category)
          .where('isVisible', isEqualTo: true)
          .limit(1)
          .get();

      if (productQuerySnapshot.docs.isEmpty) {
        productQuerySnapshot = await fireStore
            .collection('products')
            .where('category', isEqualTo: category)
            .where('isVisible', isEqualTo: true)
            .limit(1)
            .get();
      }

      if (productQuerySnapshot.docs.isNotEmpty) {
        categoryList.add(productQuerySnapshot.docs.first.data());
      }
    }
    notifyListeners();
  }
}
