import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../main.dart';
import '../../../utils/data_base_constants.dart';

addProductToFavorites(String productId, List zFavoriteUsersList) {
  try {
    if (zFavoriteUsersList.contains(DBConstants().userID())) {
      fireStore.collection('products').doc(productId).update({
        'zFavoriteUsersList': FieldValue.arrayRemove([DBConstants().userID()])
      });
      zFavoriteUsersList.remove(DBConstants().userID());
    } else {
      fireStore.collection('products').doc(productId).update({
        'zFavoriteUsersList': FieldValue.arrayUnion([DBConstants().userID()])
      });
      zFavoriteUsersList.add(DBConstants().userID());
    }
  } catch (e) {
    Fluttertoast.showToast(msg: 'Error adding to Favorites');
  }
}
