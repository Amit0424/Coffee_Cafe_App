import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:coffee_cafe_app/screens/profile_screen/profile_model/profile_model.dart';
import 'package:coffee_cafe_app/screens/profile_screen/providers/gender_selection_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GenderSelectionWidget extends StatelessWidget {
  const GenderSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final GenderSelectionProvider genderSelectionProvider =
        Provider.of<GenderSelectionProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio<Gender>(
          activeColor: greenColor,
          value: Gender.male,
          groupValue: genderSelectionProvider.selectedGender,
          onChanged: (Gender? value) {
            genderSelectionProvider.setGender(value!);
          },
        ),
        const Text(
          'Male',
          style: TextStyle(color: Colors.black),
        ),
        SizedBox(width: screenWidth(context) * 0.06),
        Radio<Gender>(
          activeColor: greenColor,
          value: Gender.female,
          groupValue: genderSelectionProvider.selectedGender,
          onChanged: (Gender? value) {
            genderSelectionProvider.setGender(value!);
          },
        ),
        const Text(
          'Female',
          style: TextStyle(color: Colors.black),
        ),
        SizedBox(width: screenWidth(context) * 0.06),
        Radio<Gender>(
          activeColor: greenColor,
          value: Gender.other,
          groupValue: genderSelectionProvider.selectedGender,
          onChanged: (Gender? value) {
            genderSelectionProvider.setGender(value!);
          },
        ),
        const Text(
          'Other',
          style: TextStyle(color: Colors.black),
        ),
      ],
    );
  }
}
