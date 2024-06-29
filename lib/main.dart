import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_cafe_app/providers/cache_provider.dart';
import 'package:coffee_cafe_app/providers/location_provider.dart';
import 'package:coffee_cafe_app/screens/authentication_screen/authentication_screen.dart';
import 'package:coffee_cafe_app/screens/authentication_screen/providers/authentication_provider.dart';
import 'package:coffee_cafe_app/screens/cart_screen/providers/cart_provider.dart';
import 'package:coffee_cafe_app/screens/friends_screen/providers/friend_provider.dart';
import 'package:coffee_cafe_app/screens/parent_screen/parent_screen.dart';
import 'package:coffee_cafe_app/screens/parent_screen/providers/parent_provider.dart';
import 'package:coffee_cafe_app/screens/product_screen/providers/product_provider.dart';
import 'package:coffee_cafe_app/screens/profile_screen/profile_model/profile_model.dart';
import 'package:coffee_cafe_app/screens/profile_screen/profile_screen.dart';
import 'package:coffee_cafe_app/screens/profile_screen/providers/gender_selection_provider.dart';
import 'package:coffee_cafe_app/screens/profile_screen/providers/profile_provider.dart';
import 'package:coffee_cafe_app/screens/rating_screen/providers/rating_provider.dart';
import 'package:coffee_cafe_app/utils/data_base_constants.dart';
import 'package:coffee_cafe_app/utils/send_location_to_DB.dart';
import 'package:coffee_cafe_app/widgets/loading_widget.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
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
  await FirebaseAppCheck.instance.activate();
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
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        ChangeNotifierProvider(create: (context) => LocationProvider()),
        ChangeNotifierProvider(create: (context) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (context) => GenderSelectionProvider()),
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => ParentProvider()),
        ChangeNotifierProvider(create: (context) => CacheProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => FriendProvider()),
        ChangeNotifierProvider(create: (context) => RatingProvider()),
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
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee Cafe App',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
        useMaterial3: true,
        fontFamily: 'futura',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      debugShowCheckedModeBanner: false,
      home: AuthService().handleAuth(),
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
    final ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context);
    final GenderSelectionProvider genderSelectionProvider =
        Provider.of<GenderSelectionProvider>(context);
    return StreamBuilder(
      stream: fireStore
          .collection('coffeeDrinkers')
          .doc(DBConstants().userID())
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          DocumentSnapshot documentSnapshot = snapshot.data;

          if (documentSnapshot.exists) {
            final ProfileModel profileModel =
                ProfileModel.fromDocument(documentSnapshot);
            profileProvider.setProfileModelMap(profileModel);
            genderSelectionProvider
                .setDBGender(profileProvider.profileModelMap.gender);
            return const ParentScreen();
          } else {
            return const ProfileScreen(buttonName: 'Save');
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
