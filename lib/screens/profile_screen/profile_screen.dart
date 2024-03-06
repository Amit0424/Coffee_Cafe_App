import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_cafe_app/constants/cool_icons.dart';
import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:coffee_cafe_app/screens/profile_screen/profile_model/profile_model.dart';
import 'package:coffee_cafe_app/screens/setting_screen/settings_screen.dart';
import 'package:coffee_cafe_app/widgets/custom_app_bar.dart';
import 'package:coffee_cafe_app/widgets/profile_camera_icon_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static String routeName = '/profileScreen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _mobileController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  File? newImage;
  XFile? image;
  late String imageUrl;
  final picker = ImagePicker();

  @override
  initState() {
    _nameController.text = profile.name;
    _mobileController.text = profile.phoneNumber;
    _emailController.text = profile.email;
    super.initState();
  }

  Future<void> _takeImage(bool isProfile) async {
    if (isProfile) {
      setState(() {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        image = await picker.pickImage(
                          preferredCameraDevice: CameraDevice.front,
                          source: ImageSource.camera,
                        );
                      },
                      icon: const Icon(Icons.camera_alt),
                    ),
                    IconButton(
                      onPressed: () async {
                        image =
                            await picker.pickImage(source: ImageSource.gallery);
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.image),
                    ),
                  ],
                ),
              );
            });
      });
    } else {
      image = await picker.pickImage(source: ImageSource.gallery);
    }

    if (image == null) {
      return;
    }

    final dir = await getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/temp.jpg';

    final result = await FlutterImageCompress.compressAndGetFile(
      image!.path,
      targetPath,
      minHeight: 1080,
      minWidth: 1080,
      quality: 35,
    );

    newImage = File(result!.path);

    if (newImage != null) {
      String filePath =
          'partner_document_media/$userId/${isProfile ? 'profileImage' : 'profileBackgroundImage'}/${DateTime.now().millisecondsSinceEpoch}';
      await FirebaseStorage.instance.ref(filePath).putFile(newImage!);
      imageUrl = await FirebaseStorage.instance.ref(filePath).getDownloadURL();
      if (isProfile) {
        FirebaseFirestore.instance.collection('users').doc(userId).update({
          'profileImageUrl': imageUrl,
        });
      } else {
        FirebaseFirestore.instance.collection('users').doc(userId).update({
          'profileBackgroundImageUrl': imageUrl,
        });
      }
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      setState(() {
        if (isProfile) {
          profile.profileImageUrl = userDoc['profileImageUrl'];
        } else {
          profile.profileBackgroundImageUrl =
              userDoc['profileBackgroundImageUrl'];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        rightIconData: const CoolIconsData(0xea42),
        rightIconFunction: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (ctx) => const SettingsScreen()));
        },
        leftIconFunction: () {
          Navigator.pop(context);
        },
        leftIconData: Icons.arrow_back_ios,
        title: 'Profile',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 250,
                  width: screenWidth,
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 4,
                        offset: Offset(0, 2), // Shadow position
                      ),
                    ],
                  ),
                  child: CachedNetworkImage(
                    imageUrl: profile.profileBackgroundImageUrl,
                    fit: BoxFit.fill,
                    placeholder: (context, url) => Image.asset(
                      'assets/images/profile_background.jpg',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 180, left: screenWidth / 2 - 60),
                  child: PhysicalModel(
                    color: Colors.grey,
                    elevation: 6,
                    shadowColor: Colors.grey,
                    borderRadius: const BorderRadius.all(Radius.circular(60)),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.redAccent,
                      backgroundImage: const CachedNetworkImageProvider(
                          'https://www.shareicon.net/data/512x512/2016/09/15/829459_man_512x512.png'),
                      foregroundImage:
                          CachedNetworkImageProvider(profile.profileImageUrl),
                    ),
                  ),
                ),
                Positioned(
                  right: screenWidth / 2 - 80,
                  bottom: 0,
                  child: ProfileCameraIconWidget(
                    color: const Color(0xffefefef),
                    takeImage: () {
                      _takeImage(true);
                    },
                  ),
                ),
                Positioned(
                  right: 5,
                  bottom: 60,
                  child: ProfileCameraIconWidget(
                    color: const Color(0x44efefef),
                    takeImage: () {
                      _takeImage(false);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: TextField(
                controller: _emailController,
                decoration: kProfileTextFieldDecoration('EMAIL ADDRESS'),
                style: const TextStyle(fontWeight: FontWeight.bold),
                readOnly: true,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: TextField(
                controller: _nameController,
                decoration: kProfileTextFieldDecoration('NAME'),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            // const SizedBox(height: 10),
            // Padding(
            //   padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            //   child: TextField(
            //     decoration: kProfileTextFieldDecoration('DATE OF BIRTH'),
            //     style: const TextStyle(fontWeight: FontWeight.bold),
            //   ),
            // ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: TextField(
                controller: _mobileController,
                decoration: kProfileTextFieldDecoration('MOBILE'),
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLength: 10,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: ElevatedButton(
                onPressed: _onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: brownColor,
                  fixedSize: Size(
                    screenWidth - 20,
                    60,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _onSave() {
    if (profile.name != _nameController.text ||
        profile.phoneNumber != _mobileController.text) {
      if (_nameController.text.isEmpty) {
        Fluttertoast.showToast(msg: "Name can't be empty!");
      }
      if (_mobileController.text.length != 10) {
        Fluttertoast.showToast(msg: 'Number is too short!');
      }
      if (_nameController.text.isNotEmpty &&
          _mobileController.text.length == 10) {
        FirebaseFirestore.instance.collection('users').doc(userId).update({
          'name': _nameController.text,
          'phoneNumber': _mobileController.text,
        });
        profile.name = _nameController.text;
        profile.phoneNumber = _mobileController.text;
        Navigator.pop(context);
      }
    } else {
      Fluttertoast.showToast(msg: 'Nothing Changed!');
    }
  }
}
