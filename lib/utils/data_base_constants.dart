import 'package:coffee_cafe_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DBConstants {
  String _userID = '';

  String userID() {
    if (firebaseAuth.currentUser?.uid != null) {
      if (_userID == '') {
        _userID = firebaseAuth.currentUser!.uid;
      }
    }
    return _userID;
  }

  String currentUserEmail() {
    final User? user = firebaseAuth.currentUser;

    if (user != null) {
      return user.email ?? 'mail@website.com';
    } else {
      return 'mail@website.com';
    }
  }
}
