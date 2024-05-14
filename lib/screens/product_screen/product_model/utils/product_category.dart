List<String> productCategoryList = [
  'Hot Coffee',
  'Cold Coffee',
  'Iced Tea',
  'Hot Tea',
  'Smoothie',
  'Milkshake',
  'Soda',
  'Juice'
];

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

String getCategoryString(Category category) {
  switch (category) {
    case Category.hotCoffee:
      return 'Hot Coffee';
    case Category.coldCoffee:
      return 'Cold Coffee';
    case Category.icedTea:
      return 'Iced Tea';
    case Category.hotTea:
      return 'Hot Tea';
    case Category.smoothie:
      return 'Smoothie';
    case Category.milkshake:
      return 'Milkshake';
    case Category.soda:
      return 'Soda';
    case Category.juice:
      return 'Juice';
    default:
      return 'Hot Coffee';
  }
}
