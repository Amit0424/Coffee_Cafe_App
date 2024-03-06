import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  CartProvider() {
    _fetchCounterValue();
  }

  final userID = FirebaseAuth.instance.currentUser!.uid;
  int _count = 0;
  double _totalAmount = 0;
  List<String> _cartItems = [];

  List<String> get cartItems => _cartItems;

  int get count {
    _fetchCounterValue();
    return _count;
  }

  double get totalAmount {
    _fetchAmountValue();
    return _totalAmount;
  }

  List<String> get cartList {
    _fetchCartList();
    return _cartItems;
  }

  _fetchCounterValue() async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();

    if (userDoc.exists && userDoc.data()!.containsKey('CartCounter')) {
      _count = userDoc['CartCounter'];
      notifyListeners();
    }
  }

  _fetchAmountValue() async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();
    if (userDoc.exists && userDoc.data()!.containsKey('CartTotalAmount')) {
      _totalAmount = userDoc['CartTotalAmount'];
      notifyListeners();
    }
  }

  _fetchCartList() async {
    final userCartList = await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('cartList')
        .doc('list')
        .get();
    if (userCartList.exists && userCartList.data()!.containsKey('CartItemIdList')) {
      _cartItems = userCartList['CartItemIdList'];
    }
  }

  addItemInCart(double productPrice, String productId) async {
    _count++;
    await _updateCounterInFirestore();
    _cartItems.add(productId);
    _updateCartListInFirestore();
    notifyListeners();
    addTotalAmount(productPrice);
  }

  addTotalAmount(double productPrice) async {
    _totalAmount += productPrice;
    await _updateAmountInFirestore();
    notifyListeners();
  }

  removeItemFromCart(double productPrice, String productId) async {
    _count--;
    await _updateCounterInFirestore();
    _cartItems.remove(productId);
    _updateCartListInFirestore();
    notifyListeners();
    removeTotalAmount(productPrice);
  }

  removeTotalAmount(double productPrice) async {
    _totalAmount -= productPrice;
    await _updateAmountInFirestore();
    notifyListeners();
  }

  _updateCounterInFirestore() async {
    await FirebaseFirestore.instance.collection('users').doc(userID).set({
      'CartCounter': _count,
    }, SetOptions(merge: true));
  }

  _updateAmountInFirestore() async {
    await FirebaseFirestore.instance.collection('users').doc(userID).set({
      'CartTotalAmount': _totalAmount,
    }, SetOptions(merge: true));
  }

  _updateCartListInFirestore() async {

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('cartList')
        .doc('list')
        .set({
      'CartItemIdList': cartItems,
    }, SetOptions(merge: true));
  }
}
