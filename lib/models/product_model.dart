enum Category {
  hotCoffee,
  coldCoffee,
  icedTea,
  hotTea,
  smoothie,
  milkshake,
  soda,
  juice,
}

getCategory(String category) {
  switch (category) {
    case 'Hot Coffee':
      return Category.hotCoffee;
    case 'Cold Coffee':
      return Category.coldCoffee;
    case 'Iced Tea':
      return Category.icedTea;
    case 'Hot Tea':
      return Category.hotTea;
    case 'Smoothie':
      return Category.smoothie;
    case 'Milkshake':
      return Category.milkshake;
    case 'Soda':
      return Category.soda;
    case 'Juice':
      return Category.juice;
    default:
      return Category.hotCoffee;
  }
}

class ProductModel {
  String id;
  String imageUrl;
  Category category;
  String name;
  String description;
  double price;

  ProductModel(
      {required this.name,
      required this.description,
      required this.price,
      required this.imageUrl,
      required this.id,
      required this.category});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
        name: json['name'],
        description: json['description'],
        price: json['price'],
        imageUrl: json['image'],
        id: json['id'],
        category: getCategory(json['category']));
  }
}
