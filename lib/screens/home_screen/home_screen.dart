import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_cafe_app/constants/cool_icons.dart';
import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:coffee_cafe_app/data/product_data.dart';
import 'package:coffee_cafe_app/models/coffee_model.dart';
import 'package:coffee_cafe_app/providers/filter_provider.dart';
import 'package:coffee_cafe_app/screens/coffee_detail_screen/coffee_detail_screen.dart';
import 'package:coffee_cafe_app/screens/favorite_screen/favorite_model/favorite_model.dart';
import 'package:coffee_cafe_app/screens/favorite_screen/favorite_providers/favorite_provider.dart';
import 'package:coffee_cafe_app/screens/home_screen/widgets/nav_bar.dart';
import 'package:coffee_cafe_app/screens/setting_screen/settings_screen.dart';
import 'package:coffee_cafe_app/widgets/bottom_nav_bar.dart';
import 'package:coffee_cafe_app/widgets/custom_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static String routeName = '/homeScreen';

  static const IconData menuDuo = CoolIconsData(0xe9f8);
  static const IconData settingsFuture = CoolIconsData(0xea42);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  DateTime timeBackPressed = DateTime.now();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _textEditingController = TextEditingController();
  late AnimationController _animationController;
  List<Product> filteredProducts = products;
  String filter = 'All';
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
    applyFilter('All');

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
      lowerBound: 0,
      upperBound: 1,
    );

    _animationController.forward();
    _requestPermissions();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    PermissionStatus status = await Permission.storage.request();
    PermissionStatus locationStatus = await Permission.location.request();
  }

  void applyFilter(String filter) {
    setState(() {
      this.filter = filter;
      if (filter == 'Hot Coffees') {
        filteredProducts =
            products.where((product) => product.isHotCoffee).toList();
      } else if (filter == 'Cold Coffees') {
        filteredProducts =
            products.where((product) => product.isColdCoffee).toList();
      } else if (filter == 'Hot Teas') {
        filteredProducts =
            products.where((product) => product.isHotTea).toList();
      } else if (filter == 'Iced Teas') {
        filteredProducts =
            products.where((product) => product.isColdTea).toList();
      } else if (filter == 'Cold Drinks') {
        filteredProducts =
            products.where((product) => product.isColdDrink).toList();
      } else if (filter == 'Hot Drinks') {
        filteredProducts =
            products.where((product) => product.isHotDrink).toList();
      } else {
        filteredProducts = products;
      }
    });
  }

  Future searchData(String param) async {
    Iterable<String> result = productFilter
        .where((element) => element.contains(param.toLowerCase()))
        .cast<String>()
        .toList();

    return result;
  }

  Future<void> fetchFavorites() async {
    final userFavoritesDoc =
        FirebaseFirestore.instance.collection('users').doc(userId);
    final snapshot = await userFavoritesDoc.collection('favorites').get();
    setState(() {
      favoriteItemIds = snapshot.docs.map((doc) => doc.id).toList();
    });
  }

  Future<void> addToFavorites(Item item) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    await userDoc.collection('favorites').doc(item.id).set(item.toJson());
  }

  Future<void> removeFromFavorites(Item item) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
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
          rightIconData: HomeScreen.settingsFuture,
          rightIconFunction: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const SettingsScreen()));
          },
          rightIconColor: Colors.transparent,
          leftIconFunction: () {
            _scaffoldKey.currentState!.openDrawer();
          },
          leftIconData: HomeScreen.menuDuo,
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
                      labelText: 'Search...',
                      labelStyle: kNavBarTextStyle.copyWith(
                          fontWeight: FontWeight.w500),
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
                  onSuggestionSelected: (suggestion) {
                    _textEditingController.text = suggestion.toString();
                    applyFilter(suggestion.toString());
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      leading: const Icon(
                        Icons.coffee_rounded,
                        color: greenColor,
                      ),
                      title: Text(
                        suggestion.toString(),
                        style: kNavBarTextStyle,
                      ),
                    );
                  },
                  hideOnEmpty: false,
                  noItemsFoundBuilder: (context) => const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'No item found.',
                      style: kNavBarTextStyle,
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
                            applyFilter('All');
                          } else {
                            selectedCategory.clear();
                            applyFilter('All');
                            selectedCategory.add(productCategories[index]);
                            applyFilter(productCategories[index]);
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
                              style: kNavBarTextStyle.copyWith(
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
              if (filteredProducts.isEmpty)
                const Center(
                  child: Text(
                    "Sorry, We don't have this",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: greenColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) => SlideTransition(
                  position: Tween(
                    begin: const Offset(0, 0.3),
                    end: const Offset(0, 0),
                  ).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: Curves.easeInOut,
                    ),
                  ),
                  child: child,
                ),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
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
                            topRight: Radius.circular(0.0),
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
                                        topRight: Radius.circular(0.0),
                                        bottomLeft: Radius.circular(20.0),
                                        bottomRight: Radius.circular(20.0),
                                      ),
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(
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
                                        fetchFavorites();
                                        favoriteItemIds.contains(product.id)
                                            ? setState(() async {
                                                if (favoriteItemIds
                                                    .isNotEmpty) {
                                                  await removeFromFavorites(
                                                    Item(
                                                      id: product.id,
                                                      name: product.name,
                                                      price: product.price,
                                                      imageUrl:
                                                          product.imageUrl,
                                                    ),
                                                  ).then((value) => favorite
                                                      .removeItemFromFav());
                                                }
                                              })
                                            : setState(() async {
                                                await addToFavorites(
                                                  Item(
                                                    id: product.id,
                                                    name: product.name,
                                                    price: product.price,
                                                    imageUrl: product.imageUrl,
                                                  ),
                                                ).then((value) =>
                                                    favorite.addItemInFav());
                                              });
                                        fetchFavorites();
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      product.name,
                                      style: kProductNameTextStyle,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      r'$' + product.price.toString(),
                                      style: kProductPriceTextStyle,
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
                                padding: const EdgeInsets.only(
                                    left: 8.0, bottom: 4.0),
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
