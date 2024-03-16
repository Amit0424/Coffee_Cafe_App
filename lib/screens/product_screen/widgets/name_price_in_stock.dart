import 'package:flutter/material.dart';

import '../../../constants/styling.dart';

class NamePriceInStock extends StatelessWidget {
  const NamePriceInStock({
    super.key,
    required this.productName,
    required this.productPrice,
    required this.productInStock,
  });
  final String productName;
  final double productPrice;
  final bool productInStock;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment:
          productInStock ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: screenWidth(context) * 0.66,
          height: screenHeight(context) * 0.07,
          child: Text(
            productName,
            style: TextStyle(
              color: matteBlackColor,
              fontSize: screenHeight(context) * 0.025,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
          ),
        ),
        SizedBox(
          width: screenWidth(context) * 0.22,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              productInStock ? '₹$productPrice' : 'Out of Stock',
              style: TextStyle(
                color: productInStock ? greenColor : redColor,
                fontSize: productInStock
                    ? screenHeight(context) * 0.025
                    : screenHeight(context) * 0.013,
                fontWeight: productInStock ? FontWeight.w500 : FontWeight.bold,
                fontFamily: productInStock ? 'inter' : 'futura',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
