import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:coffee_cafe_app/screens/profile_screen/profile_model/profile_model.dart';
import 'package:coffee_cafe_app/screens/profile_screen/providers/gender_selection_provider.dart';
import 'package:coffee_cafe_app/screens/profile_screen/providers/profile_provider.dart';
import 'package:coffee_cafe_app/screens/profile_screen/utils/on_save_function.dart';
import 'package:coffee_cafe_app/screens/profile_screen/widgets/gender_selection_widget.dart';
import 'package:coffee_cafe_app/utils/data_base_constants.dart';
import 'package:coffee_cafe_app/widgets/loading_widget.dart';
import 'package:coffee_cafe_app/widgets/modal_for_two_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../utils/request_permissions.dart';
import '../../utils/take_image.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.buttonName});

  static String routeName = '/profileScreen';
  final String buttonName;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  DateTime? pickedDate = DateTime.now();
  String profileImageUrl = '';
  String backgroundImageUrl = '';
  File profileImagePath = File('');
  File backgroundImagePath = File('');
  bool isProgress = false;

  @override
  initState() {
    super.initState();
    _emailController.text = DBConstants().currentUserEmail();
    _assignDataToFields();
  }

  @override
  Widget build(BuildContext context) {
    final ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context);
    final GenderSelectionProvider genderSelectionProvider =
        Provider.of<GenderSelectionProvider>(context);
    Gender gender = genderSelectionProvider.selectedGender;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
          title: appBarTitle(context, 'Edit Profile'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: ModalProgressHUD(
        inAsyncCall: isProgress,
        progressIndicator: const LoadingWidget(),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                        imageUrl: backgroundImageUrl != ''
                            ? backgroundImageUrl
                            : profileProvider.profileModelMap
                                        .profileBackgroundImageUrl !=
                                    ''
                                ? profileProvider
                                    .profileModelMap.profileBackgroundImageUrl
                                : 'https://assets-global.website-files.com/5a9ee6416e90d20001b20038/6289f5f9c122094a332133d2_dark-gradient.png',
                        fit: BoxFit.fill,
                        progressIndicatorBuilder:
                            (context, child, loadingProgress) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              value: loadingProgress.progress,
                            ),
                          );
                        },
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
                            : profileProvider.profileModelMap.profileImageUrl !=
                                    ''
                                ? CachedNetworkImageProvider(profileProvider
                                    .profileModelMap.profileImageUrl)
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
                        onTap: () {
                          _changePhoto(widget.buttonName);
                        },
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
                        controller: _nameController,
                        decoration:
                            kProfileTextFieldDecoration('Name', context),
                        cursorColor: greenColor,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        onTapOutside: (value) {
                          FocusScope.of(context).unfocus();
                        },
                        onChanged: (value) {
                          _checkAllFieldCompleted(widget.buttonName);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Name is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight(context) * 0.01),
                      TextFormField(
                        controller: _emailController,
                        decoration:
                            kProfileTextFieldDecoration('Email', context),
                        cursorColor: greenColor,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        readOnly: true,
                        onTapOutside: (value) {
                          FocusScope.of(context).unfocus();
                        },
                        onChanged: (value) {
                          _checkAllFieldCompleted(widget.buttonName);
                        },
                      ),
                      SizedBox(height: screenHeight(context) * 0.01),
                      TextFormField(
                        controller: _dateController,
                        decoration: kProfileTextFieldDecoration(
                                'Date Of Birth', context)
                            .copyWith(
                          suffixIcon: widget.buttonName == 'Update'
                              ? const Icon(
                                  Icons.check,
                                  color: greenColor,
                                )
                              : null,
                        ),
                        cursorColor: greenColor,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        onTap: widget.buttonName == 'Update'
                            ? () {}
                            : () => _selectDate(context),
                        onTapOutside: (value) {
                          FocusScope.of(context).unfocus();
                        },
                        onChanged: (value) {
                          _checkAllFieldCompleted(widget.buttonName);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Date of birth is required';
                          }
                          return null;
                        },
                        readOnly: widget.buttonName == 'Update',
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
                          _checkAllFieldCompleted(widget.buttonName);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Mobile number is required';
                          }
                          if (value.length != 10) {
                            return 'Mobile number should be 10 digits';
                          }
                          return null;
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
                      GenderSelectionWidget(
                        checkFunction: () {
                          _checkAllFieldCompleted(widget.buttonName);
                        },
                      ),
                      SizedBox(height: screenHeight(context) * 0.02),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isProgress = true;
                          });
                          onSave(
                            context,
                            widget.buttonName,
                            _formKey,
                            _nameController,
                            _mobileController,
                            _emailController,
                            _dateController,
                            profileImageUrl,
                            backgroundImageUrl,
                          );
                        },
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
      _dateController.text = formattedDate;
    } else {
      pickedDate = DateTime.now();
    }
    _checkAllFieldCompleted(widget.buttonName);
  }

  void _checkAllFieldCompleted(String buttonName) {
    final ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    if (buttonName == 'Save') {
      if (_nameController.text.isNotEmpty &&
          _mobileController.text.length == 10 &&
          _dateController.text.length == 10) {
        profileProvider.setIsAllFieldCompleted(true);
      } else {
        profileProvider.setIsAllFieldCompleted(false);
      }
    }
    if (buttonName == 'Update') {
      final GenderSelectionProvider genderSelectionProvider =
          Provider.of<GenderSelectionProvider>(context, listen: false);
      Gender gender = genderSelectionProvider.selectedGender;
      if ((_nameController.text.isNotEmpty &&
                  _mobileController.text.length == 10 &&
                  _dateController.text.length == 10) &&
              (profileProvider.profileModelMap.name !=
                      _nameController.text.trim() ||
                  profileProvider.profileModelMap.phone !=
                      _mobileController.text.trim() ||
                  profileProvider.profileModelMap.gender != gender) ||
          profileProvider.profileModelMap.profileImageUrl != profileImageUrl ||
          profileProvider.profileModelMap.profileBackgroundImageUrl !=
              backgroundImageUrl) {
        profileProvider.setIsAllFieldCompleted(true);
      } else {
        profileProvider.setIsAllFieldCompleted(false);
      }
    }
  }

  void _changePhoto(String buttonName) {
    requestPermissions(context);
    modalForTwoOptions(
      context,
      () async {
        profileImagePath = await takeImage(ImageSource.gallery);
        if (profileImagePath != File('')) {
          final filePath =
              'coffeeDrinkersData/${DBConstants().userID()}/profileImage/${DateTime.now().millisecondsSinceEpoch}';
          await firebaseStorage.ref(filePath).putFile(profileImagePath);
          final imageUrl = await firebaseStorage.ref(filePath).getDownloadURL();
          profileImageUrl = imageUrl;
          if (buttonName == 'Update') {
            final ProfileProvider profileProvider =
                Provider.of<ProfileProvider>(context, listen: false);
            if (profileImageUrl !=
                profileProvider.profileModelMap.profileImageUrl) {
              _checkAllFieldCompleted('Update');
              profileProvider.profileModelMap.profileImageUrl = profileImageUrl;
              await fireStore
                  .collection('coffeeDrinkers')
                  .doc(DBConstants().userID())
                  .update({
                'profileImageUrl': profileImageUrl,
              });
            }
            setState(() {});
          }
        }
      },
      () async {
        backgroundImagePath = await takeImage(ImageSource.gallery);
        log('backgroundImagePath: $backgroundImagePath');
        if (backgroundImagePath != File('')) {
          final filePath =
              'coffeeDrinkersData/${DBConstants().userID()}/profileBackgroundImage/${DateTime.now().millisecondsSinceEpoch}';
          await firebaseStorage.ref(filePath).putFile(backgroundImagePath);
          final imageUrl = await firebaseStorage.ref(filePath).getDownloadURL();
          backgroundImageUrl = imageUrl;
          if (buttonName == 'Update') {
            final ProfileProvider profileProvider =
                Provider.of<ProfileProvider>(context, listen: false);
            if (backgroundImageUrl !=
                profileProvider.profileModelMap.profileBackgroundImageUrl) {
              _checkAllFieldCompleted('Update');
              profileProvider.profileModelMap.profileBackgroundImageUrl =
                  backgroundImageUrl;
              await fireStore
                  .collection('coffeeDrinkers')
                  .doc(DBConstants().userID())
                  .update({
                'profileBackgroundImageUrl': backgroundImageUrl,
              });
            }
            setState(() {});
          }
        }
      },
      'Which One?',
      'Profile Image',
      'Background Image',
      'profile_photo',
      'background_photo',
    );
  }

  _assignDataToFields() async {
    if (widget.buttonName != 'Save') {
      final ProfileProvider profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
      final GenderSelectionProvider genderSelectionProvider =
          Provider.of<GenderSelectionProvider>(context, listen: false);
      _mobileController.text = profileProvider.profileModelMap.phone;
      _nameController.text = profileProvider.profileModelMap.name;
      _dateController.text = profileProvider.profileModelMap.dateOfBirth;
      backgroundImageUrl =
          profileProvider.profileModelMap.profileBackgroundImageUrl;
      profileImageUrl = profileProvider.profileModelMap.profileImageUrl;
      genderSelectionProvider
          .setDBGender(profileProvider.profileModelMap.gender);
    }
  }
}
