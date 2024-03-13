import 'package:flutter/material.dart';

import '../../../constants/styling.dart';
import '../../../models/product_model.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  String selectedCategory = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: screenHeight(context) * 0.012),
      padding: EdgeInsets.symmetric(horizontal: screenWidth(context) * 0.022),
      height: screenHeight(context) * 0.075,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: productCategoryList.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 5.0,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 10.0,
            ),
            decoration: BoxDecoration(
              color: selectedCategory == productCategoryList[index]
                  ? greenColor
                  : const Color(0xffcce0cc),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  if (selectedCategory == productCategoryList[index]) {
                    selectedCategory = '';
                  } else {
                    selectedCategory = productCategoryList[index];
                  }
                });
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    productCategoryList[index],
                    style: kNavBarTextStyle.copyWith(
                      color: selectedCategory == productCategoryList[index]
                          ? Colors.white
                          : greenColor,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
