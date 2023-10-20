import 'dart:async';

import 'package:flutter/material.dart';
import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:coffee_cafe_app/data/product_data.dart';
import 'package:coffee_cafe_app/constants/cool_icons.dart';
import 'package:coffee_cafe_app/widgets/custom_app_bar.dart';
import 'package:coffee_cafe_app/widgets/nav_bar.dart';

class CoffeeDetailScreen extends StatefulWidget {
  const CoffeeDetailScreen({
    super.key,
    required this.productImageUrlString,
    required this.productNameString,
    required this.productPriceValue,
    required this.productId,
  });

  final String productImageUrlString;
  final String productNameString;
  final double productPriceValue;
  final String productId;

  @override
  State<CoffeeDetailScreen> createState() => _CoffeeDetailScreenState();
}

class _CoffeeDetailScreenState extends State<CoffeeDetailScreen> {
  int _coffeeCount = 1;
  int _selectedSize = 1;
  bool isAdded = false;

  final StreamController<int> _streamController = StreamController<int>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: CustomAppBar(
        title: widget.productNameString,
        leftIconFunction: () {
          Navigator.pop(context);
        },
        leftIconData: Icons.arrow_back_ios,
        rightIconData: Icons.shopping_cart_outlined,
        rightIconFunction: () {},
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(widget.productImageUrlString),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 370,
              width: double.infinity,
              // margin: const EdgeInsets.only(top: 8.0, bottom: 0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.productNameString,
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Coffee is a beverage prepared from roasted coffee beans.',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          r'$' + widget.productPriceValue.toString(),
                          style: const TextStyle(
                              color: Color(0xff006400),
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Select Size',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: List.generate(4, (index) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _selectedSize = index;
                                      });
                                    },
                                    child: Icon(
                                      const CoolIconsData(0xe951),
                                      color: _selectedSize == index
                                          ? const Color(0xff006400)
                                          : Colors.grey,
                                      size: double.parse(productSize[index]
                                          .iconSize
                                          .toString()),
                                    ),
                                  ),
                                  Text(
                                    productSize[index].sizeName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0),
                                  ),
                                  Text(
                                    '${productSize[index].sizeNumber} fl oz',
                                    style: const TextStyle(
                                        fontSize: 11.0, color: Colors.blueGrey),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 35.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            if (_coffeeCount > 1) {
                              _streamController.sink.add(--_coffeeCount);
                            }
                          },
                          child: Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: BoxDecoration(
                                border: const Border.fromBorderSide(
                                    BorderSide(color: Colors.black)),
                                borderRadius: BorderRadius.circular(30.0)),
                            child: const Center(child: Icon(Icons.remove)),
                          ),
                        ),
                        StreamBuilder(
                            stream: _streamController.stream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  snapshot.data.toString(),
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                );
                              } else {
                                return Text(
                                  _coffeeCount.toString(),
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                );
                              }
                            }),
                        InkWell(
                          onTap: () {
                            _streamController.sink.add(++_coffeeCount);
                          },
                          child: Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: BoxDecoration(
                                border: const Border.fromBorderSide(
                                    BorderSide(color: Colors.black)),
                                borderRadius: BorderRadius.circular(30.0)),
                            child: const Center(child: Icon(Icons.add)),
                          ),
                        ),
                        const SizedBox(
                          width: 20.0,
                        ),
                        InkWell(
                          onTap: () {
                            // DBHelper.insertCart(
                            //   Cart(
                            //     id: widget._productId,
                            //     productId: widget._productId.toString(),
                            //     productName: widget._productNameString,
                            //     initialPrice: widget._productPriceValue,
                            //     productPrice: widget._productPriceValue,
                            //     quantity: _coffeeCount,
                            //     size: selectedSize,
                            //     image: widget._productImageUrlString,
                            //   ),
                            // );
                            // Navigator.pop(context);
                            setState(() {
                              isAdded = !isAdded;
                            });
                          },
                          child: Container(
                            height: 40.0,
                            width: 130.0,
                            decoration: BoxDecoration(
                                color: isAdded ? greenColor : brownColor,
                                borderRadius: BorderRadius.circular(30.0)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                isAdded
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      )
                                    : const SizedBox.shrink(),
                                Center(
                                  child: Text(
                                    isAdded ? 'Added to cart' : 'Add to cart',
                                    style: navBarTextStyle.copyWith(
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
