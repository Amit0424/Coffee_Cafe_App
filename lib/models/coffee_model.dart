import 'package:uuid/uuid.dart';

class Product {
  final String id;
  final String imageUrl;
  final String name;
  final double price;
  final bool isHotCoffee;
  final bool isColdCoffee;
  final bool isHotTea;
  final bool isColdTea;
  final bool isHotDrink;
  final bool isColdDrink;
  bool isInCart;

  Product({
    String? id,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.isHotCoffee,
    required this.isColdCoffee,
    required this.isHotTea,
    required this.isColdTea,
    required this.isHotDrink,
    required this.isColdDrink,
    required this.isInCart,
  }) : id = id ?? const Uuid().v4();
}
