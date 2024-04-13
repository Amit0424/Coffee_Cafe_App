import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_cafe_app/screens/cart_screen/models/cart_model.dart';

import '../../cart_screen/models/cart_item_model.dart';

class OrderModel {
  final String userId;
  final String orderId;
  final DateTime orderTime;
  final String orderStatus;
  final String userName;
  final String userEmail;
  final String userPhone;
  final String gender;
  final String dateOfBirth;
  final String address;
  final String profileImage;
  final String accountCreatedDate;
  final double latitude;
  final double longitude;
  final CartModel orderDrinks;
  final int payableAmount;
  final String paymentMethod;
  final String orderName;
  final int rating;

  OrderModel({
    required this.userId,
    required this.orderId,
    required this.orderTime,
    required this.orderStatus,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.gender,
    required this.dateOfBirth,
    required this.address,
    required this.profileImage,
    required this.accountCreatedDate,
    required this.latitude,
    required this.longitude,
    required this.orderDrinks,
    required this.payableAmount,
    required this.paymentMethod,
    required this.orderName,
    required this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'orderId': orderId,
      'orderTime': orderTime,
      'orderStatus': orderStatus,
      'userName': userName,
      'userEmail': userEmail,
      'userPhone': userPhone,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'address': address,
      'profileImage': profileImage,
      'accountCreatedDate': accountCreatedDate,
      'latitude': latitude,
      'longitude': longitude,
      'orderDrinks': orderDrinks,
      'payableAmount': payableAmount,
      'paymentMethod': paymentMethod,
      'orderName': orderName,
      'rating': rating,
    };
  }

  factory OrderModel.fromDocument(DocumentSnapshot map) {
    return OrderModel(
      userId: map['userId'],
      orderId: map['orderId'],
      orderTime: map['orderTime'].toDate(),
      orderStatus: map['orderStatus'],
      userName: map['userName'],
      userEmail: map['userEmail'],
      userPhone: map['userPhone'],
      gender: map['gender'],
      dateOfBirth: map['dateOfBirth'],
      address: map['address'],
      profileImage: map['profileImage'],
      accountCreatedDate: map['accountCreatedDate'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      orderDrinks: CartModel(
        cartItems: List<CartItemModel>.from(
            map['orderDrinks']?.map((x) => CartItemModel.fromMap(x))),
      ),
      payableAmount: map['payableAmount'],
      paymentMethod: map['paymentMethod'],
      orderName: map['orderName'],
      rating: map['rating'],
    );
  }
}
