import 'package:coffee_cafe_app/models/coffee_model.dart';

List<Product> products = [
  Product(
    id: 'p1',
    name: 'Black',
    price: 5,
    imageUrl:
        'https://media.istockphoto.com/id/157528129/photo/mug-on-plate-filled-with-coffee-surrounded-by-coffee-beans.jpg?s=612x612&w=0&k=20&c=W_za-myO9QP_dimiJeZXsR4G2GHjrdo0RTyO3yVhopQ=',
    isHotCoffee: true,
    isColdCoffee: false,
    isHotTea: false,
    isColdTea: false,
    isHotDrink: true,
    isColdDrink: false,
  ),
  Product(
    id: 'p2',
    name: 'Latte',
    price: 8,
    imageUrl:
        'https://media.istockphoto.com/id/505168330/photo/cup-of-cafe-latte-with-coffee-beans-and-cinnamon-sticks.jpg?s=612x612&w=0&k=20&c=h7v8kAfWOpRapv6hrDwmmB54DqrGQWxlhP_mTeqTQPA=',
    isHotCoffee: true,
    isColdCoffee: false,
    isHotTea: false,
    isColdTea: false,
    isHotDrink: true,
    isColdDrink: true,
  ),
  Product(
    id: 'p3',
    name: 'Cappuccino',
    price: 6,
    imageUrl:
        'https://upload.wikimedia.org/wikipedia/commons/c/c8/Cappuccino_at_Sightglass_Coffee.jpg',
    isHotCoffee: true,
    isColdCoffee: false,
    isHotTea: false,
    isColdTea: false,
    isHotDrink: true,
    isColdDrink: true,
  ),
  Product(
    id: 'p4',
    name: 'Americano',
    price: 8,
    imageUrl: 'https://wallpapercave.com/wp/wp9571900.jpg',
    isHotCoffee: false,
    isColdCoffee: true,
    isHotTea: false,
    isColdTea: false,
    isHotDrink: false,
    isColdDrink: true,
  ),
  Product(
    id: 'p5',
    name: 'Espresso',
    price: 7,
    imageUrl:
        'https://media.istockphoto.com/id/1126871442/photo/coffee-cup.jpg?s=612x612&w=0&k=20&c=Jp8v8YqgT9ws-lMN6qiMZmpp5rGlsBpaRCeMS_DmzKs=',
    isHotCoffee: false,
    isColdCoffee: true,
    isHotTea: false,
    isColdTea: false,
    isHotDrink: false,
    isColdDrink: true,
  ),
  Product(
    id: 'p6',
    name: 'Doppio',
    price: 4,
    imageUrl:
        'https://127137217.cdn6.editmysite.com/uploads/1/2/7/1/127137217/s818321954983044400_p75_i3_w3600.jpeg?width=2560',
    isHotCoffee: true,
    isColdCoffee: false,
    isHotTea: false,
    isColdTea: false,
    isHotDrink: true,
    isColdDrink: true,
  ),
  Product(
    id: 'p7',
    name: 'Cortado',
    price: 5,
    imageUrl:
        'https://www.bonvivantcaffe.com/wp-content/uploads/2023/02/cortado-glass.jpg',
    isHotCoffee: true,
    isColdCoffee: false,
    isHotTea: false,
    isColdTea: false,
    isHotDrink: true,
    isColdDrink: true,
  ),
  Product(
    id: 'p8',
    name: 'Red Eye',
    price: 3,
    imageUrl:
        'https://cofinfo.com/wp-content/uploads/2023/06/Red-Eye-Coffee-1.png.webp',
    isHotCoffee: false,
    isColdCoffee: true,
    isHotTea: false,
    isColdTea: false,
    isHotDrink: false,
    isColdDrink: true,
  ),
  Product(
    id: 'p9',
    name: 'Galao',
    price: 8,
    imageUrl:
        'https://upload.wikimedia.org/wikipedia/commons/0/06/Gal%C3%A3o.jpg',
    isHotCoffee: false,
    isColdCoffee: true,
    isHotTea: false,
    isColdTea: false,
    isHotDrink: false,
    isColdDrink: true,
  ),
  Product(
    id: 'p10',
    name: 'Lungo',
    price: 7,
    imageUrl:
        'https://coffeelevels.com/wp-content/uploads/2022/01/Gran-lungo.webp',
    isHotCoffee: true,
    isColdCoffee: false,
    isHotTea: false,
    isColdTea: false,
    isHotDrink: true,
    isColdDrink: true,
  ),
  Product(
    id: 'p11',
    name: 'Mocha',
    price: 8,
    imageUrl:
        'https://images.immediate.co.uk/production/volatile/sites/2/2021/11/Mocha-1fc71f7.png?resize=960,872',
    isHotCoffee: false,
    isColdCoffee: true,
    isHotTea: false,
    isColdTea: false,
    isHotDrink: false,
    isColdDrink: true,
  ),
];

class ProductSize {
  final String sizeName;
  final int iconSize;
  final int sizeNumber;

  ProductSize(
      {required this.sizeName,
      required this.iconSize,
      required this.sizeNumber});
}

final List<ProductSize> productSize = [
  ProductSize(sizeName: 'Short', iconSize: 35, sizeNumber: 8),
  ProductSize(sizeName: 'Tall', iconSize: 50, sizeNumber: 12),
  ProductSize(sizeName: 'Grande', iconSize: 65, sizeNumber: 16),
  ProductSize(sizeName: 'Venti', iconSize: 80, sizeNumber: 20),
];
