import 'package:coffee_cafe_app/screens/product_screen/product_model/utils/product_category.dart';

class ProductModel {
  String id;
  String imageUrl;
  Category category;
  String name;
  String description;
  double price;
  bool inStock;
  bool isVisible;

  ProductModel({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.id,
    required this.category,
    required this.inStock,
    required this.isVisible,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json['name'],
      description: json['description'],
      price: double.parse(json['price'].toString()),
      imageUrl: json['image'],
      id: json['id'],
      category: getCategory(json['category']),
      inStock: json['inStock'],
      isVisible: json['isVisible'],
    );
  }
}
