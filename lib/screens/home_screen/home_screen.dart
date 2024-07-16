import 'dart:developer';

import 'package:coffee_cafe_app/providers/cache_provider.dart';
import 'package:coffee_cafe_app/screens/home_screen/widgets/category_cards.dart';
import 'package:coffee_cafe_app/screens/home_screen/widgets/nav_bar.dart';
import 'package:coffee_cafe_app/screens/home_screen/widgets/newly_added_products.dart';
import 'package:coffee_cafe_app/screens/home_screen/widgets/quote.dart';
import 'package:coffee_cafe_app/screens/setting_screen/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../constants/cool_icons.dart';
import '../../constants/styling.dart';
import '../../main.dart';
import '../../utils/data_base_constants.dart';
import '../../utils/request_permissions.dart';
import '../rating_screen/utils/check_last_product_rating.dart';

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
    final CacheProvider cacheProvider = Provider.of<CacheProvider>(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (cacheProvider.categoryList.isNotEmpty) {
        checkLastProductRating(context);
      }
    });
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
                      child: const SettingsScreen(),
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
