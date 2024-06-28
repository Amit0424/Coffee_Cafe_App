import 'dart:developer';

import 'package:coffee_cafe_app/screens/home_screen/widgets/category_cards.dart';
import 'package:coffee_cafe_app/screens/home_screen/widgets/nav_bar.dart';
import 'package:coffee_cafe_app/screens/home_screen/widgets/newly_added_products.dart';
import 'package:coffee_cafe_app/screens/home_screen/widgets/quote.dart';
import 'package:coffee_cafe_app/screens/rating_screen/rating_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:page_transition/page_transition.dart';

import '../../constants/cool_icons.dart';
import '../../constants/styling.dart';
import '../../main.dart';
import '../../utils/data_base_constants.dart';
import '../../utils/request_permissions.dart';
import '../cart_screen/models/cart_item_model.dart';
import '../cart_screen/models/cart_model.dart';
import '../orders_screen/models/order_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static String routeName = '/newHomeScreen';

  static const IconData menuDuo = CoolIconsData(0xe9f8);
  static const IconData settingsFuture = CoolIconsData(0xea42);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _searchEditingController =
      TextEditingController();
  final productForRating = OrderModel(
    userId: 's3yWeax9pigjDWhTOnZBU3VIgf92',
    orderId: 'e0040d5c-8d50-4c62-a3be-67519df9b9f7',
    orderTime: DateTime.now(),
    orderStatus: 'Served',
    userName: 'Amit Chaudhary',
    userEmail: 'amitjat2406@gmail.com',
    userPhone: '8561911466',
    gender: 'male',
    dateOfBirth: '24/06/2001',
    address: 'Unnamed Road Bagru Khurd India 302026',
    profileImage:
        'https://firebasestorage.googleapis.com/v0/b/coffee-cafe-app-45ff3.appspot.com/o/coffeeDrinkersData%2Fs3yWeax9pigjDWhTOnZBU3VIgf92%2FprofileImage%2F1710071135308?alt=media&token=a537806c-43ae-43af-8417-94d7b14af465',
    accountCreatedDate: '10/03/2024',
    latitude: 26.8259603,
    longitude: 75.6274567,
    orderDrinks: CartModel(
      cartItems: [
        CartItemModel(
          productName: 'Cappuccino on Ice',
          productPrice: 833,
          productQuantity: 2,
          productId: "DVg8YszwNiDo90rrfdw2",
          productImage:
              'https://t4.ftcdn.net/jpg/01/65/14/79/360_F_165147980_fVaQRDJysuSC8XWVpHfCVZFWMF6SrsjM.jpg',
          productMakingTime: 13,
          productSize: 'Venti',
        ),
        CartItemModel(
          productName: 'Minty Iced Green Tea',
          productPrice: 347,
          productQuantity: 1,
          productId: "yVB5CpOJhW49HunnzBDt",
          productImage:
              'https://firebasestorage.googleapis.com/v0/b/coffee-cafe-app-45ff3.appspot.com/o/coffeeDrinkersData%2Fs3yWeax9pigjDWhTOnZBU3VIgf92%2Fcart%2F1710071135308?alt=media&token=3b3b3b3b-3b3b-3b3b-3b3b-3b3b3b3b3b3b',
          productMakingTime: 19,
          productSize: 'Grande',
        ),
      ],
    ),
    payableAmount: 1242,
    paymentMethod: 'Cash',
    orderName: 'My Order',
    rating: 0,
    orderNumber: 100006,
  );

  @override
  void initState() {
    super.initState();
    requestLocationPermission(context);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      // App is in the background
      log('App is in the background');
      // Perform your task here
    } else if (state == AppLifecycleState.resumed) {
      // App is in the foreground
      log('App is in the foreground');
      // Perform your task here
      await fireStore
          .collection('coffeeDrinkers')
          .doc(DBConstants().userID())
          .update({
        'lastOnline': DateTime.now(),
        'isOnline': true,
      });
    } else if (state == AppLifecycleState.inactive) {
      // App is inactive (could be closing or switching apps)
      log('App is inactive');
      // Perform your task here
      await fireStore
          .collection('coffeeDrinkers')
          .doc(DBConstants().userID())
          .update({
        'lastOnline': DateTime.now(),
        'isOnline': false,
      });
    } else if (state == AppLifecycleState.detached) {
      // App is being terminated
      log('App is detached');
      // Perform your task here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 3,
        shadowColor: Colors.grey[300],
        surfaceTintColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
          icon: Icon(
            HomeScreen.menuDuo,
            color: matteBlackColor,
          ),
        ),
        title: appBarTitle(context, 'Coffee Cafe'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  PageTransition(
                      child: RatingScreen(productForRating: productForRating),
                      type: PageTransitionType.bottomToTop));
            },
            icon: Icon(
              HomeScreen.settingsFuture,
              color: matteBlackColor,
            ),
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          SizedBox(
            height: screenHeight(context) * 0.02,
          ),
          Container(
            height: screenHeight(context) * 0.05,
            padding:
                EdgeInsets.symmetric(horizontal: screenWidth(context) * 0.038),
            child: TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _searchEditingController,
                cursorColor: Colors.brown,
                cursorRadius: const Radius.circular(5.0),
                decoration: searchBarDecoration.copyWith(
                  suffixIcon: IconButton(
                    onPressed: () {
                      if (_searchEditingController.text.isNotEmpty) {
                        _searchEditingController.clear();
                      }
                      FocusScope.of(context).unfocus();
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ),
                onTapOutside: (value) {
                  FocusScope.of(context).unfocus();
                },
              ),
              suggestionsCallback: (pattern) async {
                // return await searchData(pattern);
                Iterable<String> list = [
                  'Hot Coffee',
                  'Cold Coffee',
                  'Iced Tea',
                  'Hot Tea'
                ];
                return list;
              },
              onSuggestionSelected: (suggestion) {
                _searchEditingController.text = suggestion.toString();
                // applyFilter(suggestion.toString());
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
              noItemsFoundBuilder: (context) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'No item found.',
                  style: kNavBarTextStyle,
                ),
              ),
            ),
          ),
          SizedBox(
            height: screenHeight(context) * 0.02,
          ),
          const Quote(),
          // const CategoryList(),
          SizedBox(
            height: screenHeight(context) * 0.02,
          ),
          const NewlyAddedProducts(),
          SizedBox(
            height: screenHeight(context) * 0.01,
          ),
          Container(
            padding: EdgeInsets.symmetric(
                vertical: screenHeight(context) * 0.01,
                horizontal: screenWidth(context) * 0.045),
            width: screenWidth(context),
            child: Text(
              'Categories',
              style: TextStyle(
                  color: greenColor,
                  fontSize: screenHeight(context) * 0.016,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'inter'),
            ),
          ),
          const Expanded(child: CategoryCards()),
        ],
      ),
    );
  }
}
