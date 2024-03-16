import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:coffee_cafe_app/screens/add_product_screen/add_product_screen.dart';
import 'package:coffee_cafe_app/screens/add_product_screen/list_products.dart';
import 'package:coffee_cafe_app/screens/profile_screen/providers/profile_provider.dart';
import 'package:coffee_cafe_app/widgets/custom_app_bar.dart';
import 'package:coffee_cafe_app/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  static String routeName = '/settingsScreen';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isShowSpinner = false;

  void signOut() async {
    setState(() {
      isShowSpinner = !isShowSpinner;
    });
    // try {
    //   FirebaseAuth.instance.signOut();
    // } on FirebaseAuthException {
    //   ScaffoldMessenger.of(context).clearSnackBars();
    //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //       content: Text('Error Occurred! Please try again later.')));
    // }
    //
    // setState(() {
    //   isShowSpinner = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    final ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Settings',
        rightIconData: Icons.person_2_outlined,
        rightIconFunction: () {},
        rightIconColor: Colors.transparent,
        leftIconFunction: () {
          Navigator.of(context).pop();
        },
        leftIconData: Icons.arrow_back_ios_new,
        leftIconColor: matteBlackColor,
      ),
      body: ModalProgressHUD(
        inAsyncCall: isShowSpinner,
        progressIndicator: const LoadingWidget(),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(
                Icons.menu,
                color: Colors.black,
              ),
              title: Text(
                'General',
                style: kNavBarTextStyle,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(
                Icons.language_outlined,
                color: Colors.black,
              ),
              title: Text(
                'Languages',
                style: kNavBarTextStyle,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(
                Icons.password_outlined,
                color: Colors.black,
              ),
              title: Text(
                'Change Password',
                style: kNavBarTextStyle,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.black,
              ),
              title: Text(
                'Sign Out',
                style: kNavBarTextStyle,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
              ),
              onTap: signOut,
            ),
            profileProvider.profileModelMap['email'] == 'amitjat2406@gmail.com'
                ? ListTile(
                    leading: const Icon(
                      Icons.add_shopping_cart,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Add Product',
                      style: kNavBarTextStyle,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => const AddProductScreen()));
                    },
                  )
                : const SizedBox.shrink(),
            profileProvider.profileModelMap['email'] == 'amitjat2406@gmail.com'
                ? ListTile(
                    leading: const Icon(
                      Icons.add_shopping_cart,
                      color: Colors.black,
                    ),
                    title: Text(
                      'List of Products',
                      style: kNavBarTextStyle,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => const ListProducts()));
                    },
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
