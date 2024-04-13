import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_cafe_app/screens/cart_screen/models/cart_item_model.dart';

class CartModel {
  final List<CartItemModel> cartItems;

  CartModel({required this.cartItems});

  Map<String, dynamic> toMap() {
    return {
      'cartItems': cartItems.map((x) => x.toMap()).toList(),
    };
  }

  factory CartModel.fromMap(DocumentSnapshot map) {
    return CartModel(
      cartItems: List<CartItemModel>.from(
          map['cartItems']?.map((x) => CartItemModel.fromMap(x))),
    );
  }
}
