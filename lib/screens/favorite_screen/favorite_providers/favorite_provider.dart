import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoriteProvider with ChangeNotifier {

  FavoriteProvider() {
    _fetchCounterValue();
  }

  final userID = FirebaseAuth.instance.currentUser!.uid;
  int _count = 0;


  int get count {
    _fetchCounterValue();
    return _count;
  }

  _fetchCounterValue() async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();

    if (userDoc.exists && userDoc.data()!.containsKey('FavCounter')) {
      _count = userDoc['FavCounter'];
      notifyListeners();
    }
  }


  addItemInFav() async {
    _count++;
    await _updateCounterInFirestore();
    notifyListeners();
  }

  removeItemFromFav() async {
    _count--;
    await _updateCounterInFirestore();
    notifyListeners();
  }

  _updateCounterInFirestore() async {
    await FirebaseFirestore.instance.collection('users').doc(userID).set({
      'FavCounter': _count,
    }, SetOptions(merge: true));
  }
}
