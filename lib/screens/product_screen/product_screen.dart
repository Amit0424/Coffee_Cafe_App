import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:coffee_cafe_app/screens/cart_screen/models/cart_model.dart';
import 'package:coffee_cafe_app/screens/product_screen/product_model/product_model.dart';
import 'package:coffee_cafe_app/screens/product_screen/product_model/utils/product_category.dart';
import 'package:coffee_cafe_app/screens/product_screen/product_model/utils/product_size.dart';
import 'package:coffee_cafe_app/screens/product_screen/providers/product_provider.dart';
import 'package:coffee_cafe_app/screens/product_screen/utils/add_to_cart_function.dart';
import 'package:coffee_cafe_app/screens/product_screen/widgets/add_to_cart_button.dart';
import 'package:coffee_cafe_app/screens/product_screen/widgets/cup_selection_text.dart';
import 'package:coffee_cafe_app/screens/product_screen/widgets/description.dart';
import 'package:coffee_cafe_app/screens/product_screen/widgets/image_frame.dart';
import 'package:coffee_cafe_app/screens/product_screen/widgets/increase_decrease_button.dart';
import 'package:coffee_cafe_app/screens/product_screen/widgets/name_price_in_stock.dart';
import 'package:coffee_cafe_app/screens/product_screen/widgets/order_now_button.dart';
import 'package:coffee_cafe_app/screens/product_screen/widgets/read_more.dart';
import 'package:coffee_cafe_app/screens/product_screen/widgets/select_size.dart';
import 'package:coffee_cafe_app/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../cart_screen/models/cart_item_model.dart';
import '../place_order_screen/place_order_screen.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key, required this.productModel});
  final ProductModel productModel;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool _isInAsyncCall = false;

  @override
  void initState() {
    super.initState();
    final ProductProvider productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    productProvider.setProductSize(ProductSize.tall);
    productProvider.setProductQuantity(1);
  }

  @override
  Widget build(BuildContext context) {
    final ProductProvider productProvider =
        Provider.of<ProductProvider>(context);
    productProvider.productPrice = widget.productModel.price;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        progressIndicator: const LoadingWidget(),
        child: Column(
          children: [
            ImageFrame(
              productImage: widget.productModel.imageUrl,
              productCategory: getCategoryString(widget.productModel.category),
              productMakingMinutes: widget.productModel.makingTime,
              productId: widget.productModel.id,
              zFavoriteUsersList: widget.productModel.favoriteList,
            ),
            SizedBox(height: screenHeight(context) * 0.02),
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: screenWidth(context) * 0.06),
              child: Column(
                children: [
                  NamePriceInStock(
                    productName: widget.productModel.name,
                    productPrice: productProvider.productPrice,
                    productInStock: widget.productModel.inStock,
                  ),
                  Description(
                      productDescription: widget.productModel.description),
                  ReadMore(productDescription: widget.productModel.description),
                  SizedBox(height: screenHeight(context) * 0.01),
                  const CupSelectionText(name: 'Size'),
                  const SelectSize(),
                  SizedBox(height: screenHeight(context) * 0.02),
                  const CupSelectionText(name: 'Quantity'),
                ],
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IncreaseDecreaseButton(
                  onPressed: () {
                    productProvider.decreaseProductQuantity =
                        widget.productModel.price;
                  },
                  icon: Icons.remove,
                ),
                SizedBox(
                  width: screenWidth(context) * 0.05,
                  height: screenHeight(context) * 0.05,
                  child: Center(
                    child: Text(
                      productProvider.productQuantity.toString(),
                      style: TextStyle(
                        color: greenColor,
                        fontSize: screenHeight(context) * 0.03,
                        fontFamily: 'inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                IncreaseDecreaseButton(
                  onPressed: () {
                    if (productProvider.productQuantity < 4) {
                      productProvider.increaseProductQuantity =
                          widget.productModel.price;
                    } else {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'You can only add 4 items of the same product'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  icon: Icons.add,
                ),
              ],
            ),
            SizedBox(height: screenHeight(context) * 0.01),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AddToCartButton(
                  productInStock: widget.productModel.inStock,
                  onPressed: () {
                    if (widget.productModel.inStock) {
                      setState(() {
                        _isInAsyncCall = true;
                      });
                      addProductToCart({
                        'productId': widget.productModel.id,
                        'productName': widget.productModel.name,
                        'productPrice': productProvider.productPrice,
                        'productSize':
                            getProductSizeString(productProvider.productSize),
                        'productQuantity': productProvider.productQuantity,
                        'productImage': widget.productModel.imageUrl,
                        'productMakingTime': widget.productModel.makingTime,
                      }, 'Add to Cart');
                      setState(() {
                        _isInAsyncCall = false;
                      });
                    } else {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Drink is out of stock'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                ),
                OrderNowButton(
                  productInStock: widget.productModel.inStock,
                  onPressed: () {
                    if (widget.productModel.inStock) {
                      CartModel cartModel = CartModel(
                        cartItems: [
                          CartItemModel(
                            productId: widget.productModel.id,
                            productImage: widget.productModel.imageUrl,
                            productName: widget.productModel.name,
                            productPrice: productProvider.productPrice,
                            productQuantity: productProvider.productQuantity,
                            productMakingTime: widget.productModel.makingTime,
                            productSize: getProductSizeString(
                                productProvider.productSize),
                          ),
                        ],
                      );
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.bottomToTop,
                          duration: const Duration(milliseconds: 600),
                          child: PlaceOrderScreen(
                            products: cartModel,
                            isFromCart: false,
                            totalAmount: productProvider.productPrice,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Drink is out of stock'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: screenHeight(context) * 0.01),
          ],
        ),
      ),
    );
  }
}
