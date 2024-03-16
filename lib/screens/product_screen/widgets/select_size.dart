import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/styling.dart';
import '../product_model/utils/product_size.dart';
import '../providers/product_provider.dart';
import 'coffee_cup_sizes.dart';

class SelectSize extends StatelessWidget {
  const SelectSize({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductProvider productProvider =
        Provider.of<ProductProvider>(context);
    return SizedBox(
      height: screenHeight(context) * 0.16,
      width: screenWidth(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CoffeeCupSizes(
              sizeNumber: '8',
              sizeName: 'Short',
              size: 0.06,
              onTap: () {
                productProvider.productSize = ProductSize.short;
              }),
          CoffeeCupSizes(
              sizeNumber: '12',
              sizeName: 'Tall',
              size: 0.08,
              onTap: () {
                productProvider.productSize = ProductSize.tall;
              }),
          CoffeeCupSizes(
              sizeNumber: '16',
              sizeName: 'Grande',
              size: 0.1,
              onTap: () {
                productProvider.productSize = ProductSize.grande;
              }),
          CoffeeCupSizes(
              sizeNumber: '20',
              sizeName: 'Venti',
              size: 0.12,
              onTap: () {
                productProvider.productSize = ProductSize.venti;
              }),
        ],
      ),
    );
  }
}
