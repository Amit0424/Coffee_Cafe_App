import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_cafe_app/screens/cart_screen/models/cart_model.dart';

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
  late int rating;
  final int orderNumber;

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
    required this.orderNumber,
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
      'orderDrinks': orderDrinks.toMap(),
      'payableAmount': payableAmount,
      'paymentMethod': paymentMethod,
      'orderName': orderName,
      'rating': rating,
      'orderNumber': orderNumber,
    };
  }

  factory OrderModel.fromDocument(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      userId: data['userId'] ?? '',
      orderId: data['orderId'] ?? '',
      orderTime: (data['orderTime'] as Timestamp).toDate(),
      orderStatus: data['orderStatus'] ?? '',
      userName: data['userName'] ?? '',
      userEmail: data['userEmail'] ?? '',
      userPhone: data['userPhone'] ?? '',
      gender: data['gender'] ?? '',
      dateOfBirth: data['dateOfBirth'] ?? '',
      address: data['address'] ?? '',
      profileImage: data['profileImage'] ?? '',
      accountCreatedDate: data['accountCreatedDate'] ?? '',
      latitude: data['latitude'].toDouble() ?? 0.0,
      longitude: data['longitude'].toDouble() ?? 0.0,
      orderDrinks: CartModel.fromMap(data['orderDrinks']),
      payableAmount: data['payableAmount'] ?? 0,
      paymentMethod: data['paymentMethod'] ?? '',
      orderName: data['orderName'] ?? '',
      rating: data['rating'] ?? 0,
      orderNumber: data['orderNumber'] ?? 0,
    );
  }
}
