import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_cafe_app/screens/authentication_screen/authentication_screen.dart';
import 'package:coffee_cafe_app/screens/cart_screen/cart_providers/cart_provider.dart';
import 'package:coffee_cafe_app/screens/cart_screen/cart_screen.dart';
import 'package:coffee_cafe_app/screens/coffee_detail_screen/coffee_detail_screen.dart';
import 'package:coffee_cafe_app/screens/contact_us_screen/contact_us_screen.dart';
import 'package:coffee_cafe_app/screens/favorite_screen/favorite_providers/favorite_provider.dart';
import 'package:coffee_cafe_app/screens/favorite_screen/favorite_screen.dart';
import 'package:coffee_cafe_app/screens/global_chat_screen/chat_screen.dart';
import 'package:coffee_cafe_app/screens/home_screen/home_screen.dart';
import 'package:coffee_cafe_app/screens/order_placed_screen/order_placed_screen.dart';
import 'package:coffee_cafe_app/screens/profile_screen/profile_screen.dart';
import 'package:coffee_cafe_app/screens/setting_screen/settings_screen.dart';
import 'package:coffee_cafe_app/utils/data_base_constants.dart';
import 'package:coffee_cafe_app/widgets/loading_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

final firebaseAuth = FirebaseAuth.instance;
final firebaseStorage = FirebaseStorage.instance;
final fireStore = FirebaseFirestore.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FavoriteProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    log('Amit');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee Cafe App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: AuthService().handleAuth(),
      routes: {
        AuthenticationScreen.routeName: (ctx) => const AuthenticationScreen(),
        CartScreen.routeName: (ctx) => const CartScreen(),
        CoffeeDetailScreen.routeName: (ctx) => const CoffeeDetailScreen(
              productImageUrlString: '',
              productNameString: '',
              productPriceValue: 0,
              productId: '',
            ),
        ContactUsScreen.routeName: (ctx) => const ContactUsScreen(),
        FavoriteScreen.routeName: (ctx) => const FavoriteScreen(),
        ChatScreen.routeName: (ctx) => const ChatScreen(),
        HomeScreen.routeName: (ctx) => const HomeScreen(),
        OrderPlacedScreen.routeName: (ctx) => const OrderPlacedScreen(),
        ProfileScreen.routeName: (ctx) => const ProfileScreen(),
        SettingsScreen.routeName: (ctx) => const SettingsScreen(),
      },
    );
  }
}

class AuthService {
  //Handles Authentication
  handleAuth() {
    return StreamBuilder(
      stream: firebaseAuth.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return const AuthenticationScreen();
          } else {
            return const UserHasData();
          }
        } else {
          return const Scaffold(
            body: Center(
              child: LoadingWidget(),
            ),
          );
        }
      },
    );
  }
}

class UserHasData extends StatelessWidget {
  const UserHasData({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: fireStore
          .collection(DBConstants().userCollectionName())
          .doc(DBConstants().userID())
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.active &&
            snapshot.hasData) {
          DocumentSnapshot documentSnapshot = snapshot.data;

          if (documentSnapshot.exists) {
            return const HomeScreen();
          } else {
            return const ProfileScreen();
          }
        }
        return const Scaffold(
          body: Center(
            child: LoadingWidget(),
          ),
        );
      },
    );
  }
}
