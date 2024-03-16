import 'package:coffee_cafe_app/screens/product_screen/product_model/utils/product_size.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  ProductSize _productSize = ProductSize.tall;
  late double _productPrice;
  int _productQuantity = 1;

  setProductSize(ProductSize size) {
    _productSize = size;
  }

  setProductQuantity(int quantity) {
    _productQuantity = quantity;
  }

  set productSize(ProductSize size) {
    _productSize = size;
    notifyListeners();
  }

  ProductSize get productSize => _productSize;

  set productPrice(double price) {
    switch (_productSize) {
      case ProductSize.short:
        _productPrice = ((price / 3) * 2 * _productQuantity).round().toDouble();
        break;
      case ProductSize.tall:
        _productPrice = (price * _productQuantity).round().toDouble();
        break;
      case ProductSize.grande:
        _productPrice = ((price / 3 * 4) * _productQuantity).round().toDouble();
        break;
      case ProductSize.venti:
        _productPrice = ((price / 3 * 5) * _productQuantity).round().toDouble();
        break;
    }
  }

  set increaseProductQuantity(double price) {
    if (_productQuantity < 4) {
      _productQuantity++;
      productPrice = price;
      notifyListeners();
    }
  }

  set decreaseProductQuantity(double price) {
    if (_productQuantity > 1) {
      _productQuantity--;
      productPrice = price;
      notifyListeners();
    }
  }

  double get productPrice => _productPrice;
  int get productQuantity => _productQuantity;
}
