import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/styling.dart';
import '../../../main.dart';

void deleteMessage(BuildContext context, String id) async {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          padding: EdgeInsets.all(screenHeight(context) * 0.016),
          height: screenHeight(context) * 0.22,
          width: screenWidth(context) * 0.8,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/svgs/naughty_man.svg',
                    height: screenHeight(context) * 0.08,
                  ),
                  SizedBox(
                    width: screenWidth(context) * 0.45,
                    child: Text(
                      'Hmm hmm... What did you type?',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'inter',
                        fontSize: screenHeight(context) * 0.016,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth(context) * 0.026),
                child: Text(
                  'Do you really want to delete this message?',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'inter',
                    fontSize: screenHeight(context) * 0.016,
                  ),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'No',
                      style: TextStyle(
                        color: redColor,
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth(context) * 0.05),
                  TextButton(
                    onPressed: () {
                      fireStore.collection('globalChats').doc(id).update({
                        'isDeleted': true,
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Message deleted'),
                        ),
                      );
                    },
                    child: const Text(
                      'Yes',
                      style: TextStyle(
                        color: greenColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth(context) * 0.05),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
