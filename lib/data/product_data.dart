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
