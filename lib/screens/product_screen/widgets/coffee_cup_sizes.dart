import 'package:coffee_cafe_app/screens/product_screen/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../constants/styling.dart';
import '../product_model/utils/product_size.dart';

class CoffeeCupSizes extends StatelessWidget {
  const CoffeeCupSizes({
    super.key,
    required this.sizeNumber,
    required this.sizeName,
    required this.size,
    required this.onTap,
  });
  final String sizeNumber;
  final String sizeName;
  final double size;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final ProductProvider productProvider =
        Provider.of<ProductProvider>(context);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          SvgPicture.asset('assets/images/svgs/coffee_cup.svg',
              height: screenHeight(context) * size,
              color: productProvider.productSize == getProductSize(sizeName)
                  ? greenColor
                  : iconColor),
          Text(
            sizeName,
            style: TextStyle(
              color: matteBlackColor,
              fontSize: screenHeight(context) * 0.012,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$sizeNumber fl oz',
            style: TextStyle(
              color: matteBlackColor,
              fontSize: screenHeight(context) * 0.010,
            ),
          ),
        ],
      ),
    );
  }
}
