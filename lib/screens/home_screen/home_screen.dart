import 'package:coffee_cafe_app/screens/home_screen/widgets/category_cards.dart';
import 'package:coffee_cafe_app/screens/home_screen/widgets/nav_bar.dart';
import 'package:coffee_cafe_app/screens/home_screen/widgets/newly_added_products.dart';
import 'package:coffee_cafe_app/screens/home_screen/widgets/quote.dart';
import 'package:coffee_cafe_app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../constants/cool_icons.dart';
import '../../constants/styling.dart';
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          Container(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth(context) * 0.045),
              height: screenHeight(context) * 0.395,
              width: screenWidth(context),
              child: const CategoryCards()),
        ],
      ),
    );
  }
}
