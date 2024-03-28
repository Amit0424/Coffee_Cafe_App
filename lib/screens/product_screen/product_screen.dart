import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:coffee_cafe_app/main.dart';
import 'package:coffee_cafe_app/screens/place_order_screen/place_order_screen.dart';
import 'package:coffee_cafe_app/screens/product_screen/product_model/utils/product_size.dart';
import 'package:coffee_cafe_app/screens/product_screen/providers/product_provider.dart';
import 'package:coffee_cafe_app/screens/product_screen/widgets/add_to_cart_button.dart';
import 'package:coffee_cafe_app/screens/product_screen/widgets/cup_selection_text.dart';
import 'package:coffee_cafe_app/screens/product_screen/widgets/description.dart';
import 'package:coffee_cafe_app/screens/product_screen/widgets/image_frame.dart';
import 'package:coffee_cafe_app/screens/product_screen/widgets/increase_decrease_button.dart';
import 'package:coffee_cafe_app/screens/product_screen/widgets/name_price_in_stock.dart';
import 'package:coffee_cafe_app/screens/product_screen/widgets/order_now_button.dart';
import 'package:coffee_cafe_app/screens/product_screen/widgets/read_more.dart';
import 'package:coffee_cafe_app/screens/product_screen/widgets/select_size.dart';
import 'package:coffee_cafe_app/utils/data_base_constants.dart';
import 'package:coffee_cafe_app/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({
    super.key,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productDescription,
    required this.productImage,
    required this.productCategory,
    required this.productMakingMinutes,
    required this.productInStock,
    required this.zFavoriteUsersList,
  });
  final String productId;
  final String productName;
  final double productPrice;
  final String productDescription;
  final String productImage;
  final String productCategory;
  final int productMakingMinutes;
  final bool productInStock;
  final List zFavoriteUsersList;

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
    productProvider.productPrice = widget.productPrice;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        progressIndicator: const LoadingWidget(),
        child: Column(
          children: [
            ImageFrame(
              productImage: widget.productImage,
              productCategory: widget.productCategory,
              productMakingMinutes: widget.productMakingMinutes,
              onTap: () {
                setState(() {
                  if (widget.zFavoriteUsersList
                      .contains(DBConstants().userID())) {
                    fireStore
                        .collection('products')
                        .doc(widget.productId)
                        .update({
                      'zFavoriteUsersList':
                          FieldValue.arrayRemove([DBConstants().userID()])
                    });
                    widget.zFavoriteUsersList.remove(DBConstants().userID());
                    Fluttertoast.showToast(msg: 'Removed from Favorite');
                  } else {
                    fireStore
                        .collection('products')
                        .doc(widget.productId)
                        .update({
                      'zFavoriteUsersList':
                          FieldValue.arrayUnion([DBConstants().userID()])
                    });
                    widget.zFavoriteUsersList.add(DBConstants().userID());
                    Fluttertoast.showToast(msg: 'Added to Favorite');
                  }
                });
              },
              iconName:
                  widget.zFavoriteUsersList.contains(DBConstants().userID())
                      ? 'solid_'
                      : '',
            ),
            SizedBox(height: screenHeight(context) * 0.02),
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: screenWidth(context) * 0.06),
              child: Column(
                children: [
                  NamePriceInStock(
                    productName: widget.productName,
                    productPrice: productProvider.productPrice,
                    productInStock: widget.productInStock,
                  ),
                  Description(productDescription: widget.productDescription),
                  ReadMore(productDescription: widget.productDescription),
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
                        widget.productPrice;
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
                    productProvider.increaseProductQuantity =
                        widget.productPrice;
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
                  onPressed: () async {
                    addProductToCart({
                      'productId': widget.productId,
                      'productName': widget.productName,
                      'productPrice': productProvider.productPrice,
                      'productSize':
                          getProductSizeString(productProvider.productSize),
                      'productQuantity': productProvider.productQuantity,
                    }, 'Add to Cart');
                  },
                ),
                OrderNowButton(
                  onPressed: () {
                    addProductToCart({
                      'productId': widget.productId,
                      'productName': widget.productName,
                      'productPrice': productProvider.productPrice,
                      'productSize':
                          getProductSizeString(productProvider.productSize),
                      'productQuantity': productProvider.productQuantity,
                    }, 'Order Now');
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

  Future<void> addProductToCart(
      Map<String, dynamic> product, String buttonName) async {
    setState(() {
      _isInAsyncCall = true;
    });
    final DocumentReference userCartRef =
        fireStore.collection('userCart').doc(DBConstants().userID());

    final DocumentSnapshot userCartSnapshot = await userCartRef.get();
    if (userCartSnapshot.exists) {
      Map<String, dynamic>? data =
          userCartSnapshot.data() as Map<String, dynamic>?;
      List<Map<String, dynamic>> cartItems =
          List<Map<String, dynamic>>.from(data?['cartItems'] ?? []);

      bool productExists = false;
      int index = -1;
      for (int i = 0; i < cartItems.length; i++) {
        if (cartItems[i]['productId'] == product['productId'] &&
            cartItems[i]['productSize'] == product['productSize']) {
          productExists = true;
          index = i;
          break;
        }
      }

      if (productExists) {
        if (cartItems[index]['productQuantity'] != product['productQuantity']) {
          cartItems[index]['productQuantity'] = product['productQuantity'];
          cartItems[index]['productPrice'] = product['productPrice'];
          await userCartRef.update({'cartItems': cartItems});
          if (buttonName == 'Add to Cart') {
            Fluttertoast.showToast(
              msg: 'Quantity changed to ${product['productQuantity']}',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          }
        } else {
          if (buttonName == 'Add to Cart') {
            Fluttertoast.showToast(
              msg: 'Already in cart',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          }
        }
      } else {
        cartItems.add(product);
        await userCartRef.update({'cartItems': cartItems});
        if (buttonName == 'Add to Cart') {
          Fluttertoast.showToast(
            msg: 'Added to cart',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      }
    } else {
      await userCartRef.set({
        'cartItems': [product],
      });
      if (buttonName == 'Add to Cart') {
        Fluttertoast.showToast(
          msg: 'Added to cart',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    }
    setState(() {
      _isInAsyncCall = false;
    });
    if (buttonName == 'Order Now') {
      Navigator.push(context,
          MaterialPageRoute(builder: (ctx) => const PlaceOrderScreen()));
    }
  }
}
