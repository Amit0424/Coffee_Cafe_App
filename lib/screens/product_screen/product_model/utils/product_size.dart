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
