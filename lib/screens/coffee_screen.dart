import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_cafe_app/providers/favorite_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:coffee_cafe_app/constants/cool_icons.dart';
import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:coffee_cafe_app/data/product_data.dart';
import 'package:coffee_cafe_app/providers/filter_provider.dart';
import 'package:coffee_cafe_app/screens/coffee_detail_screen.dart';
import 'package:coffee_cafe_app/screens/settings_screen.dart';
import 'package:coffee_cafe_app/widgets/bottom_nav_bar.dart';
import 'package:coffee_cafe_app/widgets/custom_app_bar.dart';
import 'package:coffee_cafe_app/widgets/nav_bar.dart';
import 'package:coffee_cafe_app/models/favorite_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

class CoffeeScreen extends StatefulWidget {
  const CoffeeScreen({super.key});

  static const IconData menuDuo = CoolIconsData(0xe9f8);
  static const IconData settingsFuture = CoolIconsData(0xea42);

  @override
  State<CoffeeScreen> createState() => _CoffeeScreenState();
}

class _CoffeeScreenState extends State<CoffeeScreen> {
  final userID = FirebaseAuth.instance.currentUser!.uid;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _textEditingController = TextEditingController();
  final List<String> selectedCategory = [];
  List<String> favoriteItemIds = [];
  final List<String> productCategories = [
    'Hot Coffees',
    'Cold Coffees',
    'Hot Teas',
    'Iced Teas',
    'Cold Drinks',
    'Hot Drinks'
  ];

  @override
  void initState() {
    super.initState();
    fetchFavorites();
  }

  DateTime timeBackPressed = DateTime.now();

  Future searchData(String param) async {
    Iterable<String> result = productFilter
        .where((element) => element.contains(param.toLowerCase()))
        .cast<String>()
        .toList();

    return result;
  }

  Future<void> fetchFavorites() async {
    final userFavoritesDoc =
        FirebaseFirestore.instance.collection('users').doc(userID);
    final snapshot = await userFavoritesDoc.collection('favorites').get();
    setState(() {
      favoriteItemIds = snapshot.docs.map((doc) => doc.id).toList();
    });
  }

  Future<void> addToFavorites(Item item) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userID);
    await userDoc.collection('favorites').doc(item.id).set(item.toJson());
  }

  Future<void> removeFromFavorites(Item item) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userID);
    await userDoc.collection('favorites').doc(item.id).delete();
  }

  @override
  Widget build(BuildContext context) {
    final favorite = Provider.of<FavoriteProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        final difference = DateTime.now().difference(timeBackPressed);
        final isExitWarning = difference >= const Duration(seconds: 2);
        timeBackPressed = DateTime.now();

        if (isExitWarning) {
          const message = 'Press back again to exit';
          Fluttertoast.showToast(
            msg: message,
            fontSize: 18,
          );
          return false;
        } else {
          return exit(1);
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(
          title: 'Coffee',
          rightIconData: CoffeeScreen.settingsFuture,
          rightIconFunction: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const SettingsScreen()));
          },
          leftIconFunction: () {
            _scaffoldKey.currentState!.openDrawer();
          },
          leftIconData: CoffeeScreen.menuDuo,
        ),
        drawer: const NavBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: _textEditingController,
                    cursorColor: Colors.brown,
                    cursorRadius: const Radius.circular(5.0),
                    // autofocus: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(top: 10.0),
                      hintText: 'Search....',
                      suffixIcon: IconButton(
                        onPressed: () {
                          _textEditingController.clear();
                        },
                        icon: const Icon(Icons.clear),
                      ),
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {},
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.brown),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  suggestionsCallback: (pattern) async {
                    return await searchData(pattern);
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      leading: const Icon(
                        Icons.coffee_rounded,
                        color: greenColor,
                      ),
                      title: Text(
                        suggestion.toString(),
                        style: navBarTextStyle,
                      ),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    _textEditingController.text = suggestion.toString();
                  },
                  hideOnEmpty: false,
                  noItemsFoundBuilder: (context) => const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'No item found.',
                      style: navBarTextStyle,
                    ),
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 5.0),
                  child: Text(
                    'We are happy to serve you!\nEnjoy your cup of coffee with us.',
                    style: TextStyle(
                      fontSize: 14,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                height: 60,
                width: double.infinity,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: productCategories.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          if (selectedCategory
                              .contains(productCategories[index])) {
                            selectedCategory.remove(productCategories[index]);
                          } else {
                            selectedCategory.clear();
                            selectedCategory.add(productCategories[index]);
                          }
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 5.0,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 10.0,
                        ),
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x7a7a7aff),
                              blurRadius: 5,
                            ),
                          ],
                          color: selectedCategory
                                  .contains(productCategories[index])
                              ? greenColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              productCategories[index].toString(),
                              style: navBarTextStyle.copyWith(
                                color: selectedCategory
                                        .contains(productCategories[index])
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CoffeeDetailScreen(
                            productImageUrlString: product.imageUrl,
                            productNameString: product.name,
                            productPriceValue: product.price,
                            productId: product.id,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            color: Color(0x7a7a7aff),
                          )
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(100.0),
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        ),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  height: 160,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      topRight: Radius.circular(100.0),
                                      bottomLeft: Radius.circular(20.0),
                                      bottomRight: Radius.circular(20.0),
                                    ),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        product.imageUrl,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: -8,
                                  top: -8,
                                  child: IconButton(
                                    onPressed: () {
                                      favoriteItemIds.contains(product.id)
                                          ? setState(() async {
                                              await removeFromFavorites(
                                                Item(
                                                  id: product.id,
                                                  name: product.name,
                                                  price: product.price,
                                                  imageUrl: product.imageUrl,
                                                ),
                                              ).then((value) => favorite.removeItemFromFav());
                                              fetchFavorites();
                                            })
                                          : setState(() async {
                                              await addToFavorites(
                                                Item(
                                                  id: product.id,
                                                  name: product.name,
                                                  price: product.price,
                                                  imageUrl: product.imageUrl,
                                                ),
                                              ).then((value) => favorite.addItemInFav());
                                              fetchFavorites();
                                            });
                                    },
                                    icon: Icon(
                                      favoriteItemIds.contains(product.id)
                                          ? Icons.favorite
                                          : Icons.favorite_border_outlined,
                                      color: Colors.green,
                                      size: 30,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 6.0, left: 8.0, right: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    product.name,
                                    style: productNameTextStyle,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    r'$' + product.price.toString(),
                                    style: productPriceTextStyle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, bottom: 4.0),
                              child: Text(
                                'Coffee is a beverage prepared from roasted coffee beans. Darkly colored, bitter, and slightly acidic, coffee has a stimulating effect on humans, primarily due to its caffeine content. It has the highest sales in the world market for hot drinks.',
                                style: TextStyle(
                                  fontSize: 8,
                                  color: Colors.grey[500],
                                ),
                                softWrap: false,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavBar(),
      ),
    );
  }
}
