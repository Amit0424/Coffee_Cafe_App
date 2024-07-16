class CartItemModel {
  String productId;
  String productImage;
  String productName;
  double productPrice;
  int productQuantity;
  int productMakingTime;
  String productSize;

  CartItemModel({
    required this.productId,
    required this.productImage,
    required this.productName,
    required this.productPrice,
    required this.productQuantity,
    required this.productMakingTime,
    required this.productSize,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productImage': productImage,
      'productName': productName,
      'productPrice': productPrice,
      'productQuantity': productQuantity,
      'productMakingTime': productMakingTime,
      'productSize': productSize,
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      productId: map['productId'] ?? '',
      productImage: map['productImage'] ?? '',
      productName: map['productName'] ?? '',
      productPrice: (map['productPrice'] ?? 0.0).toDouble(),
      productQuantity: map['productQuantity'] ?? 0,
      productMakingTime: map['productMakingTime'] ?? 0,
      productSize: map['productSize'] ?? '',
    );
  }
}
