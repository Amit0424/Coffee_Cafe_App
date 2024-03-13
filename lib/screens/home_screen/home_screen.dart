import 'dart:developer';

import 'package:coffee_cafe_app/screens/home_screen/widgets/category_list.dart';
import 'package:coffee_cafe_app/screens/home_screen/widgets/nav_bar.dart';
import 'package:coffee_cafe_app/screens/home_screen/widgets/quote.dart';
import 'package:coffee_cafe_app/screens/home_screen/widgets/random_products_page.dart';
import 'package:coffee_cafe_app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../constants/cool_icons.dart';
import '../../constants/styling.dart';
import '../authentication_screen/widgets/exit_dialog.dart';
import '../setting_screen/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static String routeName = '/newHomeScreen';

  static const IconData menuDuo = CoolIconsData(0xe9f8);
  static const IconData settingsFuture = CoolIconsData(0xea42);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _searchEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (value) {
        if (value) {
          return;
        }
        showExitDialog(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: CustomAppBar(
          title: 'Coffee',
          rightIconData: HomeScreen.settingsFuture,
          rightIconFunction: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const SettingsScreen()));
          },
          rightIconColor: matteBlackColor,
          leftIconFunction: () {
            _scaffoldKey.currentState!.openDrawer();
          },
          leftIconData: HomeScreen.menuDuo,
          leftIconColor: matteBlackColor,
        ),
        drawer: const CustomDrawer(),
        body: Column(
          children: [
            Container(
              height: screenHeight(context) * 0.05,
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth(context) * 0.038),
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
                  log(pattern);
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
            const CategoryList(),
            SizedBox(
              height: screenHeight(context) * 0.02,
            ),
            SizedBox(
                height: screenHeight(context) * 0.6,
                child: const RandomProductsPage()),
          ],
        ),
      ),
    );
  }
}
