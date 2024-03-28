enum ProductSize {
  short,
  tall,
  grande,
  venti,
}

getProductSize(String size) {
  switch (size) {
    case 'Short':
      return ProductSize.short;
    case 'Tall':
      return ProductSize.tall;
    case 'Grande':
      return ProductSize.grande;
    case 'Venti':
      return ProductSize.venti;
    default:
      return ProductSize.tall;
  }
}

getProductSizeString(ProductSize size) {
  switch (size) {
    case ProductSize.short:
      return 'Short';
    case ProductSize.tall:
      return 'Tall';
    case ProductSize.grande:
      return 'Grande';
    case ProductSize.venti:
      return 'Venti';
    default:
      return 'Tall';
  }
}
