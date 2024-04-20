import '../../../main.dart';

Future<int> getOrdersCount() async {
  var snapshot = await fireStore.collection('orders').get();
  return snapshot.docs.length;
}
