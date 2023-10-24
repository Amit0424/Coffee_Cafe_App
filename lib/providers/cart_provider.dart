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


  int get count {
    _fetchCounterValue();
    return _count;
  }

  double get totalAmount {
    _fetchAmountValue();
    return _totalAmount;
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
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userID).get();
    if (userDoc.exists && userDoc.data()!.containsKey('CartTotalAmount')) {
      _totalAmount = userDoc['CartTotalAmount'];
      notifyListeners();
    }
  }



  addItemInCart(double productPrice) async {
    _count++;
    await _updateCounterInFirestore();
    notifyListeners();
    addTotalAmount(productPrice);
  }

  addTotalAmount(double productPrice) async {
    _totalAmount += productPrice;
    await _updateAmountInFirestore();
    notifyListeners();
  }


  removeItemFromCart(double productPrice) async {
    _count--;
    await _updateCounterInFirestore();
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
}