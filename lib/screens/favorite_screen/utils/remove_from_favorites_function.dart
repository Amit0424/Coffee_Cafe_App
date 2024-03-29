import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../main.dart';
import '../../../utils/data_base_constants.dart';

removeFromFavorites(String productId) {
  try {
    fireStore.collection('products').doc(productId).update({
      'zFavoriteUsersList': FieldValue.arrayRemove([DBConstants().userID()])
    });
    Fluttertoast.showToast(msg: 'Removed from Favorites');
  } catch (e) {
    Fluttertoast.showToast(msg: 'Error removing from Favorites');
  }
}
