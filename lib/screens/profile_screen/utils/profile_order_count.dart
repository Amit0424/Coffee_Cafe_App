import '../../../main.dart';
import '../../../utils/data_base_constants.dart';

Stream<int> getProfileOrdersCount() {
  return fireStore
      .collection('orders')
      .where('userId', isEqualTo: DBConstants().userID())
      .snapshots()
      .map((snapshot) => snapshot.docs.length);
}
