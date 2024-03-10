import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_cafe_app/constants/cool_icons.dart';
import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:coffee_cafe_app/screens/profile_screen/profile_model/profile_model.dart';
import 'package:coffee_cafe_app/screens/profile_screen/providers/gender_selection_provider.dart';
import 'package:coffee_cafe_app/screens/profile_screen/providers/profile_provider.dart';
import 'package:coffee_cafe_app/screens/profile_screen/widgets/gender_selection_widget.dart';
import 'package:coffee_cafe_app/utils/data_base_constants.dart';
import 'package:coffee_cafe_app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.buttonName});

  static String routeName = '/profileScreen';
  final String buttonName;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  DateTime? pickedDate = DateTime.now();
  String profileImageUrl = '';
  Gender gender = Gender.male;

  File? newImage;
  XFile? image;
  late String imageUrl;
  final picker = ImagePicker();

  @override
  initState() {
    super.initState();
    _emailController.text = DBConstants().currentUserEmail();
    _assignDataToTextFormFields();
  }

  _assignDataToTextFormFields() async {
    if (widget.buttonName != 'Save') {
      final ProfileProvider profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
      _mobileController.text = profileProvider.profileModelMap['phone'];
      _nameController.text = profileProvider.profileModelMap['name'];
    }
  }

  // Future<void> _takeImage(bool isProfile) async {
  //   if (isProfile) {
  //     setState(() {
  //       showDialog(
  //           context: context,
  //           builder: (context) {
  //             return AlertDialog(
  //               content: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                 children: [
  //                   IconButton(
  //                     onPressed: () async {
  //                       Navigator.pop(context);
  //                       image = await picker.pickImage(
  //                         preferredCameraDevice: CameraDevice.front,
  //                         source: ImageSource.camera,
  //                       );
  //                     },
  //                     icon: const Icon(Icons.camera_alt),
  //                   ),
  //                   IconButton(
  //                     onPressed: () async {
  //                       image =
  //                           await picker.pickImage(source: ImageSource.gallery);
  //                       Navigator.pop(context);
  //                     },
  //                     icon: const Icon(Icons.image),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           });
  //     });
  //   } else {
  //     image = await picker.pickImage(source: ImageSource.gallery);
  //   }
  //
  //   if (image == null) {
  //     return;
  //   }
  //
  //   final dir = await getTemporaryDirectory();
  //   final targetPath = '${dir.absolute.path}/temp.jpg';
  //
  //   final result = await FlutterImageCompress.compressAndGetFile(
  //     image!.path,
  //     targetPath,
  //     minHeight: 1080,
  //     minWidth: 1080,
  //     quality: 35,
  //   );
  //
  //   newImage = File(result!.path);
  //
  //   if (newImage != null) {
  //     String filePath =
  //         'partner_document_media/$userId/${isProfile ? 'profileImage' : 'profileBackgroundImage'}/${DateTime.now().millisecondsSinceEpoch}';
  //     await FirebaseStorage.instance.ref(filePath).putFile(newImage!);
  //     imageUrl = await FirebaseStorage.instance.ref(filePath).getDownloadURL();
  //     if (isProfile) {
  //       FirebaseFirestore.instance.collection('users').doc(userId).update({
  //         'profileImageUrl': imageUrl,
  //       });
  //     } else {
  //       FirebaseFirestore.instance.collection('users').doc(userId).update({
  //         'profileBackgroundImageUrl': imageUrl,
  //       });
  //     }
  //     DocumentSnapshot userDoc = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(userId)
  //         .get();
  //     // setState(() {
  //     //   if (isProfile) {
  //     //     profile.profileImageUrl = userDoc['profileImageUrl'];
  //     //   } else {
  //     //     profile.profileBackgroundImageUrl =
  //     //         userDoc['profileBackgroundImageUrl'];
  //     //   }
  //     // });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context);
    final GenderSelectionProvider genderSelectionProvider =
        Provider.of<GenderSelectionProvider>(context);
    Gender gender = genderSelectionProvider.selectedGender;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        rightIconData: const CoolIconsData(0xea42),
        rightIconFunction: () {},
        rightIconColor: Colors.transparent,
        leftIconFunction: () {
          Navigator.pop(context);
        },
        leftIconData: Icons.arrow_back_ios,
        title: 'Profile',
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: screenHeight(context) * 0.2,
                    width: screenWidth(context),
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
                      imageUrl: profileProvider
                              .profileModelMap['profileBackgroundImageUrl'] ??
                          'https://assets-global.website-files.com/5a9ee6416e90d20001b20038/6289f5f9c122094a332133d2_dark-gradient.png',
                      fit: BoxFit.fill,
                      placeholder: (context, url) => Shimmer(
                        direction: ShimmerDirection.ltr,
                        gradient: const LinearGradient(
                          colors: [
                            greenColor,
                            brownColor,
                            brownishWhite,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        child: SizedBox(
                          height: screenHeight(context) * 0.2,
                          width: screenWidth(context),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 3,
                    right: 3,
                    child: CircleAvatar(
                      backgroundImage: AssetImage(
                          'assets/images/pngs/${gender == Gender.female ? 'girl' : gender == Gender.male ? 'boy' : 'other'}_profile.png'),
                      radius: screenHeight(context) * 0.04,
                      backgroundColor: Colors.transparent,
                      foregroundImage: profileImageUrl != ''
                          ? CachedNetworkImageProvider(profileImageUrl)
                          : profileProvider.profileModelMap['profileUrl'] !=
                                      null &&
                                  profileProvider
                                          .profileModelMap['profileUrl'] !=
                                      ''
                              ? CachedNetworkImageProvider(
                                  profileProvider.profileModelMap['profileUrl'])
                              : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight(context) * 0.02),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth(context) * 0.04),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Text(
                        'Change Photo',
                        style: TextStyle(
                          color: matteBlackColor,
                          fontSize: screenHeight(context) * 0.016,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight(context) * 0.03),
                    TextFormField(
                      controller: _emailController,
                      decoration: kProfileTextFieldDecoration('Email', context),
                      cursorColor: greenColor,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      readOnly: true,
                      onTapOutside: (value) {
                        FocusScope.of(context).unfocus();
                      },
                      onChanged: (value) {
                        _checkAllFieldCompleted();
                      },
                    ),
                    SizedBox(height: screenHeight(context) * 0.01),
                    TextFormField(
                      controller: _nameController,
                      decoration: kProfileTextFieldDecoration('Name', context),
                      cursorColor: greenColor,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      onTapOutside: (value) {
                        FocusScope.of(context).unfocus();
                      },
                      onChanged: (value) {
                        _checkAllFieldCompleted();
                      },
                    ),
                    SizedBox(height: screenHeight(context) * 0.01),
                    TextFormField(
                      controller: _dateController,
                      decoration:
                          kProfileTextFieldDecoration('Date Of Birth', context),
                      cursorColor: greenColor,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      onTap: () => _selectDate(context),
                      onTapOutside: (value) {
                        FocusScope.of(context).unfocus();
                      },
                      onChanged: (value) {
                        _checkAllFieldCompleted();
                      },
                    ),
                    SizedBox(height: screenHeight(context) * 0.01),
                    TextFormField(
                      controller: _mobileController,
                      decoration:
                          kProfileTextFieldDecoration('Mobile', context),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      cursorColor: greenColor,
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      onTapOutside: (value) {
                        FocusScope.of(context).unfocus();
                      },
                      onChanged: (value) {
                        _checkAllFieldCompleted();
                      },
                    ),
                    SizedBox(height: screenHeight(context) * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Gender',
                          style: TextStyle(
                            color: matteBlackColor,
                            fontSize: screenHeight(context) * 0.016,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const GenderSelectionWidget(),
                    SizedBox(height: screenHeight(context) * 0.02),
                    ElevatedButton(
                      onPressed: _onSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: profileProvider.isAllFieldCompleted
                            ? greenColor
                            : greenColor.withOpacity(0.4),
                        elevation: 0,
                        fixedSize: Size(screenWidth(context) * 0.4,
                            screenHeight(context) * 0.05),
                        minimumSize: Size(screenWidth(context) * 0.3,
                            screenHeight(context) * 0.04),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        shadowColor: brownColor,
                      ),
                      child: Text(
                        widget.buttonName,
                        style: TextStyle(
                          fontSize: screenHeight(context) * 0.02,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: pickedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    pickedDate = picked;
    if (picked != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate!);
      setState(() {
        _dateController.text = formattedDate;
      });
    } else {
      pickedDate = DateTime.now();
    }
    _checkAllFieldCompleted();
  }

  void _checkAllFieldCompleted() {
    final ProfileProvider loadingProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    log('name: ${_nameController.text}, phone: ${_mobileController.text}, date: ${_dateController.text}');
    if (_nameController.text.isNotEmpty &&
        _mobileController.text.length == 10 &&
        _dateController.text.length == 10) {
      loadingProvider.setIsAllFieldCompleted(true);
    } else {
      loadingProvider.setIsAllFieldCompleted(false);
    }
  }

  _onSave() {}
}
