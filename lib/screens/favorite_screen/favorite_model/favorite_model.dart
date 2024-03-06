class Item {
  final String id;
  final String name;
  final String imageUrl;
  final double price;

  Item({
    required this.imageUrl,
    required this.price,
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
    };
  }

  static Item fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      price: json['price'],
    );
  }
}
